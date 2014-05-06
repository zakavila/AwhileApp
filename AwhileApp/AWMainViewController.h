//
//  AWMainViewController.h
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWMainView.h"
#import "AWDataModel.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AWTimeView.h"
#import "AWCircleViewController.h"

@interface AWMainViewController : AWCircleViewController <AWMainViewDelegate, AWTimeViewDelegate, UIViewControllerTransitioningDelegate, EKEventEditViewDelegate>

- (id)initWithData:(AWDataModel*)dateModel;

@end
