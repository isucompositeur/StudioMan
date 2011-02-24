//
//  ActivationControl.m
//  Activation Control
//
//  Created by Keith Duncan on 01/09/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "AFActivationControl.h"

#import <objc/runtime.h>

#import "AFActivationCell.h"

@interface AFActivationControl ()
@property (assign) NSInteger selectedSection;
@property (retain) NSPointerArray *values;
@end

@implementation AFActivationControl

@dynamic stringValue;

@synthesize sections=_sections;
@synthesize selectedSection=_selectedSection;
@synthesize values=_values;

+ (Class)cellClass {
	return [AFActivationCell class];
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self == nil) return nil;
	
	self.values = [NSPointerArray pointerArrayWithStrongObjects];
	
	return self;
}

- (void)dealloc {
	self.values = nil;
	
	[super dealloc];
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
	if ([value length] > self.sections) [NSException raise:NSRangeException format:@"%s passed a string too large to display", _cmd, nil];
	
	for (NSUInteger index = 0; index < [value length]; index++)
		[self.values replacePointerAtIndex:index withPointer:[value substringWithRange:NSMakeRange(index, 1)]];
	
	[self setNeedsDisplay:YES];
}

NS_INLINE void _AFActivationControlCalculateRatio(CGFloat height, CGFloat *sectionWidth, CGFloat *sectionGap) {
	*sectionWidth = (height * 0.85);
	*sectionGap = (height * 0.17);
}

NS_INLINE CGFloat _AFActivationControlWidthForValues(NSUInteger count, CGFloat width, CGFloat gap) {
	return (count * width) + ((count - 1) * gap);
}

NS_INLINE void _AFActivationControlValuesForWidth(NSRect bounds, NSUInteger count, CGFloat *sectionHeight, CGFloat *sectionWidth, CGFloat *sectionGap) {
	_AFActivationControlCalculateRatio(1.0, sectionWidth, sectionGap);
	CGFloat unitWidth = _AFActivationControlWidthForValues(count, *sectionWidth, *sectionGap);
	
	CGFloat scaleFactor = MIN(NSWidth(bounds)/unitWidth, NSHeight(bounds)/1.0);
	
	*sectionHeight = scaleFactor;
	*sectionWidth *= scaleFactor;
	*sectionGap *= scaleFactor;
}

NS_INLINE NSRectArray _AFActivationControlCreateSectionRects(NSRect bounds, NSUInteger count) {
	CGFloat sectionHeight, sectionWidth, sectionGap;
	_AFActivationControlValuesForWidth(bounds, count, &sectionHeight, &sectionWidth, &sectionGap);
	
	NSRectArray sectionRects = calloc(count, sizeof(NSRect));
	
	NSPoint origin = bounds.origin;
	for (NSUInteger index = 0; index < count; index++) {
		sectionRects[index] = (NSRect){origin, sectionWidth, sectionHeight};
		origin.x += (sectionWidth + sectionGap);
	}
	
	return sectionRects;
}

- (void)drawRect:(NSRect)rect {
	NSRectArray sectionRects = _AFActivationControlCreateSectionRects([self bounds], _sections);
	
	NSString *stringValue = [self stringValue];
	
	for (NSUInteger index = 0; index < self.sections; index++) {
		BOOL highlighted = ([self isEnabled] && index == self.selectedSection);
		[[self cell] setHighlighted:highlighted];
		
		if (NSLocationInRange(index, NSMakeRange(0, [stringValue length])))
			[[self cell] setObjectValue:[stringValue substringWithRange:NSMakeRange(index, 1)]];
		else 
			[[self cell] setObjectValue:nil];
		
		[[self cell] drawWithFrame:sectionRects[index] inView:self];
	}
	
	free(sectionRects);
}

- (BOOL)acceptsFirstResponder {
	return [self isEnabled];
}

- (void)_setSelection:(NSUInteger)value {
	if (!NSLocationInRange(value, NSMakeRange(0, _sections)) && value != NSIntegerMax) return;
	
	self.selectedSection = value;
	
	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
	NSRectArray sectionRects = _AFActivationControlCreateSectionRects([self bounds], _sections);
	NSPoint clickPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	
	for (NSUInteger index = 0; index < _sections; index++) {
		if (!NSMouseInRect(clickPoint, sectionRects[index], [self isFlipped])) continue;
		
		[self _setSelection:index];
		break;
	}
	
	free(sectionRects);
}

- (void)keyDown:(NSEvent *)event {	
	[self interpretKeyEvents:[NSArray arrayWithObject:event]];
}

- (void)moveLeft:(id)sender {
	[self _setSelection:(self.selectedSection-1)];
}

- (void)moveRight:(id)sender {
	[self _setSelection:(self.selectedSection+1)];
}

- (void)insertText:(id)string {
	if (self.selectedSection == NSIntegerMax) return;
	
	[self.values replacePointerAtIndex:self.selectedSection withPointer:[string substringWithRange:NSMakeRange(0, 1)]];
	[self setNeedsDisplay:YES];
	
	NSInteger proposedSelection = self.selectedSection+1;
	[self _setSelection:(proposedSelection < self.sections ? proposedSelection : NSIntegerMax)];
}

- (void)deleteBackward:(id)sender {
	if (self.selectedSection == NSIntegerMax) return;
	
	NSInteger proposedSelection = (self.selectedSection - 1);
	if (proposedSelection < 0) return;
	
	NSUInteger count = [self.values count];
	[self.values replacePointerAtIndex:proposedSelection withPointer:NULL];
	[self.values compact];
	[self.values setCount:count];
	
	[self _setSelection:proposedSelection];
	
	[self setNeedsDisplay:YES];
}

@end
