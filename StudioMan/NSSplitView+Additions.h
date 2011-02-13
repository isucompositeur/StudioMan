/******************************************************************************
 *                                                                            *
 * StudioMan: Music studio management software                                *
 *                                                                            *
 * Copyright (C) 2011 Nicholas Meyer                                          *               
 *                                                                            *
 * This file is part of StudioMan.                                            *
 *                                                                            *
 * StudioMan is free software: you can redistribute it and/or modify it under *
 * the terms of the GNU General Public License as published by the Free       *
 * Software Foundation, either version 3 of the License, or (at your option)  *
 * any later version.                                                         *
 *                                                                            *
 * StudioMan is distributed in the hope that it will be useful, but WITHOUT   *
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      *
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for  *
 * more details.                                                              *
 *                                                                            *
 * You should have received a copy of the GNU General Public License along    *
 * with StudioMan.  If not, see <http://www.gnu.org/licenses/>.               *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 * NSSplitView Additions                                                      *
 * StudioMan                                                                  *
 *                                                                            *
 * This category adds methods to NSSplitView to facilitated animated subview  *
 * collapsing. It also defines an extension to the NSSplitViewDelegate        *
 * protocol for storing view frames for when they are uncollapsed.            *
 *                                                                            *
 ******************************************************************************/

#import <Cocoa/Cocoa.h>


@interface NSSplitView (SMAdditions)

- (void) toggleSubview: (NSView*)subView;

@end

@protocol NSSplitViewDelegateAdditions <NSObject>

- (void)setOriginalRect:(NSRect)rect forSubview:(NSView *)subview;
- (NSRect)originalRectForSubview:(NSView *)subview;

@end