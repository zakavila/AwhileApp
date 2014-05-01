//
//  AWBirthTimeView.h
//  AwhileApp
//
//  Created by Deren Kudeki on 4/29/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@class AWBirthTimeView;

@protocol AWBirthTimeViewDelegate <NSObject>
- (void)birthTimeView:(AWBirthTimeView*)birthTimeView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;
- (void)birthTimeView:(AWBirthTimeView*)birthTimeView spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)birthTimeView:(AWBirthTimeView *)birthTimeView nextButtonTouched:(UIButton *)nextButton;
@end

@interface AWBirthTimeView : UIView <ZASpinnerViewDelegate>

@property id <AWBirthTimeViewDelegate> delegate;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) ZASpinnerView *partSpinner;
@property (nonatomic, strong) ZASpinnerView *minutesSpinner;
@property (nonatomic, strong) ZASpinnerView *hourSpinner;
@property (nonatomic, strong, readonly) NSMutableArray *circleViews;

@end
