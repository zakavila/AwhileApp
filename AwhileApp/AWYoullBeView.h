//
//  AWYoullBeView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"
#import "AWDataModel.h"
#import "TCAwhileView.h"

@class AWYoullBeView;

@protocol AWYoullBeViewDelegate <NSObject>

- (void)awYoullBeView:(AWYoullBeView *)awYoullBeView homeButtonTouched:(UIButton *)homeButton;
- (void)youllBeView:(AWYoullBeView *)youllBeView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;

@end

@interface AWYoullBeView : TCAwhileView <ZASpinnerViewDelegate>

@property (weak) id <AWYoullBeViewDelegate> delegate;

@property (nonatomic, strong) NSArray *circleViews;
@property (nonatomic, strong) ZASpinnerView *totalTimeSpinner;
@property (nonatomic, strong) ZASpinnerView *incrementSpinner;
@property (nonatomic, strong) ZASpinnerView *daySpinner;
@property (nonatomic, strong) ZASpinnerView *monthSpinner;
@property (nonatomic, strong) ZASpinnerView *yearSpinner;

@property (nonatomic, strong) UIButton *homeButton;

@property (nonatomic, strong) AWDataModel* dataModel;

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data;

@end
