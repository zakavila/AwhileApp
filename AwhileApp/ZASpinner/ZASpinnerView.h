//
//  ZASpinnerView.h
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerTableView.h"
#import "ZASpinnerTableViewCell.h"

@class ZASpinnerView;

@protocol ZASpinnerViewDelegate <NSObject>

- (void)spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;

@end

@interface ZASpinnerView : UIView <UITableViewDataSource, UITableViewDelegate>

@property id<ZASpinnerViewDelegate> spinnerDelegate;

@property (nonatomic, strong) ZASpinnerTableView *tableView;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat unfocusedFontSize;
@property (nonatomic) CGFloat focusedFontSize;
@property (nonatomic) UIColor *unfocusedFontColor;
@property (nonatomic) UIColor *focusedFontColor;
@property (nonatomic) CGFloat extraSpacing;
@property (nonatomic) CGFloat verticalShift;
@property (nonatomic, strong) NSString *fontName;
@property BOOL isInfinite;

- (void)goToRow:(NSInteger)rowIndex;

//Good parameters
//R=260, V=400, W=320
//R=150, V=120, W=200

@end