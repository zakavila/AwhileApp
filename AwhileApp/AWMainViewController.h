//
//  AWMainViewController.h
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWMainView.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface AWMainViewController : UIViewController <AWMainViewDelegate, EKEventEditViewDelegate>

@end
