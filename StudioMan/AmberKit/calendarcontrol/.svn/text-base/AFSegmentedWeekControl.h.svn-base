//
//  AFSegmentedWeekControl.h
//  AFCalendarControl
//
//  Created by Keith Duncan on 01/09/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AFWeekSegmentControlDataSource;

/*
	@brief
	This control was designed to replace the need to have seven checkboxes each representing a day of the week.
 */
@interface AFSegmentedWeekControl : NSControl {
 @private
	id <AFWeekSegmentControlDataSource> _dataSource;
	
	NSPointerArray *_values;
	NSUInteger _sections;
	
	NSIndexSet *_selectedSections;
	
	BOOL _tracking;
	CGPoint _initialEventLocation, _lastEventLocation;
}

/*
	@brief
	This control automatically reloads data in <tt>-awakeFromNib</tt>.
 */
- (void)reloadData;

@property (assign) IBOutlet id <AFWeekSegmentControlDataSource> dataSource;

@end

/*
	@brief
	<tt>AFSegmentedWeekControl</tt> is data source driven, both methods in this protocol are required.
 */
@protocol AFWeekSegmentControlDataSource <NSObject>

- (BOOL)weekview:(id)view isEnabledForDay:(AFWeekday)day;

/*
	@brief
	On <tt>-mouseUp:</tt> the control will toggle the enabled state of the day that was clicked.
	There is no need to <tt>-reloadData</tt> in your implementation, it is done automatically
	following the invocation of this method.
 */
- (void)weekview:(id)view setEnabled:(BOOL)enabled forDay:(AFWeekday)day;

@end
