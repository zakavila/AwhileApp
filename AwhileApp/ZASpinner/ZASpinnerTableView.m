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
        UITableViewCell *currCell = [self cellForRowAtIndexPath:currIndexPath];
        CGRect rawCurrRect = [self rectForRowAtIndexPath:currIndexPath];
        CGRect currRect = CGRectOffset(rawCurrRect, -self.contentOffset.x, -self.contentOffset.y);
        CGFloat x = currRect.origin.y+currRect.size.height/2;
        CGFloat arcHeight = [self arcHeightFromX:x];
        currCell.frame = CGRectMake(-arcHeight, currCell.frame.origin.y, currCell.frame.size.width, currCell.frame.size.height);
        CGFloat halfwayThroughTable = self.frame.size.width/2;
        ZASpinnerTableViewCell *currCircularCell = (ZASpinnerTableViewCell*)currCell;
        if (roundf(x) == halfwayThroughTable) {
            [self styleFocusedCell:currCircularCell];
        }
        else {
            [self styleUnfocusedCell:currCircularCell];
        }
    }
}

- (void)styleUnfocusedCell:(ZASpinnerTableViewCell*)cell {
    cell.circularTextLabel.textColor = [self parent].unfocusedFontColor;
    cell.circularTextLabel.font = [UIFont fontWithName:[self parent].fontName size:[self parent].unfocusedFontSize];
}

- (void)styleFocusedCell:(ZASpinnerTableViewCell*)cell {
    cell.circularTextLabel.textColor = [self parent].focusedFontColor;
    cell.circularTextLabel.font = [UIFont fontWithName:[self parent].fontName size:[self parent].focusedFontSize];
}

- (CGFloat)arcHeightFromX:(CGFloat)x {
    CGFloat x0 = 0.0f;
    CGFloat y0 = 0.0f;
    CGFloat rSquared = 0.0f;
    CGFloat chordLength = self.frame.size.width;
    CGFloat saggitaRootPart = pow(self.radius, 2)-pow(chordLength, 2)/4;
    if (saggitaRootPart > 0.0f) {
        CGFloat saggita = self.radius - sqrt(saggitaRootPart);
        x0 = chordLength/2;
        y0 = (saggita - pow(x0, 2)/saggita) / 2;
        rSquared = pow(x0, 2) + pow(y0, 2);
    }
    CGFloat arcHeight = 0.0f;
    CGFloat arcHeightRootPart = rSquared - pow(x - x0, 2);
    if (arcHeightRootPart > 0) {
        arcHeight = y0 - sqrt(arcHeightRootPart)+[self parent].verticalShift;//400;
    }
    return arcHeight;
}

- (ZASpinnerView*)parent {
    return (ZASpinnerView*)self.delegate;;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self repositionCells];
}

@end
