//
//  AFSwitchControl.m
//  AFSwitchControl
//
//  Created by Keith Duncan on 26/01/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

//
// Event loop in -mouseDown: contributed by Jonathan Dann
// It replaced my massive loop and is far more functional
//

#import "AFSwitchControl.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "AmberKit/AmberKit+Additions.h"
#import "AmberFoundation/AmberFoundation.h"

#import "AFGradientCell.h"

NSSTRING_CONTEXT(AFSwitchControlSelectedIndexObservationContext);

@interface AFSwitchControl ()
@property (readwrite, retain) NSMutableDictionary *bindingInfo;
@property (assign) CGFloat offset;
@end

@interface AFSwitchControl (Private)
- (void)_drawKnobInSlotRect:(NSRect)bounds radius:(CGFloat)radius;
@end

@implementation AFSwitchControl

@dynamic cell;
@synthesize bindingInfo=_bindingInfo;
@synthesize offset=_offset;

+ (void)initialize {
	[self exposeBinding:NSValueBinding];
}

+ (id)defaultAnimationForKey:(NSString *)key {
	if ([key isEqualToString:@"offset"]) {
		id animation = [CABasicAnimation animation];
		[animation setDuration:0.15];
		return animation;
	} return [super defaultAnimationForKey:key];
}

+ (Class)cellClass {
	return [AFGradientCell class];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	for (NSString *currentBinding in self.bindingInfo) [self unbind:currentBinding];
	self.bindingInfo = nil;
	
	[super dealloc];
}

- (void)setOffset:(CGFloat)value {		
	Ivar valueIvar = object_getInstanceVariable(self, "_offset", NULL);
	ptrdiff_t offset = ivar_getOffset(valueIvar);
	
	CGFloat *valueRef = (void *)((int8_t *)self + offset);
	*valueRef = value;
	
	[self setNeedsDisplay:YES];
}

- (NSUInteger)state {
	return ([[self valueForBinding:NSValueBinding] boolValue] ? NSOnState : NSOffState);
}

- (void)setState:(NSUInteger)value {
	[self setValue:[NSNumber numberWithInteger:value] forBinding:NSValueBinding];
}

- (void)_updateViewForKeyStatusChange:(NSNotification *)notification {
	[self setNeedsDisplay:YES];
}

- (void)viewWillMoveToSuperview:(NSView *)view {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[self window]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:[self window]];
	
	[super viewWillMoveToSuperview:view];
	if (view == nil) return;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateViewForKeyStatusChange:) name:NSWindowDidResignKeyNotification object:[view window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateViewForKeyStatusChange:) name:NSWindowDidBecomeKeyNotification object:[view window]];
}

NS_INLINE NSRect _AFSwitchControlInsetTextRect(NSRect textRect) {
	return NSInsetRect(textRect, 0, NSHeight(textRect)/7.0);
}

NS_INLINE void _AFSwitchControlPartRects(NSRect bounds, NSRect *textRects, NSRect *backgroundRect) {
	NSDivideRect(bounds, textRects, backgroundRect, NSWidth(bounds)/5.0, NSMinXEdge);
	
	textRects[1] = _AFSwitchControlInsetTextRect(NSOffsetRect(textRects[0], NSWidth(*backgroundRect), 0));
	textRects[0] = _AFSwitchControlInsetTextRect(textRects[0]);
		
	(*backgroundRect).size.width -= NSWidth(*textRects);
	*backgroundRect = NSInsetRect(*backgroundRect, NSWidth(bounds)/20.0, 0);
}

NS_INLINE NSRect _AFSwitchControlInsetBackgroundRect(NSRect backgroundRect) {
	return NSInsetRect(backgroundRect, 1.0, 1.0);
}

NS_INLINE CGFloat _AFSwitchControlBackgroundRadiusForRect(NSRect rect) {
	return (4.0/27.0)*NSHeight(rect);
}

NS_INLINE NSRect _AFSwitchControlKnobRectForInsetBackground(NSRect slotRect, CGFloat floatValue) {
	CGFloat knobWidth = NSWidth(slotRect)*(4.0/9.0);
	CGSize knobSize = NSMakeSize(knobWidth, NSHeight(slotRect));
	
	CGPoint knobCenter = NSMakePoint(NSMinX(slotRect) + (knobWidth/2.0) + (floatValue*(NSWidth(slotRect)-knobWidth)), NSMidY(slotRect));
	
	return AFSizeCenteredAroundPoint(knobSize, knobCenter);
}

- (void)drawRect:(NSRect)frame {
	NSRect textRects[2], backgroundRect;
	_AFSwitchControlPartRects([self bounds], textRects, &backgroundRect);
	
	if ([self needsToDrawRect:textRects[0]] || [self needsToDrawRect:textRects[1]]) {		
		NSShadow *textShadow = [[NSShadow alloc] init];
		[textShadow setShadowColor:[NSColor whiteColor]];
		[textShadow setShadowOffset:NSMakeSize(0, -1.5)];
		[textShadow setShadowBlurRadius:0.0];
		
		[NSGraphicsContext saveGraphicsState];
		[textShadow set];
		
		[[NSColor colorWithCalibratedWhite:(74.0/255.0) alpha:1.0] set];
		AKDrawStringAlignedInFrame(@"OFF", [NSFont boldSystemFontOfSize:0], NSCenterTextAlignment, NSIntegralRect(textRects[0]));
		
		[NSGraphicsContext restoreGraphicsState];
		
		[NSGraphicsContext saveGraphicsState];
		[textShadow set];
		
		if (self.state == NSOnState && [self shouldDrawKey]) {
			[[NSColor colorWithCalibratedRed:(25.0/255.0) green:(86.0/255.0) blue:(173.0/255.0) alpha:1.0] set];
		} else {
			[[NSColor colorWithCalibratedWhite:(74.0/255.0) alpha:1.0] set];
		}
		
		AKDrawStringAlignedInFrame(@"ON", [NSFont boldSystemFontOfSize:0], NSCenterTextAlignment, NSIntegralRect(textRects[1]));
		
		[NSGraphicsContext restoreGraphicsState];
		[textShadow release];
	}
	
	CGFloat radius = 0;
	NSBezierPath *backgroundPath = nil;
	NSGradient *backgroundGradient = nil;
	
	radius = _AFSwitchControlBackgroundRadiusForRect(backgroundRect);
	backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSIntegralRect(backgroundRect) xRadius:radius yRadius:radius];
	backgroundGradient = [[NSGradient alloc] initWithColors:[NSArray arrayWithObjects:[NSColor colorWithCalibratedWhite:(80.0/255.0) alpha:0.9], [NSColor colorWithCalibratedWhite:(129.0/255.0) alpha:0.9], nil]];
	
	[backgroundGradient drawInBezierPath:backgroundPath angle:-90];
	[backgroundGradient release];
	
	NSRect insetBackgroundRect = _AFSwitchControlInsetBackgroundRect(backgroundRect);
	
	radius = _AFSwitchControlBackgroundRadiusForRect(insetBackgroundRect);
	backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSIntegralRect(insetBackgroundRect) xRadius:radius yRadius:radius];
	backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:(99.0/255.0) alpha:1.0], 0.0, [NSColor colorWithCalibratedWhite:(142.0/255.0) alpha:1.0], 0.3, [NSColor colorWithCalibratedWhite:(171.0/255.0) alpha:1.0], 1.0, nil];
	
	[backgroundGradient drawInBezierPath:backgroundPath angle:-90];
	[backgroundGradient release];
	
	[NSGraphicsContext saveGraphicsState];
	[backgroundPath setClip];
	
	// Draw the knob
	[self _drawKnobInSlotRect:insetBackgroundRect radius:radius];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
	NSRect textRect, backgroundRect;
	_AFSwitchControlPartRects([self bounds], &textRect, &backgroundRect);
	
	NSRect slotRect = _AFSwitchControlInsetBackgroundRect(backgroundRect);
	NSRect knobRect = _AFSwitchControlKnobRectForInsetBackground(slotRect, _offset);
	
	NSUInteger state = self.state;
	NSPoint hitPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	
	if (![self mouse:hitPoint inRect:knobRect]) {
		if ((state == NSOffState && NSMaxX(knobRect) < hitPoint.x) || (state == NSOnState && NSMinX(knobRect) > hitPoint.x)) [self setState:!state];
		return;
	}
	
	[[self cell] setHighlighted:YES];
	
	BOOL loop = YES, dragging = NO;
	
	NSPoint mouseLocation;
	
	while (loop) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseUpMask|NSLeftMouseDraggedMask)];
		mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];
		
		CGFloat newFloat, newPosition;
		CGFloat minPosition = NSMinX(slotRect) + NSWidth(knobRect)/2.0;
		CGFloat maxPosition = NSMaxX(slotRect) - NSWidth(knobRect)/2.0;
		
		switch ([event type]) {
			case NSLeftMouseDragged:
			{
				dragging = YES;
				newPosition = mouseLocation.x - (hitPoint.x-NSMidX(knobRect));
				
				if (newPosition <= minPosition)
					newFloat = 0.0;
				else if (newPosition >= maxPosition)
					newFloat = 1.0;
				else
					newFloat = (newPosition-minPosition)/(maxPosition - minPosition);
				
				self.offset = newFloat;
				break;
			}
			case NSLeftMouseUp:
			{
				[[self cell] setHighlighted:NO];
				
				if (dragging) {
					CGFloat value = (state ? 1.0 : 0.0) + ((state ? -1 : 1) * 0.25);
					self.state = ((self.offset >= value) ? NSOnState : NSOffState);
				} else self.state = !state;
				
				loop = NO;
				break;
			}
		}
	}
}

- (id)infoForBinding:(NSString *)binding {
	id info = [self.bindingInfo valueForKey:binding];
	return (info != nil) ? info : [super infoForBinding:binding];
}

- (void)setInfo:(id)info forBinding:(NSString *)binding {
	if (self.bindingInfo == nil)
		self.bindingInfo = [NSMutableDictionary dictionary];
	
	[self.bindingInfo setValue:info forKey:binding];
}

- (void *)contextForBinding:(NSString *)binding {
	if ([binding isEqualToString:NSValueBinding]) return &AFSwitchControlSelectedIndexObservationContext;
	else return nil;
}

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
	if ([self infoForBinding:binding] != nil) [self unbind:binding];
	
	void *context = [self contextForBinding:binding];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
						  observable, NSObservedObjectKey,
						  [[keyPath copy] autorelease], NSObservedKeyPathKey,
						  [[options copy] autorelease], NSOptionsKey, nil];
	
	if ([binding isEqualToString:NSValueBinding]) {
		[self setInfo:info forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:context];
		
		[self setOffset:(CGFloat)[self state]];
	} else [super bind:binding toObject:observable withKeyPath:keyPath options:options];
	
	[self setNeedsDisplay:YES];
}

- (void)unbind:(NSString *)binding {
	if ([binding isEqualToString:NSValueBinding]) {
		[[self controllerForBinding:binding] removeObserver:self forKeyPath:[self keyPathForBinding:binding]];
		[self setInfo:nil forBinding:binding];
	} else [super unbind:binding];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &AFSwitchControlSelectedIndexObservationContext) {
		[[self animator] setOffset:[[object valueForKeyPath:keyPath] boolValue]];
	} else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	[self setNeedsDisplay:YES];
}

@end

@implementation AFSwitchControl (Private)

- (void)_drawKnobInSlotRect:(NSRect)slotRect radius:(CGFloat)radius {
	NSRect handleBounds = _AFSwitchControlKnobRectForInsetBackground(slotRect, self.offset);
		
	self.cell.cornerRadius = radius;
	[self.cell drawBezelWithFrame:NSIntegralRect(handleBounds) inView:self];
}

@end
