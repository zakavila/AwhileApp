//
//  AWTimeViewController.h
//  AwhileApp
//
//  Created by Matthew Ford on 5/1/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWTimeView.h"
#import "AWDataModel.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface AWTimeViewController : UIViewController <AWTimeViewDelegate>
@property (nonatomic, strong) AWTimeView *timeView;
- (id)initWithData:(AWDataModel*)dateModel;

@end
