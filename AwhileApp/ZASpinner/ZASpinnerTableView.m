//
//  ZACircularTableView.m
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import "ZASpinnerTableView.h"
#import "ZASpinnerCell.h"
#import "ZASpinnerView.h"

#define CIRCULAR_CORE_TEXT_ARC_VIEW_VERTICAL_PADDING 14.0f

@implementation ZASpinnerTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        self.radius = 0;
    }
	
    return self;
}

- (void)repositionCells {
    for (NSIndexPath *currIndexPath in [self indexPathsForVisibleRows]) {
        ZASpinnerCell *currCell = (ZASpinnerCell*)[self cellForRowAtIndexPath:currIndexPath];
        CGRect rawCurrRect = [self rectForRowAtIndexPath:currIndexPath];
        CGRect currRect = CGRectOffset(rawCurrRect, -self.contentOffset.x, -self.contentOffset.y);
        CGFloat x = currRect.origin.y+currRect.size.height/2;
        CGFloat arcHeight = [self arcHeightFromX:x];
        currCell.frame = CGRectMake(arcHeight+[self parent].verticalShift, currCell.frame.origin.y, currCell.bounds.size.width, currCell.bounds.size.height);
        CGFloat halfwayThroughTable = self.frame.size.width/2;
        CGFloat rotateAngle = [self angleFromX:x];
        CGFloat l = self.frame.size.width/2;//(self.frame.size.width/2 < self.radius) ? self.frame.size.width/2 : self.radius;
        if ([[NSString stringWithFormat:@"%.8f",rotateAngle] isEqualToString:@"1.57079637"])
            rotateAngle = 0;
        if (x < l)
            rotateAngle *= -1;
        currCell.contentView.transform = CGAffineTransformMakeRotation(rotateAngle+M_PI_2);
        if (x == halfwayThroughTable) {
            [self styleFocusedCell:currCell];
        }
        else {
            [self styleUnfocusedCell:currCell];
        }
    }
}

- (void)styleUnfocusedCell:(ZASpinnerCell*)cell {
    [[self parent].spinnerDelegate spinner:[self parent] styleForCell:cell whileFocused:NO];
}

- (void)styleFocusedCell:(ZASpinnerCell*)cell {
    [[self parent].spinnerDelegate spinner:[self parent] styleForCell:cell whileFocused:YES];
}

- (CGFloat)arcHeightFromX:(CGFloat)x {
    //http://liutaiomottola.com/formulae/sag.htm
    CGFloat r = self.radius;
    CGFloat l = self.frame.size.width/2;//(self.frame.size.width/2 < self.radius) ? self.frame.size.width/2 : self.radius;
    CGFloat dist_x = fabsf(x-l);
    CGFloat height = -sqrtf(powf(r,2)-powf(l,2))+sqrtf(powf(r,2)-powf(dist_x,2));
    if (isnan(height))
        return 0;
    return height;
}

- (CGFloat)angleFromX:(CGFloat)x
{
    CGFloat r = self.radius;
    CGFloat l = (self.frame.size.width/2 < self.radius) ? self.frame.size.width/2 : self.radius;
    CGFloat dist_x = fabsf(x-l);
    CGFloat angle = atan2f(dist_x,r);
    if (isnan(angle))
        return 0;
    return angle;
}

- (ZASpinnerView*)parent {
    return (ZASpinnerView*)self.delegate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self repositionCells];
}

@end
