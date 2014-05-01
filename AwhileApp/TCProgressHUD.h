//
//  TCProgressHUD.h
//  AwhileApp
//
//  Created by Troy Chmieleski on 4/30/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCProgressHUDMaskType) {
	TCProgressHUDMaskTypeNone,
	TCProgressHUDMaskTypeBlack,
	TCProgressHUDMaskTypeGradient
};

@interface TCProgressHUD : UIView

#pragma mark - Show methods

+ (void)show;
+ (void)showWithMaskType:(TCProgressHUDMaskType)maskType;
+ (void)dismiss;

@end
