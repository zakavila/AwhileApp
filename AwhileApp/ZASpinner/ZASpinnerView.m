//
//  ZASpinnerView.m
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import "ZASpinnerView.h"
#import "ZASpinnerTableView.h"
#import "ZASpinnerTableViewCell.h"

@interface ZASpinnerView ()

@property (nonatomic, strong) ZASpinnerTableView *tableView;

@end

@implementation ZASpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.radius = -1;
        self.extraSpacing = -1;
        self.focusedFontSize = -1;
        self.unfocusedFontSize = -1;
        self.verticalShift = -1;
        self.isInfinite = NO;
        
        [self setUpTableView];
    }
    return self;
}

- (void)setUpTableView
{
    self.tableView = [[ZASpinnerTableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.radius = self.radius;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
}


#pragma mark TableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.frame.size.width/2 - 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.frame.size.width/2 - 22.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *dummyLabel = [[UILabel alloc] init];
    dummyLabel.text = [self stringAtIndexPath:indexPath];
    CGFloat textWidth = [dummyLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.focusedFontSize]}].width;
    return textWidth + 10.0f + self.extraSpacing;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    ZASpinnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ZASpinnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.circularTextLabel.text = [self stringAtIndexPath:indexPath];
    return cell;
}


#pragma mark ScrollView methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat newYOffset = [self getOffsetToCenterCells];
    if (scrollView.contentOffset.y != newYOffset) {
        [self.spinnerDelegate spinner:self didChangeTo:[self stringAtIndexPath:[self getClosestIndexPathToCenter]]];
        [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, newYOffset);
            [scrollView layoutSubviews];
        }completion:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}


#pragma mark Helper functions

- (CGFloat)getOffsetToCenterCells
{
    NSIndexPath *bestIndexPath = [self getClosestIndexPathToCenter];
    return self.tableView.contentOffset.y + [self getIndexPath:bestIndexPath distanceFromCenterOf:self.tableView];
}

- (NSIndexPath*)getClosestIndexPathToCenter
{
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath* bestIndexPath = nil;
    CGFloat leastDistance = -1.0;
    for (NSIndexPath *currIndexPath in visibleIndexPaths) {
        CGFloat distanceFromCenter = fabsf([self getIndexPath:currIndexPath distanceFromCenterOf:self.tableView]);
        if (leastDistance == -1.0 || leastDistance > distanceFromCenter) {
            leastDistance = distanceFromCenter;
            bestIndexPath = currIndexPath;
        }
    }
    return bestIndexPath;
}

- (CGFloat)getIndexPath:(NSIndexPath*)currIndexPath distanceFromCenterOf:(UITableView*)tableView
{
    CGRect rawCurrRect = [tableView rectForRowAtIndexPath:currIndexPath];
    CGRect currRect = CGRectOffset(rawCurrRect, -tableView.contentOffset.x, -tableView.contentOffset.y);
    CGFloat distanceFromTop = currRect.origin.y+currRect.size.height/2;
    return distanceFromTop - self.frame.size.width/2;
}

- (NSString*)stringAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *cellString = @"";
    if ([[[self contents] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
        cellString = [[self contents] objectAtIndex:indexPath.row];
    return cellString;
}


#pragma mark Getters/setters

@synthesize radius = _radius;
- (CGFloat)radius
{
    if (_radius == -1)
        return 260.0f;
    return _radius;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    if (radius != -1) {
        self.tableView.radius = radius;
    }
}



- (CGFloat)extraSpacing
{
    if (_extraSpacing == -1)
        return 30.0f;
    else
        return _extraSpacing;
}

- (CGFloat)focusedFontSize
{
    if (_focusedFontSize == -1)
        return 14.0f;
    return _focusedFontSize;
}

- (CGFloat)unfocusedFontSize
{
    if (_unfocusedFontSize == -1)
        return 12.0f;
    return _unfocusedFontSize;
}

- (CGFloat)verticalShift
{
    if (_verticalShift == -1)
        return 400.0f;
    return _verticalShift;
}

- (NSString*)fontName
{
    if (_fontName == nil)
        return @"HelveticaNeue";
    return _fontName;
}

@end
