//
//  AWBirthDateView.h
//  AwhileApp
//
//  Created by Deren Kudeki on 4/25/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@class AWBirthDateView;

@protocol AWBirthDateViewDelegate <NSObject>
- (void)birthDateView:(AWBirthDateView*)birthDateView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;
- (void)birthDateView:(AWBirthDateView*)birthDateView spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)birthDateView:(AWBirthDateView *)birthDateView nextButtonTouched:(UIButton *)nextButton;
@end

@interface AWBirthDateView : UIView

@property id <AWBirthDateViewDelegate> delegate;

@property (nonatomic, strong) UIButton *nextButton;

@end
