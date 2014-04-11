//
//  AWBirthView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"

@interface AWBirthView : UIView

@property (nonatomic, strong) UIButton *nextButton;

- (void)showBirthtime;
- (void)showBirthday;

@end
