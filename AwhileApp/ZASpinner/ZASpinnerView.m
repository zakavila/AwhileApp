//
//  ZASpinnerView.m
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import "ZASpinnerView.h"
#import "ZASpinnerCell.h"

#define SpinnerTableViewCellIdentifier @"Spinner Table View Cell Identifier"

@interface ZASpinnerView ()

//For infinite
@property (nonatomic, strong) NSMutableArray *infiniteArrays;
@property (nonatomic) NSInteger currInfiniteArrayIndex;

@property (nonatomic) BOOL hasLoaded;

@end

@implementation ZASpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasLoaded = NO;
        
        self.radius = -1;
        self.extraSpacing = -1;
        self.arcMultiplier = 1.0f;
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
    self.tableView.allowsSelection = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.radius = self.radius;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
	
	[self.tableView registerClass:[ZASpinnerCell class] forCellReuseIdentifier:SpinnerTableViewCellIdentifier];
	
    [self addSubview:self.tableView];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

- (void)goToRow:(NSInteger)rowIndex withAnimation:(BOOL)animate
{
    if (![self isInfinite] || !self.hasLoaded) {
        [self moveToIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0] withAnimation:animate];
    }
    else {
        NSInteger targetOffset = 0;
        if (rowIndex > 175)
            targetOffset = [self offsetForInfiniteArraysFromValue:rowIndex];
        if (((NSNumber*)[[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex] objectAtIndex:0]).integerValue != targetOffset)
            [self createInfiniteArraysForValue:rowIndex];
        NSInteger adjustedRowIndex = rowIndex-targetOffset;
        [self moveToIndexPath:[NSIndexPath indexPathForRow:adjustedRowIndex inSection:0] withAnimation:animate];
    }
}

- (NSString*)contentValueForIndexPath:(NSIndexPath*)indexPath
{
    return [self stringAtIndexPath:indexPath];
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
    if (self.isInfinite)
        return 200;
    return [self.contents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.spinnerDelegate respondsToSelector:@selector(spinner:heightForRowAtIndexPath:withContentValue:)])
        return [self.spinnerDelegate spinner:self heightForRowAtIndexPath:indexPath withContentValue:[self stringAtIndexPath:indexPath]];
	CGRect dummyRect = CGRectIntegral([[self stringAtIndexPath:indexPath] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.0f]} context:nil]);
    return dummyRect.size.width + 10.0f + self.extraSpacing;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.spinnerDelegate respondsToSelector:@selector(spinner:cellForRowAtIndexPath:withContentValue:)])
        return [self.spinnerDelegate spinner:self cellForRowAtIndexPath:indexPath withContentValue:[self stringAtIndexPath:indexPath]];
    else
        return [self.tableView dequeueReusableCellWithIdentifier:SpinnerTableViewCellIdentifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.spinnerDelegate spinner:self didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.hasLoaded && indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
        self.hasLoaded = YES;
        [self.tableView reloadData];
        if (!self.isInfinite || self.startIndex < 175)
            [self moveToIndexPath:[NSIndexPath indexPathForRow:self.startIndex inSection:0] withAnimation:NO];
        else if (self.isInfinite) {
            NSInteger targetOffset = [self offsetForInfiniteArraysFromValue:self.startIndex];
            [self moveToIndexPath:[NSIndexPath indexPathForRow:(self.startIndex-targetOffset) inSection:0] withAnimation:NO];
        }
    }
}


#pragma mark ScrollView methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat newYOffset = [self getOffsetToCenterCells];
    if (scrollView.contentOffset.y != newYOffset) {
        [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, newYOffset);
            [scrollView layoutSubviews];
        }completion:^(BOOL finished){
            [self.spinnerDelegate spinner:self didChangeTo:[self stringAtIndexPath:[self getClosestIndexPathToCenter]]];
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isInfinite) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y < scrollView.contentSize.height*0.125f && ![self isShowingBelow25]) {
            [self moveToPreviousInfiniteArray];
            scrollView.contentOffset = CGPointMake(offset.x, scrollView.contentSize.height*0.5f);
        }
        else if (offset.y > scrollView.contentSize.height*0.875f) {
            [self moveToNextInfiniteArray];
            scrollView.contentOffset = CGPointMake(offset.x, scrollView.contentSize.height*0.5f);
        }
    }
}


#pragma mark Helper functions

- (void)moveToIndexPath:(NSIndexPath*)indexPath withAnimation:(BOOL)animate
{
    CGFloat newYOffset = self.tableView.contentOffset.y + [self getIndexPath:indexPath distanceFromCenterOf:self.tableView];
    CGFloat duration = animate ? 0.5f : 0.0f;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, newYOffset);
        [self.tableView layoutSubviews];
    }completion:nil];
}

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
    if (self.isInfinite)
        return [self stringForInfiniteAtIndexPath:indexPath];
    NSString *cellString = @"";
    if ([[[self contents] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
        cellString = [[self contents] objectAtIndex:indexPath.row];
    return cellString;
}

- (NSString*)stringForInfiniteAtIndexPath:(NSIndexPath*)indexPath
{
    NSNumber *currNumber = [[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex] objectAtIndex:indexPath.row];
    return [NSString stringWithFormat:@"%ld", (long)currNumber.integerValue];
}

- (BOOL)isShowingBelow25
{
    if (((NSNumber*)[[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex] objectAtIndex:0]).integerValue == 0)
        return YES;
    return NO;
}

- (void)moveToPreviousInfiniteArray
{
    self.currInfiniteArrayIndex = [self previousInfiniteArrayIndexValue];
    NSInteger newPreviousArrayIndex = [self previousInfiniteArrayIndexValue];
    [((NSMutableArray*)[self.infiniteArrays objectAtIndex:newPreviousArrayIndex]) removeAllObjects];
    NSInteger startValue = ((NSNumber*)[((NSMutableArray*)[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex]) objectAtIndex:0]).integerValue-75;
    for (NSInteger currIndex = 0; currIndex < 200; currIndex++) {
        NSNumber *currIndexValue = [NSNumber numberWithInteger:startValue+currIndex];
        [((NSMutableArray*)[self.infiniteArrays objectAtIndex:newPreviousArrayIndex]) addObject:currIndexValue];
    }
}

- (void)moveToNextInfiniteArray
{
    self.currInfiniteArrayIndex = [self nextInfiniteArrayIndexValue];
    NSInteger newNextArrayIndex = [self nextInfiniteArrayIndexValue];
    [((NSMutableArray*)[self.infiniteArrays objectAtIndex:newNextArrayIndex]) removeAllObjects];
    NSInteger startValue = ((NSNumber*)[((NSMutableArray*)[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex]) objectAtIndex:0]).integerValue+75;
    for (NSInteger currIndex = 0; currIndex < 200; currIndex++) {
        NSNumber *currIndexValue = [NSNumber numberWithInteger:startValue+currIndex];
        [((NSMutableArray*)[self.infiniteArrays objectAtIndex:newNextArrayIndex]) addObject:currIndexValue];
    }
}

- (NSInteger)previousInfiniteArrayIndexValue
{
    NSInteger returnValue = self.currInfiniteArrayIndex - 1;
    if (returnValue < 0)
        return 2;
    return returnValue;
}

- (NSInteger)nextInfiniteArrayIndexValue
{
    NSInteger returnValue = self.currInfiniteArrayIndex + 1;
    if (returnValue > 2)
        return 0;
    return returnValue;
}

- (void)createInfiniteArraysForBeginning
{
    self.currInfiniteArrayIndex = 0;
    _infiniteArrays = [[NSMutableArray alloc] init];
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
    NSMutableArray *secondArray = [[NSMutableArray alloc] init];
    NSMutableArray *thirdArray = [[NSMutableArray alloc] init];
    for (NSInteger currIndex = 0; currIndex < 200; currIndex++) {
        [firstArray addObject:[NSNumber numberWithInteger:currIndex]];
        [secondArray addObject:[NSNumber numberWithInteger:currIndex+75]];
    }
    [_infiniteArrays addObjectsFromArray:@[firstArray, secondArray, thirdArray]];
}

- (NSUInteger)offsetForInfiniteArraysFromValue:(NSInteger)value
{
    return ceil((value-175)/75.0f)*75;
}

- (void)createInfiniteArraysForValue:(NSInteger)value
{
    _infiniteArrays = nil;
    self.currInfiniteArrayIndex = 1;
    _infiniteArrays = [[NSMutableArray alloc] init];
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
    NSMutableArray *secondArray = [[NSMutableArray alloc] init];
    NSMutableArray *thirdArray = [[NSMutableArray alloc] init];
    NSInteger offset =  [self offsetForInfiniteArraysFromValue:value];//Need to create offset to account for section of arrays
    for (NSInteger currIndex = 0; currIndex < 200; currIndex++) {
        [firstArray addObject:[NSNumber numberWithInteger:currIndex-75+offset]];
        [secondArray addObject:[NSNumber numberWithInteger:currIndex+offset]];
        [thirdArray addObject:[NSNumber numberWithInteger:currIndex+175+offset]];
    }
    [_infiniteArrays addObjectsFromArray:@[firstArray, secondArray, thirdArray]];
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

- (void) setValue:(NSString *)value
{
    _value = value;
}

- (CGFloat)extraSpacing
{
    if (_extraSpacing == -1)
        return 30.0f;
    else
        return _extraSpacing;
}

- (void)setStartIndex:(NSInteger)startIndex
{
    _infiniteArrays = nil;
    _startIndex = startIndex;
}

- (NSMutableArray *)infiniteArrays
{
    if (!_infiniteArrays) {
        if (self.startIndex < 175)
            [self createInfiniteArraysForBeginning];
        else
            [self createInfiniteArraysForValue:self.startIndex];
    }
    return _infiniteArrays;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.tableView setFrame:self.bounds];
}

@end
