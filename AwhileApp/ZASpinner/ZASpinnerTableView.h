//
//  ZACircularTableView.h
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZASpinnerTableView : UITableView

@property CGFloat radius;

@property (nonatomic, strong) UIFont *unfocusedFont;
@property (nonatomic, strong) UIFont *focusedFont;
@property (nonatomic, strong) UIColor *unfocusedFontColor;
@property (nonatomic, strong) UIColor *focusedFontColor;

@end
