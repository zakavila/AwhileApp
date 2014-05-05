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
@property (nonatomic) NSInteger numberOfInfiniteCells;
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
        
        self.spinnerType = DefaultSpinner;
        self.radius = -1;
        self.chordLength = -1;
        self.extraSpacing = -1;
        self.arcMultiplier = 1.0f;
                
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
    NSInteger targetIndex;
    if (self.spinnerType == DefaultSpinner || !self.hasLoaded) {
        targetIndex = rowIndex;
    }
    else if (self.spinnerType == InfiniteCountSpinner) {
        NSInteger targetOffset = 0;
        if (rowIndex > self.numberOfInfiniteCells*.875)
            targetOffset = [self offsetForInfiniteArraysFromValue:rowIndex];
        if (((NSNumber*)[[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex] objectAtIndex:0]).integerValue != targetOffset) {
            if (targetOffset < self.numberOfInfiniteCells*.875)
                [self createInfiniteArraysForBeginning];
            else
                [self createInfiniteArraysForValue:rowIndex];
        }
        NSInteger adjustedRowIndex = rowIndex-targetOffset;
        targetIndex = adjustedRowIndex;
    }
    else if (self.spinnerType == InfiniteLoopSpinner) {
        targetIndex = rowIndex;
    }
    [self moveToIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] withAnimation:animate];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    NSIndexPath *bestIndexPath = [self getClosestIndexPathToCenter];
    _centeredIndex = bestIndexPath.row;
    _centeredValue = [self stringAtIndexPath:bestIndexPath];
    CGFloat newYOffset = [self getOffsetToShowIndex:bestIndexPath];
    if (self.tableView.contentOffset.y != newYOffset) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, newYOffset);
        //Not sure if needed, seems to work without for this
//        [self.tableView layoutSubviews];
    }
}

- (NSString*)contentValueForIndexPath:(NSIndexPath*)indexPath
{
    return [self stringAtIndexPath:indexPath];
}


#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.spinnerType != DefaultSpinner)
        return self.numberOfInfiniteCells;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.hasLoaded && indexPath.row == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
        self.hasLoaded = YES;
        [self.tableView reloadData];
        NSIndexPath *targetIndexPath;
        if (self.spinnerType == DefaultSpinner || (self.spinnerType == InfiniteCountSpinner && self.startIndex < 175))
            targetIndexPath = [NSIndexPath indexPathForRow:self.startIndex inSection:0];
        else if (self.spinnerType == InfiniteCountSpinner) {
            NSInteger targetOffset = [self offsetForInfiniteArraysFromValue:self.startIndex];
            targetIndexPath = [NSIndexPath indexPathForRow:(self.startIndex-targetOffset) inSection:0];
        }
        else if (self.spinnerType == InfiniteLoopSpinner) {
            NSInteger targetRow = 3*self.contents.count+self.startIndex-1;
            targetIndexPath = [NSIndexPath indexPathForRow:targetRow inSection:0];
        }
        [self moveToIndexPath:targetIndexPath withAnimation:NO];
        ZASpinnerCell *cell = (ZASpinnerCell*)[tableView cellForRowAtIndexPath:targetIndexPath];
        [self.spinnerDelegate spinner:self styleForCell:cell whileFocused:YES];
        //Not sure if these help with flickering/chopped initial cells, doesn't seem like it
//        [self.tableView layoutIfNeeded];
//        [self scrollViewDidEndDecelerating:tableView];
//        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.spinnerDelegate spinner:self didSelectRowAtIndexPath:indexPath withContentValue:[self stringAtIndexPath:indexPath]];
}


#pragma mark ScrollView methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *bestIndexPath = [self getClosestIndexPathToCenter];
    _centeredIndex = bestIndexPath.row;
    _centeredValue = [self stringAtIndexPath:bestIndexPath];
    CGFloat newYOffset = [self getOffsetToShowIndex:bestIndexPath];
    if (scrollView.contentOffset.y != newYOffset) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _centeredIndex = -1;
    _centeredValue = @"";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.spinnerType == InfiniteCountSpinner) {
        if (![self hasLoaded])
            return;
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
    else if (self.spinnerType == InfiniteLoopSpinner) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y < scrollView.contentSize.height*0.125f) {
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
    _centeredIndex = indexPath.row;
    _centeredValue = [self stringAtIndexPath:indexPath];
    CGFloat newYOffset = self.tableView.contentOffset.y + [self getIndexPath:indexPath distanceFromCenterOf:self.tableView];
    CGFloat duration = animate ? 0.5f : 0.0f;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, newYOffset);
        [self.tableView layoutSubviews];
    }completion:nil];
}

- (CGFloat)getOffsetToShowIndex:(NSIndexPath*)indexPath
{
    return self.tableView.contentOffset.y + [self getIndexPath:indexPath distanceFromCenterOf:self.tableView];
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
    if (self.spinnerType == InfiniteCountSpinner)
        return [self numberForInfiniteAtIndexPath:indexPath];
    else if (self.spinnerType == InfiniteLoopSpinner)
        return [self contentForInfiniteAtIndexPath:indexPath];
    NSString *cellString = @"";
    if ([[[self contents] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
        cellString = [[self contents] objectAtIndex:indexPath.row];
    return cellString;
}

- (NSString*)numberForInfiniteAtIndexPath:(NSIndexPath*)indexPath
{
    NSNumber *currNumber = [[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex] objectAtIndex:indexPath.row];
    return [NSString stringWithFormat:@"%ld", (long)currNumber.integerValue];
}

- (NSString*)contentForInfiniteAtIndexPath:(NSIndexPath*)indexPath
{
    NSNumber *currNumber = [[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex] objectAtIndex:indexPath.row];
    NSInteger contentIndex = currNumber.integerValue%self.contents.count;
    return [self.contents objectAtIndex:contentIndex];
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
    [((NSMutableArray*)[_infiniteArrays objectAtIndex:newPreviousArrayIndex]) removeAllObjects];
    NSInteger startValue = ((NSNumber*)[((NSMutableArray*)[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex]) objectAtIndex:0]).integerValue-self.numberOfInfiniteCells*.375;
    for (NSInteger currIndex = 0; currIndex < self.numberOfInfiniteCells; currIndex++) {
        NSNumber *currIndexValue = [NSNumber numberWithInteger:startValue+currIndex];
        [((NSMutableArray*)[self.infiniteArrays objectAtIndex:newPreviousArrayIndex]) addObject:currIndexValue];
    }
}

- (void)moveToNextInfiniteArray
{
    self.currInfiniteArrayIndex = [self nextInfiniteArrayIndexValue];
    NSInteger newNextArrayIndex = [self nextInfiniteArrayIndexValue];
    [((NSMutableArray*)[self.infiniteArrays objectAtIndex:newNextArrayIndex]) removeAllObjects];
    NSInteger startValue = ((NSNumber*)[((NSMutableArray*)[self.infiniteArrays objectAtIndex:self.currInfiniteArrayIndex]) objectAtIndex:0]).integerValue+self.numberOfInfiniteCells*.375;
    for (NSInteger currIndex = 0; currIndex < self.numberOfInfiniteCells; currIndex++) {
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
    for (NSInteger currIndex = 0; currIndex < self.numberOfInfiniteCells; currIndex++) {
        [firstArray addObject:[NSNumber numberWithInteger:currIndex]];
        [secondArray addObject:[NSNumber numberWithInteger:currIndex+self.numberOfInfiniteCells*.375]];
    }
    [_infiniteArrays addObjectsFromArray:@[firstArray, secondArray, thirdArray]];
}

- (NSUInteger)offsetForInfiniteArraysFromValue:(NSInteger)value
{
    return ceil((value-(self.numberOfInfiniteCells*.875))/(self.numberOfInfiniteCells*.375))*(self.numberOfInfiniteCells*.375);
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
    for (NSInteger currIndex = 0; currIndex < self.numberOfInfiniteCells; currIndex++) {
        [firstArray addObject:[NSNumber numberWithInteger:currIndex-self.numberOfInfiniteCells*.375+offset]];
        [secondArray addObject:[NSNumber numberWithInteger:currIndex+offset]];
        [thirdArray addObject:[NSNumber numberWithInteger:currIndex+self.numberOfInfiniteCells*.875+offset]];
    }
    [_infiniteArrays addObjectsFromArray:@[firstArray, secondArray, thirdArray]];
}


#pragma mark Getters/setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.tableView.contentInset = UIEdgeInsetsMake(self.frame.size.width/2, 0.0f, self.frame.size.width/2, 0.0f);
}

- (void)setSpinnerType:(ZASpinnerType)spinnerType
{
    _spinnerType = spinnerType;
    if (spinnerType == InfiniteCountSpinner) {
        self.numberOfInfiniteCells = 200;
    }
    else if (spinnerType == InfiniteLoopSpinner) {
        if (self.contents)
            self.numberOfInfiniteCells = self.contents.count*8;
        else
            self.numberOfInfiniteCells = 0;
    }
}

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

- (CGFloat)chordLength
{
    if (_chordLength == -1)
        return self.frame.size.width;
    return _chordLength;
}

@synthesize centeredIndex = _centeredIndex;
- (NSInteger)centeredIndex
{
    return _centeredIndex;
}
- (void)setCenteredIndex:(NSInteger)centeredIndex
{
    _centeredIndex = centeredIndex;
}

@synthesize centeredValue = _centeredValue;
- (NSString *)centeredValue
{
    return _centeredValue;
}
- (void)setCenteredValue:(NSString *)centeredValue
{
    _centeredValue = centeredValue;
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

- (void)setContents:(NSArray *)contents
{
    _contents = contents;
    if (self.spinnerType == InfiniteLoopSpinner)
        self.numberOfInfiniteCells = contents.count*8;
}

- (NSMutableArray *)infiniteArrays
{
    if (!_infiniteArrays) {
        if (self.startIndex < 175 && self.spinnerType == InfiniteCountSpinner)
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
