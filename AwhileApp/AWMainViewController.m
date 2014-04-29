//
//  AWMainViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWMainViewController.h"
#import "ZASpinnerView.h"
#import "AWIconSpinnerCell.h"
//#import <EventKit/EventKit.h>
//#import <EventKitUI/EventKitUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ShareViewController.h"

@interface AWMainViewController ()
@property (nonatomic, strong) AWMainView *mainView;
@end

@implementation AWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setUpStatusBar];
	
    [self.view addSubview:self.mainView];
}

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (AWMainView*)mainView
{
    if (!_mainView) {
        _mainView = [[AWMainView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight)];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (void)mainView:(AWMainView*)mainView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value {
    NSString * day = self.mainView.daySpinner.centeredValue;
    NSString * month = self.mainView.monthSpinner.centeredValue;
    NSString * year = self.mainView.yearSpinner.centeredValue;
    NSString * increment = self.mainView.incrementSpinner.centeredValue;
    NSString * val = self.mainView.valueSpinner.centeredValue;
    NSString * you = self.mainView.youSpinner.centeredValue;
    
    if ([value isEqualToString: @"Alarm"]) {
        EKEventEditViewController* vc = [[EKEventEditViewController alloc] init];
        EKEventStore* eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            vc.eventStore = eventStore;
            EKEvent* event = [EKEvent eventWithEventStore:eventStore];
            // Prepopulate all kinds of useful information with you event.
            event.title = [NSString stringWithFormat:@"%@ %@ %@ on", you, val, increment];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", day, month, year];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"d-MMM-yy";
            NSDate *date = [dateFormatter dateFromString:dateString];
            event.startDate = date;
            event.endDate = date;
            event.URL = [NSURL URLWithString:@"awhile.appspot.com"];
            //event.notes = @"This event will be awesome!";
            NSMutableArray *myAlarmsArray = [[NSMutableArray alloc] init];
            EKAlarm *arrAlarm = [EKAlarm alarmWithAbsoluteDate:date];
            [myAlarmsArray addObject:arrAlarm];
            
            event.alarms = myAlarmsArray;
            event.allDay = YES;
            vc.event = event;
            
            vc.editViewDelegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }
    
    if ([value isEqualToString: @"Share"]) {
        ShareViewController *shareViewController = [[ShareViewController alloc] init];
        [FBLoginView class];
        // Set loginUIViewController as root view controller
        [self presentViewController:shareViewController animated:YES completion:nil];
    }
}

- (void)eventEditViewController:(EKEventEditViewController*)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
