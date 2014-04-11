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

@interface AWYouAreView : UIView

@property (nonatomic, strong) CoreTextArcView *valueText;
@property (nonatomic, strong) ZASpinnerView *incrementSpinner;

@property (nonatomic, strong) UIButton *milestonesButton;
@property (nonatomic, strong) UIButton *homeButton;

@end
