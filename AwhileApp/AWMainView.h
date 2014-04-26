//
//  AWMainView.h
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZASpinnerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@class AWMainView;

@protocol AWMainViewDelegate <NSObject>
- (void)mainView:(AWMainView*)mainView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value;
- (void)mainView:(AWMainView*)mainView spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface AWMainView : UIView <ZASpinnerViewDelegate>

@property id <AWMainViewDelegate> delegate;

- (NSArray*)menuSpinnerContents;

@end
