//
//  AFSegmentedWeekControl.m
//  AFCalendarControl
//
//  Created by Keith Duncan on 01/09/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "AFSegmentedWeekControl.h"

#import <objc/runtime.h>

#import "AFWeekSegmentCell.h"

#define MAX_WEEKDAYS 7

@interface AFSegmentedWeekControl ()
@property (retain) NSString *stringValue;

@property (retain) NSPointerArray *values;
@property (assign) NSUInteger sections;
@property (retain) NSIndexSet *selectedSections;

@property (assign) BOOL tracking;
@property (assign) CGPoint initialEventLocation, lastEventLocation;
@end

@implementation AFSegmentedWeekControl

@synthesize dataSource=_dataSource;
@synthesize values=_values;
@synthesize sections=_sections;
@synthesize selectedSections=_selectedSections;
@synthesize tracking=_tracking;
@synthesize initialEventLocation=_initialEventLocation, lastEventLocation=_lastEventLocation;

+ (Class)cellClass {
	return [AFWeekSegmentCell class];
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self == nil) return nil;
	
	self.values = [NSPointerArray pointerArrayWithStrongObjects];
	self.sections = 7;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	NSArray *weekdays = [formatter veryShortStandaloneWeekdaySymbols];
	[self setStringValue:[weekdays componentsJoinedByString:@""]];
	
	[formatter release];
	
	return self;
}

- (void)awakeFromNib {
	[self reloadData];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.values = nil;
	self.selectedSections = nil;
	
	[super dealloc];
}

- (void)viewWillMoveToSuperview:(NSView *)view {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[[self superview] window]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:[[self superview] window]];
	
	[super viewWillMoveToSuperview:view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidResignKeyNotification object:[view window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidBecomeKeyNotification object:[view window]];
}

- (void)reloadData {
	if (self.dataSource == nil) return;
	
	NSMutableIndexSet *newSelectedDays = [NSMutableIndexSet indexSet];
	
	for (NSUInteger currentIndex = 0; currentIndex < MAX_WEEKDAYS; currentIndex++) {
		AFWeekday weekday = (currentIndex+1);
		if (![self.dataSource weekview:self isEnabledForDay:weekday]) continue;
		
		[newSelectedDays addIndex:weekday];
	}
	
	self.selectedSections = newSelectedDays;
	[self setNeedsDisplay:YES];
}

- (void)setSections:(NSUInteger)value {
	Ivar valueIvar = object_getInstanceVariable(self, "_sections", NULL);
	ptrdiff_t offset = ivar_getOffset(valueIvar);
	
	NSUInteger *valueRef = (void *)((int8_t *)self + offset);
	*valueRef = value;
	
	[self.values setCount:value];
	
	[self setNeedsDisplay:YES];
}

- (NSString *)stringValue {
	return [[self.values allObjects] componentsJoinedByString:@""];
}

- (void)setStringValue:(NSString *)value {
	if ([value length] > self.sections) [NSException raise:NSRangeException format:@"%s, passed a string too large to display", __PRETTY_FUNCTION__, nil];
	
	for (NSUInteger index = 0; index < [value length]; index++)
		[self.values replacePointerAtIndex:index withPointer:[value substringWithRange:NSMakeRange(index, 1)]];
	
	[self setNeedsDisplay:YES];
}

NS_INLINE void _AFSegmentedWeekControlCalculateRatio(CGFloat height, CGFloat *sectionWidth, CGFloat *sectionGap) {
	*sectionWidth = (height * 0.85);
	*sectionGap = (height * 0.17);
}

NS_INLINE CGFloat WidthForValues(NSUInteger count, CGFloat width, CGFloat gap) {
	return (count * width) + ((count - 1) * gap);
}

NS_INLINE void _AFSegmentedWeekControlValuesForWidth(NSRect bounds, NSUInteger count, CGFloat *sectionHeight, CGFloat *sectionWidth, CGFloat *sectionGap) {
	_AFSegmentedWeekControlCalculateRatio(1.0, sectionWidth, sectionGap);
	CGFloat unitWidth = WidthForValues(count, *sectionWidth, *sectionGap);
	
	CGFloat scaleFactor = MIN(NSWidth(bounds)/unitWidth, NSHeight(bounds)/1.0);
	
	*sectionHeight = scaleFactor;
	*sectionWidth *= scaleFactor;
	*sectionGap *= scaleFactor;
}

NS_INLINE NSRectArray _AFSegmentedWeekControlCreateSectionRects(NSRect bounds, NSUInteger count) {
	CGFloat sectionHeight, sectionWidth, sectionGap;
	_AFSegmentedWeekControlValuesForWidth(bounds, count, &sectionHeight, &sectionWidth, &sectionGap);
	
	NSRectArray sectionRects = calloc(count, sizeof(NSRect));
	
	NSPoint origin = bounds.origin;
	for (NSUInteger index = 0; index < count; index++) {
		sectionRects[index] = (NSRect){origin, sectionWidth, sectionHeight};
		origin.x += (sectionWidth + sectionGap);
	}
	
	return sectionRects;
}

- (void)resetCursorRects {
	NSRectArray sectionRects = _AFSegmentedWeekControlCreateSectionRects([self bounds], self.sections);
	
	for (NSUInteger index = 0; index < self.sections; index++) {
		[self addCursorRect:sectionRects[index] cursor:[NSCursor pointingHandCursor]];
	}
	
	free(sectionRects);
}

- (NSUInteger)_indexForEventPoint:(NSPoint)point {
	point = [self convertPoint:point fromView:nil];
	NSRectArray sectionRects = _AFSegmentedWeekControlCreateSectionRects([self bounds], self.sections);
	
	NSUInteger pointIndex = NSNotFound;
	for (NSUInteger currentIndex = 0; currentIndex < self.sections; currentIndex++) {
		NSRect currentSectionRect = sectionRects[currentIndex];
		if (!NSMouseInRect(point, currentSectionRect, [self isFlipped])) continue;
		
		pointIndex = currentIndex;
		break;
	}
	
	free(sectionRects);
	
	return pointIndex;
}

- (void)drawRect:(NSRect)rect {
	NSUInteger initialHitIndex = (self.tracking ? [self _indexForEventPoint:self.initialEventLocation] : NSUIntegerMax);
	NSUInteger currentHitIndex = (self.tracking ? [self _indexForEventPoint:self.lastEventLocation] : NSUIntegerMax);
	
	NSRectArray sectionRects = _AFSegmentedWeekControlCreateSectionRects([self bounds], self.sections);
	NSString *stringValue = [self stringValue];
	
	for (NSUInteger index = 0; index < self.sections; index++) {
		AFWeekday weekday = (index+1);
		BOOL cellOn = ([self isEnabled] && [self.selectedSections containsIndex:weekday]);
		
		[[self cell] setState:(cellOn ? NSOnState : NSOffState)];
		[[self cell] setHighlighted:(initialHitIndex == index && currentHitIndex == index)];
		
		if (NSLocationInRange(index, NSMakeRange(0, [stringValue length])))
			[[self cell] setObjectValue:[stringValue substringWithRange:NSMakeRange(index, 1)]];
		else 
			[[self cell] setObjectValue:nil];
		
		[[self cell] drawWithFrame:sectionRects[index] inView:self];
	}
	
	free(sectionRects);
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)_setSelection:(NSUInteger)value {
	if (!NSLocationInRange(value, NSMakeRange(0, self.sections)) && value != NSIntegerMax) return;
	
	AFWeekday weekday = (value+1);
	BOOL enabled = ![self.selectedSections containsIndex:weekday];
	
	[self.dataSource weekview:self setEnabled:enabled forDay:weekday];
	[self reloadData];
}

- (void)mouseDown:(NSEvent *)event {
	self.tracking = YES;
	
	self.initialEventLocation = self.lastEventLocation = [event locationInWindow];
	
	[self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event {
	self.lastEventLocation = [event locationInWindow];
	
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
	self.tracking = NO;
	self.lastEventLocation = [event locationInWindow];
	
	CGPoint hitPoints[2] = {self.initialEventLocation, self.lastEventLocation};
	NSUInteger hitIndexes[2] = {[self _indexForEventPoint:hitPoints[0]], [self _indexForEventPoint:hitPoints[1]]};
	if (hitIndexes[0] == NSNotFound || hitIndexes[1] == NSNotFound) return;
	if (hitIndexes[0] != hitIndexes[1]) return;
	
	[self _setSelection:*hitIndexes];
	[self setNeedsDisplay:YES];
}

@end

#undef MAX_WEEKDAYS
