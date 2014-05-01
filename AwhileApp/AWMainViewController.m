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
#import "TCProgressHUD.h"
#import "AWBirthDateViewController.h"

#define AWHILE_APP_SHARE @"It's been awhile. Check out my age."
#define AWHILE_APP_URL @"http://awhileapp.com"

@interface AWMainViewController ()
@property (nonatomic, strong) AWMainView *mainView;
@property (nonatomic, strong) AWDataModel* dataModel;
@end

@implementation AWMainViewController

- (id)initWithData:(AWDataModel *)dateModel {
    self = [super init];
	
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
	
    [self.view addSubview:self.mainView];
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

- (AWMainView*)mainView
{
    if (!_mainView) {
        _mainView = [[AWMainView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight)];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (void)statusBarFrameDidChange:(NSNotification*)notification
{
    NSValue* newFrameValue = [[notification userInfo] objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect newFrameRect;
    [newFrameValue getValue:&newFrameRect];
    self.view.bounds = CGRectMake(self.view.bounds.origin.x, newFrameRect.size.height-20.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view layoutIfNeeded];
}

- (void)mainView:(AWMainView*)mainView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value {
    /*if ([spinner.spinnerName isEqualToString:@"totalTimeSpinner"])
    {
        NSDate *newDate;
        if ([self.units isEqualToString:@"Seconds"])
        {
            self.value = @([value intValue]);
        }
        else if ([self.units isEqualToString:@"Minutes"])
        {
            self.value = @([value intValue]*60);
        }
        else if ([self.units isEqualToString:@"Hours"])
        {
            self.value = @([value intValue]*60*60);
        }
        else if ([self.units isEqualToString:@"Days"])
        {
            self.value = @([value intValue]*60*60*24);
        }
        else if ([self.units isEqualToString:@"Weeks"])
        {
            self.value = @([value intValue]*60*60*24*7);
        }
        else if ([self.units isEqualToString:@"Months"])
        {
            self.value = @([value intValue]*60*60*24*31);
        }
        else if ([self.units isEqualToString:@"Years"])
        {
            self.value = @([value intValue]*60*60*24*365.25);
        }
        else if ([self.units isEqualToString:@"Decades"])
        {
            self.value = @([value intValue]*60*60*24*365.25*10);
        }
        newDate = [self.dataModel.birthTime dateByAddingTimeInterval:[self.value floatValue]];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newDate];
        
        self.day = [NSNumber numberWithInt:[components day]];
        [youllBeView.daySpinner goToRow:([self.day intValue] - 1) withAnimation:YES];
        self.month = [NSNumber numberWithInt:[components month]];
        [youllBeView.monthSpinner goToRow:([self.month intValue] - 1) withAnimation:YES];
        self.year = [NSNumber numberWithInt:[components year]];
        [youllBeView.yearSpinner goToRow:[self.year intValue] withAnimation:YES];
    }
    else if ([spinner.spinnerName isEqualToString:@"incrementSpinner"])
    {
        self.units = value;
        [self spinToTimeInUnitWithSpinner:youllBeView.totalTimeSpinner];
    }
    else if ([spinner.spinnerName isEqualToString:@"daySpinner"])
    {
        self.value = [NSNumber numberWithInt:([self.value integerValue]+(60*60*24*(-[value integerValue] + [self.day integerValue])))];
        self.day = @([value intValue]);
        
        [self spinToTimeInUnitWithSpinner:youllBeView.totalTimeSpinner];
    }
    else if ([spinner.spinnerName isEqualToString:@"monthSpinner"])
    {
        int newMonth;
        if ([value isEqualToString:@"Jan"])
        {
            newMonth = 1;
        }
        else if ([value isEqualToString:@"Feb"])
        {
            newMonth = 2;
        }
        else if ([value isEqualToString:@"Mar"])
        {
            newMonth = 3;
        }
        else if ([value isEqualToString:@"Apr"])
        {
            newMonth = 4;
        }
        else if ([value isEqualToString:@"May"])
        {
            newMonth = 5;
        }
        else if ([value isEqualToString:@"Jun"])
        {
            newMonth = 6;
        }
        else if ([value isEqualToString:@"Jul"])
        {
            newMonth = 7;
        }
        else if ([value isEqualToString:@"Aug"])
        {
            newMonth = 8;
        }
        else if ([value isEqualToString:@"Sep"])
        {
            newMonth = 9;
        }
        else if ([value isEqualToString:@"Oct"])
        {
            newMonth = 10;
        }
        else if ([value isEqualToString:@"Nov"])
        {
            newMonth = 11;
        }
        else if ([value isEqualToString:@"Dec"])
        {
            newMonth = 12;
        }
        
        self.value = [NSNumber numberWithInt:([self.value integerValue]+(60*60*24*30*(newMonth - [self.month integerValue])))];
        self.month = [NSNumber numberWithInt:newMonth];
        
        [self spinToTimeInUnitWithSpinner:youllBeView.totalTimeSpinner];
    }
    else
    {
        self.value = [NSNumber numberWithInt:([self.value integerValue]+(60*60*24*365*([value integerValue] - [self.year integerValue])))];
        self.year = @([value intValue]);
        
        [self spinToTimeInUnitWithSpinner:youllBeView.totalTimeSpinner];
    }*/
}

- (void)mainView:(AWMainView *)mainView spinner:(ZASpinnerView *)spinner didSelectRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    if (spinner == mainView.menuSpinner) {
        [spinner goToRow:indexPath.row withAnimation:YES];
        
        NSString * day = self.mainView.daySpinner.centeredValue;
        NSString * month = self.mainView.monthSpinner.centeredValue;
        NSString * year = self.mainView.yearSpinner.centeredValue;
        NSString * increment = self.mainView.incrementSpinner.centeredValue;
        NSString * val = self.mainView.valueSpinner.centeredValue;
        NSString * you = self.mainView.youSpinner.centeredValue;
        
        if ([contentValue isEqualToString:@"Birthday"]) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[AWBirthDateViewController alloc] init];
        }
        
        if ([contentValue isEqualToString: @"Alarm"]) {
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
