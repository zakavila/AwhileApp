//
//  ZASpinnerView.h
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerTableView.h"
#import "ZASpinnerCell.h"

@class ZASpinnerView;


@protocol ZASpinnerViewDelegate <NSObject>
@optional
- (void)spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;
- (void)spinner:(ZASpinnerView*)spinner styleForCell:(ZASpinnerCell*)cell whileFocused:(BOOL)isFocused;
- (void)spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)index withContentValue:(NSString*)contentValue;

@required
- (ZASpinnerCell*)spinner:(ZASpinnerView*)spinner cellForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString*)contentValue;
- (CGFloat)spinner:(ZASpinnerView*)spinner heightForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString*)contentValue;
@end


typedef enum {
    DefaultSpinner,
    InfiniteCountSpinner,
    InfiniteLoopSpinner
} ZASpinnerType;


@interface ZASpinnerView : UIView <UITableViewDataSource, UITableViewDelegate>

@property id<ZASpinnerViewDelegate> spinnerDelegate;

@property (nonatomic, strong) ZASpinnerTableView *tableView;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat extraSpacing;
@property (nonatomic) CGFloat verticalShift;
@property (nonatomic) CGFloat arcMultiplier;
@property (nonatomic) ZASpinnerType spinnerType;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic) NSInteger startIndex;
@property BOOL isInfinite;
@property (nonatomic, strong) NSString *spinnerName;
@property (nonatomic, readonly) NSInteger centeredIndex;
@property (nonatomic, strong, readonly) NSString *centeredValue;

- (void)goToRow:(NSInteger)rowIndex withAnimation:(BOOL)animate;
- (NSString*)contentValueForIndexPath:(NSIndexPath*)indexPath;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString*)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier;

@end