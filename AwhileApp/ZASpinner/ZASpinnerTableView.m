//
//  ZACircularTableView.m
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import "ZASpinnerTableView.h"
#import "ZASpinnerTableViewCell.h"
#import "ZASpinnerView.h"

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
        ZASpinnerTableViewCell *currCell = (ZASpinnerTableViewCell*)[self cellForRowAtIndexPath:currIndexPath];
        CGRect rawCurrRect = [self rectForRowAtIndexPath:currIndexPath];
        CGRect currRect = CGRectOffset(rawCurrRect, -self.contentOffset.x, -self.contentOffset.y);
        CGFloat x = currRect.origin.y+currRect.size.height/2;
        CGFloat arcHeight = [self arcHeightFromX:x];
        currCell.frame = CGRectMake(arcHeight, currCell.frame.origin.y, currCell.bounds.size.width, currCell.bounds.size.height);
        CGFloat halfwayThroughTable = self.frame.size.width/2;
        currCell.circularArcText.radius = self.radius;
        currCell.circularArcText.arcSize = 4*currCell.circularArcText.text.length;
        currCell.circularArcText.shiftV = -0.534f*self.radius-0.8573f;
        CGFloat rotateAngle = [self angleFromX:x];
        CGFloat l = (self.frame.size.width/2 < self.radius) ? self.frame.size.width/2 : self.radius;
        if (x < l)
            rotateAngle *= -1;
        currCell.circularArcText.transform = CGAffineTransformMakeRotation(rotateAngle+M_PI_2);
        if (roundf(x) == halfwayThroughTable) {
            [self styleFocusedCell:currCell];
        }
        else {
            [self styleUnfocusedCell:currCell];
        }
    }
}

- (void)styleUnfocusedCell:(ZASpinnerTableViewCell*)cell {
    cell.circularArcText.color = [self parent].unfocusedFontColor;
    cell.circularArcText.font = [UIFont fontWithName:[self parent].fontName size:[self parent].unfocusedFontSize];
}

- (void)styleFocusedCell:(ZASpinnerTableViewCell*)cell {
    cell.circularArcText.color = [self parent].focusedFontColor;
    cell.circularArcText.font = [UIFont fontWithName:[self parent].fontName size:[self parent].focusedFontSize];
}

- (CGFloat)arcHeightFromX:(CGFloat)x {
    //http://liutaiomottola.com/formulae/sag.htm
    CGFloat r = self.radius;
    CGFloat l = (self.frame.size.width/2 < self.radius) ? self.frame.size.width/2 : self.radius;
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
