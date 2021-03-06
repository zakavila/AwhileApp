//
//  AWTimeView.h
//  AwhileApp
//
//  Created by Matthew Ford on 5/1/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@class AWTimeView;

@protocol AWTimeViewDelegate <NSObject>
- (void)timeView:(AWTimeView*)timeView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;
- (void)timeView:(AWTimeView*)timeView spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath withContentValue:(NSString*)contentValue;

@end

@interface AWTimeView : UIView <ZASpinnerViewDelegate>
@property (nonatomic, strong) NSString *date;
- (id)initWithFrame:(CGRect)frame thing:(NSString*)date;

@property id <AWTimeViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *circleViews;

@property (nonatomic, strong) ZASpinnerView *hourSpinner;
@property (nonatomic, strong) ZASpinnerView *minuteSpinner;
@property (nonatomic, strong) ZASpinnerView *amPmSpinner;

@property (nonatomic, strong) ZASpinnerView *menuSpinner;




@end
