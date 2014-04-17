//
//  AWYouAreView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextArcView.h"
#import "ZASpinnerView.h"
#import "AWDataModel.h"

@interface AWYouAreView : UIView <ZASpinnerViewDelegate>

@property (nonatomic, strong) CoreTextArcView *valueText;
@property (nonatomic, strong) ZASpinnerView *incrementSpinner;

@property (nonatomic, strong) UIButton *milestonesButton;
@property (nonatomic, strong) UIButton *homeButton;

@property (nonatomic, strong) AWDataModel* dataModel;

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data;

@end
