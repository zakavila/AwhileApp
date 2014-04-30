//
//  AWBirthView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"
#import "TCAwhileView.h"

@interface AWBirthView : TCAwhileView

@property (nonatomic, strong) UIButton *nextButton;

- (void)showBirthtime;
- (void)showBirthday;

@end