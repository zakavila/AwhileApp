//
//  AWTimeViewController.m
//  AwhileApp
//
//  Created by Matthew Ford on 5/1/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWTimeViewController.h"
#import "ZASpinnerView.h"
#import "AWIconSpinnerCell.h"
#import "AWBirthDateViewController.h"
#import "TCProgressHUD.h"

#define AWHILE_APP_SHARE @"It's been awhile. Check out my age."
#define AWHILE_APP_URL @"http://awhileapp.com"

@interface AWTimeViewController ()
@property (nonatomic, strong) AWDataModel* dataModel;
@property (nonatomic, strong) NSString* hour;
@property (nonatomic, strong) NSString* minute;
@property (nonatomic, strong) NSString* amPm;
@end

@implementation AWTimeViewController

- (id)initWithData:(AWDataModel *)dateModel {
    self = [super init];
	self.hour = @"12";
    self.minute = @":00";
    self.amPm = @"am";
    if (self) {
		self.dataModel = dateModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.view.bounds = CGRectMake(self.view.bounds.origin.x, statusBarHeight-20.0f, self.view.bounds.size.width, self.view.bounds.size.height);
	
	[self setUpStatusBar];
    [self.view addSubview:self.timeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (AWTimeView*)timeView
{
    if (!_timeView) {
        _timeView = [[AWTimeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight) thing:self.dataModel.date];
        _timeView.delegate = self;
    }
    return _timeView;
}

- (void)statusBarFrameDidChange:(NSNotification*)notification
{
    NSValue* newFrameValue = [[notification userInfo] objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect newFrameRect;
    [newFrameValue getValue:&newFrameRect];
    self.view.bounds = CGRectMake(self.view.bounds.origin.x, newFrameRect.size.height-20.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view layoutIfNeeded];
}
- (void)timeView:(AWTimeView*)timeView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value
{
    if (spinner==_timeView.hourSpinner)
    {
        self.hour = value;
    }
    if (spinner==_timeView.minuteSpinner)
    {
        self.minute = value;
    }
    if (spinner==_timeView.amPmSpinner)
    {
        self.amPm = value;
    }
    
   
}

- (void)timeView:(AWTimeView *)timeView spinner:(ZASpinnerView *)spinner didSelectRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    if (spinner == timeView.menuSpinner) {
        [spinner goToRow:indexPath.row withAnimation:YES];
        NSString * dateString = [NSString stringWithFormat:@"%@ %@%@ %@", _dataModel.date, self.hour, self.minute, self.amPm];
        NSString * increment = _dataModel.increment;
        NSString * val = _dataModel.value;
        NSString * you = _dataModel.you;
        
        if ([contentValue isEqualToString:@"Birthday"]) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[AWBirthDateViewController alloc] init];
        }
        
        if ([contentValue isEqualToString:@"Calculator"]) {
            [self willMoveToParentViewController:nil];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
        if ([contentValue isEqualToString: @"Alarm"]) {
            EKEventEditViewController* vc = [[EKEventEditViewController alloc] init];
            EKEventStore* eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                vc.eventStore = eventStore;
                EKEvent* event = [EKEvent eventWithEventStore:eventStore];
                // Prepopulate all kinds of useful information with you event.
                event.title = [NSString stringWithFormat:@"%@ %@ %@ on", you, val, increment];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MMM/d/yy hh:mm a";
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
        
        if ([contentValue isEqualToString: @"Share"]) {
			NSLog(@"Should share");
			
			[TCProgressHUD showWithMaskType:TCProgressHUDMaskTypeBlack];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSString *shareString = AWHILE_APP_SHARE;
				NSString *shareURL = [NSURL URLWithString:AWHILE_APP_URL];
				UIImage *shareImage;
				
				UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
				[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
				shareImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
				
				UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareString, shareURL, shareImage] applicationActivities:nil];
				
				CGFloat delayInSeconds = 0.4f;
				dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds*NSEC_PER_SEC);
				
				dispatch_after(delay, dispatch_get_main_queue(), ^{
					[TCProgressHUD dismiss];
					
					[self presentViewController:activityViewController animated:YES completion:nil];
				});
			});
        }
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