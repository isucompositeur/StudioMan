//
//  AFSourceList.m
//  Amber
//
//  Created by Keith Duncan on 04/05/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "AFSourceList.h"

#import "CoreAmberKit/CoreAmberKit.h"
#import "AmberFoundation/AmberFoundation.h"

#import "AFTextFieldCell.h"
#import "AFImageTextCell.h"
#import "AFDisclosureButton.h"

NSString *AFContentImagesBinding = @"contentImageBinding";

NSSTRING_CONTEXT(AFSourceListContentObservationContext);
NSSTRING_CONTEXT(AFSourceListContentPropertyObservationContext);
NSSTRING_CONTEXT(AFSourceListSelectionIndexPathObservationContext);

static const CGFloat _AFSourceListInitialDeltaY = 3.0;
static const CGFloat _AFSourceListInitialDeltaX = 6.0;

enum {
	UP = -1,
	DOWN = 1,
	CLOSE = 0,
	OPEN = 1
};
typedef NSInteger _AFSourceListDirection;

@interface AFSourceList ()
@property (retain) AFTextFieldCell *cell;
@property (retain) AFImageTextCell *contentsCell;

@property (retain) NSMutableDictionary *bindingInfo;

@property (assign) CGFloat rowHeight, nodeSeparation;

@property (retain) NSMutableSet *expanded, *expandable, *disclosureButtons;
@property (retain) NSCountedSet *disclosureLevels;
@end

@interface AFSourceList (Private)
- (CGFloat)_heightForTreeArray:(NSArray *)array;
- (NSButton *)_newDisclosureButtonForNode:(id)node;
- (NSButton *)_disclosureButtonForNode:(id)node;
@end

@interface AFSourceList (PrivateDrawing)
- (void)_resetFrameSize;
- (CGFloat)_rowIndentForLevel:(NSUInteger)level;
@end

@interface AFSourceList (PrivateSelection)
- (void)_discloseSelection:(NSInteger)direction;
- (void)_discloseNode:(NSTreeNode *)node;
- (void)_selectNode:(NSTreeNode *)node;
- (void)_moveSelection:(NSInteger)direction;
- (void)_scrollToSelection;
- (void)_expandNode:(NSTreeNode *)node;

- (NSMutableArray *)_expandedNodesFromTree:(NSTreeNode *)node;
- (void)_addExpandedNodes:(NSTreeNode *)node toCollection:(id)collection;
@end

@implementation AFSourceList

@synthesize delegate=_delegate, dataSource=_dataSource;

@synthesize bindingInfo=_bindingInfo;

@dynamic cell;
@synthesize contentsCell=_contentsCell;

@synthesize rowHeight=_rowHeight, nodeSeparation=_nodeSeparation;
@synthesize expanded=_expanded, expandable=_expandable, disclosureButtons=_disclosureButtons;
@synthesize disclosureLevels=_disclosureLevels;

+ (void)initialize {
	[self exposeBinding:NSContentBinding];
	[self exposeBinding:AFContentImagesBinding];
	[self exposeBinding:NSContentValuesBinding];
	
	[self exposeBinding:AFSelectionIndexPathBinding];
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self == nil) return nil;
	
	self.rowHeight = 20;
	self.nodeSeparation = 6;
	
	{
		AFTextFieldCell *cell = [[[AFTextFieldCell alloc] init] autorelease];
		
		[cell setFont:[NSFont boldSystemFontOfSize:11]];
		[cell setTextColor:[NSColor colorWithCalibratedRed:(93.0/255.0) green:(109.0/255.0) blue:(124.0/255.0) alpha:1.0]];
		
		[cell setLineBreakMode:NSLineBreakByTruncatingTail];
		
		[cell setDrawsBackground:NO];
		
		self.cell = cell;
	}
	
	{
		AFImageTextCell *cell = [[[AFImageTextCell alloc] init] autorelease];
		[cell setDrawsBackground:NO];
		
		self.contentsCell = cell;
	}
	
	self.expanded = [NSMutableSet set];
	self.expandable = [NSMutableSet set];
	self.disclosureButtons = [NSMutableSet set];
	
	self.disclosureLevels = [NSCountedSet set];
	
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	for (NSString *currentBinding in self.bindingInfo) [self unbind:currentBinding];
	self.bindingInfo = nil;
	
	self.contentsCell = nil;
	
	self.expanded = nil;
	self.expandable = nil;
	self.disclosureButtons = nil;
	
	self.disclosureLevels = nil;
	
	[super dealloc];
}

- (void)viewWillMoveToSuperview:(NSView *)view {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:nil];
	
	[super viewWillMoveToSuperview:view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidResignKeyNotification object:[view window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidBecomeKeyNotification object:[view window]];
}

- (void)viewDidMoveToSuperview; {
	[[[self enclosingScrollView] contentView] setCopiesOnScroll:NO];
}

- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)rect {
	if ([self shouldDrawKey]) {
		[[NSColor colorWithCalibratedRed:(212.0/255.0) green:(218.0/255.0) blue:(227.0/255.0) alpha:1.0] set];
		NSRectFill(rect);
	} else {
		NSDrawWindowBackground(rect);
	}
	
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	NSIndexPath *selectionIndexPath = [self valueForBinding:AFSelectionIndexPathBinding];
	NSString *imageKeyPath = [[self keyPathForBinding:AFContentImagesBinding] stringByRemovingKeyPathComponentAtIndex:0], *valueKeyPath = [[self keyPathForBinding:NSContentValuesBinding] stringByRemovingKeyPathComponentAtIndex:0];
	
	NSRect rowFrame = [self bounds];
	rowFrame.origin.y = _AFSourceListInitialDeltaY;
	rowFrame.size.height = self.rowHeight;
	
	NSInteger count;
	const NSRect *rects;
	[self getRectsBeingDrawn:&rects count:&count];
	
	BOOL shouldDraw = NO;
	
	NSArray *treeArray = [self _expandedNodesFromTree:content];
	for (NSTreeNode *currentNode in treeArray) {
		if ([[content childNodes] containsObject:currentNode] && [treeArray indexOfObjectIdenticalTo:currentNode] > 0)
			rowFrame.origin.y += self.nodeSeparation;
		
		if (!shouldDraw) for (NSUInteger index = 0; index < count; index++) {
			shouldDraw = NSIntersectsRect(rects[index], rowFrame);
			if (shouldDraw) break;
		}
		
		if (shouldDraw) {
			BOOL rootChild = [[content childNodes] containsObject:currentNode];
			BOOL highlighted = ([[currentNode indexPath] isEqual:selectionIndexPath]);
			
			if (highlighted && !rootChild) {
				[NSGraphicsContext saveGraphicsState];
				
				NSBezierPath *rowPath = [NSBezierPath bezierPathWithRect:rowFrame];
				[rowPath addClip];
				
				BOOL drawKey = ([[self window] firstResponder] == self && [[self window] isKeyWindow]);
				
				[[NSGradient sourceListSelectionGradient:drawKey] drawInBezierPath:rowPath angle:90];
				
				if (drawKey) {
					[[NSColor colorWithCalibratedRed:(25.0/255.0) green:(86.0/255.0) blue:(173.0/255.0) alpha:1.0] set];
				} else {
					[[NSColor colorWithCalibratedRed:(145.0/255.0) green:(160.0/255.0) blue:(192.0/255.0) alpha:1.0] set];
				}
				
				[NSBezierPath setDefaultLineWidth:1.0];
				[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rowFrame), NSMinY(rowFrame)) toPoint:NSMakePoint(NSMaxX(rowFrame), NSMinY(rowFrame))];
				
				[NSGraphicsContext restoreGraphicsState];
			}
			
			id cell = (rootChild ? self.cell : self.contentsCell);
			NSString *stringValue = [[currentNode representedObject] valueForKeyPath:valueKeyPath];
			
			if (cell == [self cell]) {
				[cell setStringValue:[stringValue uppercaseString]];
			} else if (cell == self.contentsCell) {
				[cell setBackgroundStyle:(highlighted ? NSBackgroundStyleLowered : NSBackgroundStyleLight)];
				
				[cell setTextColor:(highlighted ? [NSColor whiteColor] : [NSColor blackColor])];
				[cell setFont:(highlighted ? [NSFont boldSystemFontOfSize:11] : [NSFont systemFontOfSize:11])];
				
				[cell setImage:[[currentNode representedObject] valueForKeyPath:imageKeyPath]];
				
				
				NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
				[style setTighteningFactorForTruncation:0.0];
				[style setLineBreakMode:NSLineBreakByTruncatingTail];
				
				NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
											style, NSParagraphStyleAttributeName,
											nil];
				
				[style release];
				
				NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:stringValue attributes:attributes];
				[cell setAttributedStringValue:attributedString];
				[attributedString release];
			}
			
			NSRect rowBounds = rowFrame;
			rowBounds.origin.x = [self _rowIndentForLevel:[[currentNode indexPath] length]];
			rowBounds.size.width = NSWidth(rowBounds) - NSMinX(rowBounds);
			
			if ([self.expandable containsObject:currentNode]) {
				NSButton *button = [self _disclosureButtonForNode:currentNode];
				
				[button setState:([self.expanded containsObject:currentNode] ? NSOnState : NSOffState)];
				
				NSRect buttonFrame = rowBounds;
				buttonFrame.size.width = CGRectGetHeight(buttonFrame);
				buttonFrame = NSOffsetRect(buttonFrame, (-CGRectGetHeight(buttonFrame) * (4.8/6.0)), -1.0);
				
				if (cell == [self cell]) {
					buttonFrame.origin.x = NSMinX([cell titleRectForBounds:rowBounds]) - 2.0;
					
					rowBounds.origin.x = NSMaxX(buttonFrame) - 5.0;
					rowBounds.size.width -= NSWidth(buttonFrame);
				}
				
				[button setFrame:buttonFrame];
			}
			
			[NSGraphicsContext saveGraphicsState];
			
			if (cell == self.cell) {
				NSShadow *shadow = [[NSShadow alloc] init];
				
				[shadow setShadowColor:[NSColor whiteColor]];
				[shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
				[shadow setShadowBlurRadius:0.0];
				
				[shadow set];
				[shadow release];
			}
			
			[cell drawWithFrame:rowBounds inView:self];
			
			[NSGraphicsContext restoreGraphicsState];
		}
		
		rowFrame.origin.y += self.rowHeight;
	}
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)becomeFirstResponder {
	[self setNeedsDisplay:YES];
	return YES;
}

- (BOOL)resignFirstResponder {
	[self setNeedsDisplay:YES];
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
	NSPoint clickPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	NSMutableArray *treeArray = [self _expandedNodesFromTree:content];
	
	CGFloat height = _AFSourceListInitialDeltaY;
	for (NSUInteger index = 0; index < [treeArray count]; index++, height += self.rowHeight) {
		NSTreeNode *currentNode = [treeArray objectAtIndex:index];
		
		BOOL rootChild = [[content childNodes] containsObject:currentNode];
		if (rootChild && [[content childNodes] indexOfObjectIdenticalTo:currentNode] > 0) height += self.nodeSeparation;
		
		if (clickPoint.y > height + self.rowHeight) continue;
		
		NSTreeNode *clickedNode = [treeArray objectAtIndex:index];
		if (![[content childNodes] containsObject:clickedNode]) [self _selectNode:clickedNode];
		return;
	}
}

- (void)keyDown:(NSEvent *)event {
	if (([event modifierFlags] & NSNumericPadKeyMask) == NSNumericPadKeyMask) {
		NSString *keyStroke = [event charactersIgnoringModifiers];
		if ([keyStroke length] == 0 || [keyStroke length] > 1) return;
		
		switch ([keyStroke characterAtIndex:0]) {
		case NSLeftArrowFunctionKey:
			[self _discloseSelection:CLOSE];
			break;
		case NSRightArrowFunctionKey:
			[self _discloseSelection:OPEN];
			break;
		case NSUpArrowFunctionKey:
			[self _moveSelection:UP];
			break;
		case NSDownArrowFunctionKey:
			[self _moveSelection:DOWN];
			break;
		}
	} else [super keyDown:event];
}

- (id)infoForBinding:(NSString *)bindingName {
	NSDictionary *info = [self.bindingInfo objectForKey:bindingName];
	return (info != nil) ? info : [super infoForBinding:bindingName];
}

- (void)setInfo:(id)info forBinding:(NSString *)binding {
	if (self.bindingInfo == nil)
		self.bindingInfo = [NSMutableDictionary dictionary];
	
	[self.bindingInfo setValue:info forKey:binding];
}

- (void *)contextForBinding:(NSString *)binding {
	if ([binding isEqualToString:NSContentBinding]) return &AFSourceListContentObservationContext;
	else if ([binding isEqualToString:AFContentImagesBinding]) return &AFSourceListContentPropertyObservationContext;
	else if ([binding isEqualToString:NSContentValuesBinding]) return &AFSourceListContentPropertyObservationContext;
	else if ([binding isEqualToString:AFSelectionIndexPathBinding]) return &AFSourceListSelectionIndexPathObservationContext;
	else return nil;
}

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
	if ([self infoForBinding:binding] != nil) [self unbind:binding];
	
	void *context = [self contextForBinding:binding];
	NSDictionary *bindingInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								 observable, NSObservedObjectKey,
								 [[keyPath copy] autorelease], NSObservedKeyPathKey,
								 [[options copy] autorelease], NSOptionsKey,
								 nil];
	
	if ([binding isEqualToString:NSContentBinding]) {
		[self setInfo:bindingInfo forBinding:NSContentBinding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:context];
	} else if ([binding isEqualToString:AFContentImagesBinding]) {
		[self setInfo:bindingInfo forBinding:AFContentImagesBinding];
		[observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:context];
	} else if ([binding isEqualToString:NSContentValuesBinding]) {
		[self setInfo:bindingInfo forBinding:NSContentValuesBinding];
		[observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:context];
	} else if ([binding isEqualToString:AFSelectionIndexPathBinding]) {
		[self setInfo:bindingInfo forBinding:AFSelectionIndexPathBinding];
		[observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:context];
	} else [super bind:binding toObject:observable withKeyPath:keyPath options:options];
	
	[self setNeedsDisplay:YES];
}

- (void)unbind:(NSString *)binding {	
	id controller = [self controllerForBinding:binding];
	NSString *keyPath = [self keyPathForBinding:binding];
	
	if ([binding isEqualToString:NSContentBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:NSContentBinding];
	} else if ([binding isEqualToString:AFContentImagesBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:AFContentImagesBinding];
	} else if ([binding isEqualToString:NSContentValuesBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:NSContentValuesBinding];
	} else if ([binding isEqualToString:AFSelectionIndexPathBinding]) {
		[controller removeObserver:self forKeyPath:keyPath];
		[self setInfo:nil forBinding:AFSelectionIndexPathBinding];
	} else [super unbind:binding];
	
	[self setNeedsDisplay:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == &AFSourceListContentObservationContext) {
		NSTreeNode *content = [self valueForBinding:NSContentBinding];
		NSMutableSet *treeSet = [[AFTreeNodeSetFromNodeInclusive(content, NO) mutableCopy] autorelease];
		
		[self.expanded intersectSet:treeSet];
		[self.expanded addObject:content];
		[self.expanded addObjectsFromArray:[content childNodes]];
		
		[self.expandable intersectSet:treeSet];
		
		NSMutableSet *newDisclosureButtons = [[self.disclosureButtons mutableCopy] autorelease];
		for (NSButton *currentButton in self.disclosureButtons) {
			if ([treeSet containsObject:[[currentButton cell] representedObject]]) continue;
			
			[self.disclosureLevels removeObject:[NSNumber numberWithUnsignedInteger:[[[[currentButton cell] representedObject] indexPath] length]]];
			
			[currentButton removeFromSuperview];
			[newDisclosureButtons removeObject:currentButton];
		}
		self.disclosureButtons = newDisclosureButtons;
		
		for (NSTreeNode *currentNode in treeSet) {
			if ([[currentNode childNodes] count] == 0) continue;
			
			BOOL showDisclosure = (![[content childNodes] containsObject:currentNode]);
			if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(sourceList:shouldDisplayDisclosure:forObject:)]) {
				[self.dataSource sourceList:self shouldDisplayDisclosure:&showDisclosure forObject:[currentNode representedObject]];
			}
			if (!showDisclosure) continue;
			
			if (![self.expandable containsObject:currentNode]) {
				[self.expandable addObject:currentNode];
				[self.disclosureLevels addObject:[NSNumber numberWithUnsignedInteger:[[currentNode indexPath] length]]];
				
				NSButton *button = [self _newDisclosureButtonForNode:currentNode];
				
				[self.disclosureButtons addObject:button];
				[self addSubview:button];
			}
		}
		
		[self _resetFrameSize];
	} else if (context == &AFSourceListContentPropertyObservationContext) {
		// Nothing, setNeedsDisplay:YES is sufficient
	} else if (context == &AFSourceListSelectionIndexPathObservationContext) {
		NSIndexPath *selectionIndexPath = [self valueForBinding:AFSelectionIndexPathBinding];
		
		NSTreeNode *content = [self valueForBinding:NSContentBinding];
		NSTreeNode *selectedNode = [content descendantNodeAtIndexPath:selectionIndexPath];
		
		[self _expandNode:selectedNode];
		[self _resetFrameSize];
		
		[self _scrollToSelection];
	} else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	[self setNeedsDisplay:YES];
}

@end

@implementation AFSourceList (Private)

- (CGFloat)_heightForTreeArray:(NSArray *)treeArray {
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	
	CGFloat deltaY = _AFSourceListInitialDeltaY;
	for (NSTreeNode *currentNode in treeArray) {
		if ([[content childNodes] containsObject:currentNode] && [treeArray indexOfObjectIdenticalTo:currentNode] > 0) deltaY += self.nodeSeparation;
		
		deltaY += self.rowHeight;
	}
	
	return deltaY;
}

- (NSButton *)_disclosureButtonForNode:(id)node {
	for (NSButton *currentButton in self.disclosureButtons)
		if ([[currentButton cell] representedObject] == node)
			return currentButton;
	
	return nil;
}

#if 1
- (NSButton *)_newDisclosureButtonForNode:(id)node {
	NSButton *disclosureButton = [[[NSButton alloc] initWithFrame:NSZeroRect] autorelease];
	
	[disclosureButton setTitle:nil];
	
	[[disclosureButton cell] setRepresentedObject:node];
	[[disclosureButton cell] setBezelStyle:NSDisclosureBezelStyle];
	[[disclosureButton cell] setButtonType:NSOnOffButton];
	
	[disclosureButton setTarget:self];
	[disclosureButton setAction:@selector(_disclose:)];
	[disclosureButton sendActionOn:NSLeftMouseUpMask];
	
	return disclosureButton;
}
#else
- (NSButton *)_newDisclosureButtonForNode:(id)node {
	AFDisclosureButton *disclosureButton = [[[AFDisclosureButton alloc] initWithFrame:NSZeroRect] autorelease];
	
	[disclosureButton setTitle:nil];
	
	[[disclosureButton cell] setRepresentedObject:node];
	
	[disclosureButton setTarget:self];
	[disclosureButton setAction:@selector(_disclose:)];
	[disclosureButton sendActionOn:NSLeftMouseUpMask];
	
	return (id)disclosureButton;
}
#endif

- (void)_disclose:(id)sender {
	[self _discloseNode:[[sender cell] representedObject]];
}

@end

@implementation AFSourceList (PrivateDrawing)

- (void)_resetFrameSize {
	NSClipView *clipView = [[self enclosingScrollView] contentView];
	NSRect documentRect = [clipView documentVisibleRect];
	
	NSSize size = NSZeroSize;
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	
	if (content != nil) {
		CGFloat height = [self _heightForTreeArray:[self _expandedNodesFromTree:content]];
	
		size.height = MAX(NSHeight(documentRect), height);
		size.width = NSWidth(documentRect);
	}
	
	[self setFrameSize:size];
}

- (CGFloat)_rowIndentForLevel:(NSUInteger)level {
	CGFloat indent = _AFSourceListInitialDeltaX, delta = (self.rowHeight * (2.0/3.0));
	
	for (; level > 1; level--) {
		indent += delta;
		
		if (![self.disclosureLevels containsObject:[NSNumber numberWithUnsignedInteger:level]]) continue;
		indent += delta;
	}
	
	return indent;
}

@end

@implementation AFSourceList (PrivateSelection)

- (void)_discloseSelection:(_AFSourceListDirection)direction {
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	NSIndexPath *selectionIndexPath = [self valueForBinding:AFSelectionIndexPathBinding];
	
	if (content == nil || selectionIndexPath == nil) return;
	NSTreeNode *node = [content descendantNodeAtIndexPath:selectionIndexPath];
	
	if ([self.expandable containsObject:node]) {
		BOOL expanded = [self.expanded containsObject:node];
		if (expanded ^ direction) [self _discloseNode:node];
	} else {
		NSTreeNode *parent = [node parentNode];
		if ([[content childNodes] containsObject:parent]) return;
		
		[self _selectNode:parent];
	}
}

- (void)_discloseNode:(NSTreeNode *)node {
	if ([self.expanded containsObject:node]) {
		for (NSTreeNode *currentNode in [self _expandedNodesFromTree:node])
			[[self _disclosureButtonForNode:currentNode] setFrame:NSZeroRect];
		
		[self.expanded removeObject:node];
	} else [self.expanded addObject:node];
	
	[self _resetFrameSize];
}

- (void)_moveSelection:(_AFSourceListDirection)direction {
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	
	NSIndexPath *selectionIndexPath = [self valueForBinding:AFSelectionIndexPathBinding];
	NSTreeNode *node = [content descendantNodeAtIndexPath:selectionIndexPath];
	
	NSMutableArray *treeArray = [self _expandedNodesFromTree:content];	
	[treeArray removeObjectsInArray:[content childNodes]];
	
	NSInteger newIndex = ([treeArray indexOfObjectIdenticalTo:node] + direction);	
	if (!AFArrayContainsIndex(treeArray, newIndex)) return;
	
	[self _selectNode:[treeArray objectAtIndex:newIndex]];
}

- (void)_selectNode:(NSTreeNode *)node {
	BOOL shouldSelect = YES;
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sourceList:canSelectObject:)]) {
		shouldSelect = [self.delegate sourceList:self canSelectObject:[node representedObject]];
	}
	
	if (!shouldSelect) {
		NSBeep();
		return;
	}
	
	[self setValue:[node indexPath] forBinding:AFSelectionIndexPathBinding];
	[self _scrollToSelection];
}

- (void)_scrollToSelection {	
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	NSMutableArray *contentArray = [self _expandedNodesFromTree:content];
	
	NSTreeNode *selectedNode = [content descendantNodeAtIndexPath:[self valueForBinding:AFSelectionIndexPathBinding]];
	NSUInteger selectedNodeIndex = [contentArray indexOfObjectIdenticalTo:selectedNode];
	if (selectedNodeIndex == NSNotFound) return;
	
	CGFloat deltaY = [self _heightForTreeArray:[contentArray subarrayWithRange:NSMakeRange(0, selectedNodeIndex)]];
	NSPoint boundingRowPoints[] = {NSMakePoint(0, deltaY), NSMakePoint(0, deltaY+self.rowHeight)};
	
	NSScrollView *scrollView = [self enclosingScrollView];
	if (scrollView == nil) return;
	
	NSRect visibleRect = [scrollView documentVisibleRect];
	if (NSPointInRect(boundingRowPoints[0], visibleRect) && NSPointInRect(boundingRowPoints[1], visibleRect)) return;
	
	[self scrollPoint:NSMakePoint(0, boundingRowPoints[0].y)];
}

- (void)_expandNode:(NSTreeNode *)node {
	NSTreeNode *parent = [node parentNode];
	if (parent == nil || [self.expanded containsObject:parent]) return;
	
	[self.expanded addObject:parent];
	[self _expandNode:parent];
}

- (NSMutableArray *)_expandedNodesFromTree:(NSTreeNode *)node {
	NSTreeNode *content = [self valueForBinding:NSContentBinding];
	
	NSMutableArray *treeArray = [NSMutableArray array];
	[self _addExpandedNodes:content toCollection:treeArray];
	for (NSTreeNode *currentNode in [content childNodes]) {
		BOOL override = NO;
		if ([currentNode isLeaf] && [self.delegate respondsToSelector:@selector(sourceList:shouldDisplayRootLeaf:)])
			override = [self.delegate sourceList:self shouldDisplayRootLeaf:currentNode];
		
		if (!override) continue;
		
		[treeArray removeObjectIdenticalTo:currentNode];
	}
	
	return treeArray;
}

- (void)_addExpandedNodes:(NSTreeNode *)node toCollection:(id)collection {
	for (NSTreeNode *currentNode in [node childNodes]) {
		[collection addObject:currentNode];
		if ([self.expanded containsObject:currentNode]) [self _addExpandedNodes:currentNode toCollection:collection];
	}
}

@end
