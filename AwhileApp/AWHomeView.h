//
//  AWHomeView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAwhileView.h"

@class AWHomeView;

@protocol AWHomeViewDelegate <NSObject>

- (void)awHomeView:(AWHomeView *)awHomeView calculatorButtonTouched:(UIButton *)calculatorButtonTouched;
- (void)awHomeView:(AWHomeView *)awHomeView yourAgeButtonTouched:(UIButton *)yourAgeButtonTouched;

@end

@interface AWHomeView : TCAwhileView

@property (weak) id <AWHomeViewDelegate> delegate;
@property (nonatomic, strong) NSArray *circleViews;
@property (nonatomic, strong) UIButton *calculatorButton;
@property (nonatomic, strong) UIButton *yourAgeButton;

@end
