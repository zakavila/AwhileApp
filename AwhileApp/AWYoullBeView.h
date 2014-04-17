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

@interface AWYoullBeView : UIView <ZASpinnerViewDelegate>

@property (nonatomic, strong) ZASpinnerView *valueSpinner;
@property (nonatomic, strong) ZASpinnerView *incrementSpinner;
@property (nonatomic, strong) ZASpinnerView *daySpinner;
@property (nonatomic, strong) ZASpinnerView *monthSpinner;
@property (nonatomic, strong) ZASpinnerView *yearSpinner;

@property (nonatomic, strong) UIButton *milestonesButton;
@property (nonatomic, strong) UIButton *homeButton;

@property (nonatomic, strong) AWDataModel* dataModel;

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data;

@end
