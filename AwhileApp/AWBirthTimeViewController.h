//
//  AWBirthTimeViewController.h
//  AwhileApp
//
//  Created by Deren Kudeki on 4/29/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWBirthTimeView.h"
#import "AWDataModel.h"
#import "AWCircleViewController.h"


@interface AWBirthTimeViewController : AWCircleViewController <AWBirthTimeViewDelegate, UIViewControllerTransitioningDelegate>

- (id)initWithDay:(NSString*)day Month:(NSString *)month Year:(NSString *)year;

@end
