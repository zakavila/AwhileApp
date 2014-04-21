//
//  AWYouAreView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAwhileView.h"
#import "CoreTextArcView.h"
#import "ZASpinnerView.h"
#import "AWDataModel.h"

@class AWYouAreView;

@protocol AWYouAreViewDelegate <NSObject>

- (void)youAreView:(AWYouAreView *)youAreView homeButtonTouched:(UIButton *)homeButton;
- (void)youAreView:(AWYouAreView *)youAreView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;

@end

@interface AWYouAreView : TCAwhileView <ZASpinnerViewDelegate>

@property id <AWYouAreViewDelegate> delegate;

@property (nonatomic, strong) NSArray *circleViews;

@property (nonatomic, strong) CoreTextArcView *valueText;
@property (nonatomic, strong) ZASpinnerView *incrementSpinnerView;

@property (nonatomic, strong) UIButton *homeButton;

@property (nonatomic, strong) AWDataModel* dataModel;

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data;

@end
