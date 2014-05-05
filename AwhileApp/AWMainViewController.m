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
@property (nonatomic, strong) AWTimeView *timeView;
@property (nonatomic, strong) AWDataModel* dataModel;
@property (nonatomic, strong) NSDate* calculatedDate;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
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
    [self.view addSubview:self.timeView];
    self.timeView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mainView.youSpinner.tableView beginUpdates];
    [self.mainView.youSpinner.tableView endUpdates];
    [self.mainView.incrementSpinner.tableView beginUpdates];
    [self.mainView.incrementSpinner.tableView endUpdates];
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

- (AWTimeView*)timeView
{
    if (!_timeView) {
        _timeView = [[AWTimeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight) thing:@""];
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

- (void)mainView:(AWMainView*)mainView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value {
    
    if (spinner == mainView.youSpinner)
    {
        if ([value isEqualToString:@"You were"])
        {
            self.calculatedDate = self.dataModel.birthTime;
            NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.calculatedDate];
            
            [mainView.daySpinner goToRow:[components day]-1 withAnimation:NO];
            self.day = [components day];
            [mainView.monthSpinner goToRow:[components month]-1 withAnimation:NO];
            self.month = [components month];
            [mainView.yearSpinner goToRow:[components year] withAnimation:NO];
            self.year = [components year];
            [mainView.valueSpinner goToRow:0 withAnimation:NO];
        }
        else if ([value isEqualToString:@"You are"])
        {
            self.calculatedDate = [NSDate date];
            NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.calculatedDate];
            
            [mainView.daySpinner goToRow:[components day]-1 withAnimation:NO];
            self.day = [components day];
            [mainView.monthSpinner goToRow:[components month]-1 withAnimation:NO];
            self.month = [components month];
            [mainView.yearSpinner goToRow:[components year] withAnimation:NO];
            self.year = [components year];
            [mainView.valueSpinner goToRow:[[self.dataModel seconds:[self.calculatedDate timeIntervalSinceDate:self.dataModel.birthTime] withUnit:self.mainView.incrementSpinner.centeredValue] intValue] withAnimation:NO];
        }
        else if ([value isEqualToString:@"You'll be"])
        {
            self.calculatedDate = [NSDate date];
            self.calculatedDate = [self.calculatedDate dateByAddingTimeInterval:(24*60*60)];
            NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.calculatedDate];
            
            [mainView.daySpinner goToRow:[components day]-1 withAnimation:NO];
            self.day = [components day];
            [mainView.monthSpinner goToRow:[components month]-1 withAnimation:NO];
            self.month = [components month];
            [mainView.yearSpinner goToRow:[components year] withAnimation:NO];
            self.year = [components year];
            [mainView.valueSpinner goToRow:[[self.dataModel seconds:[self.calculatedDate timeIntervalSinceDate:self.dataModel.birthTime] withUnit:self.mainView.incrementSpinner.centeredValue] intValue] withAnimation:NO];
        }
    }
    else if (spinner == mainView.yearSpinner)
    {
        NSInteger difference = [value integerValue] - self.year;
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setYear:difference];
        self.calculatedDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self.calculatedDate options:0];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.calculatedDate];
        
        self.year = [components year];
        [mainView.valueSpinner goToRow:[[self.dataModel seconds:[self.calculatedDate timeIntervalSinceDate:self.dataModel.birthTime] withUnit:self.mainView.incrementSpinner.centeredValue] intValue] withAnimation:NO];
        [self adjustYouSpinnerWithMainView:mainView];
    }
    else if (spinner == mainView.monthSpinner)
    {
        NSInteger monthNumber;
        if ([value isEqualToString:@"Jan"])
        {
            monthNumber = 1;
        }
        else if ([value isEqualToString:@"Feb"])
        {
            monthNumber = 2;
        }
        else if ([value isEqualToString:@"Mar"])
        {
            monthNumber = 3;
        }
        else if ([value isEqualToString:@"Apr"])
        {
            monthNumber = 4;
        }
        else if ([value isEqualToString:@"May"])
        {
            monthNumber = 5;
        }
        else if ([value isEqualToString:@"Jun"])
        {
            monthNumber = 6;
        }
        else if ([value isEqualToString:@"Jul"])
        {
            monthNumber = 7;
        }
        else if ([value isEqualToString:@"Aug"])
        {
            monthNumber = 8;
        }
        else if ([value isEqualToString:@"Sep"])
        {
            monthNumber = 9;
        }
        else if ([value isEqualToString:@"Oct"])
        {
            monthNumber = 10;
        }
        else if ([value isEqualToString:@"Nov"])
        {
            monthNumber = 11;
        }
        else if ([value isEqualToString:@"Dec"])
        {
            monthNumber = 12;
        }
            
        NSInteger difference = monthNumber - self.month;
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setMonth:difference];
        self.calculatedDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self.calculatedDate options:0];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self.calculatedDate];
        self.month = [components month];
        [mainView.valueSpinner goToRow:[[self.dataModel seconds:[self.calculatedDate timeIntervalSinceDate:self.dataModel.birthTime] withUnit:self.mainView.incrementSpinner.centeredValue] intValue] withAnimation:NO];
        
        [self adjustYouSpinnerWithMainView:mainView];
    }
    else if (spinner == mainView.daySpinner)
    {
        NSInteger difference = [value integerValue] - self.day;
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setDay:difference];
        self.calculatedDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self.calculatedDate options:0];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self.calculatedDate];
        
        self.day = [components day];
        [mainView.valueSpinner goToRow:[[self.dataModel seconds:[self.calculatedDate timeIntervalSinceDate:self.dataModel.birthTime] withUnit:self.mainView.incrementSpinner.centeredValue] intValue] withAnimation:YES];
        [self adjustYouSpinnerWithMainView:mainView];
    }
    else if (spinner == mainView.incrementSpinner)
    {
        [mainView.valueSpinner goToRow:[[self.dataModel seconds:[self.calculatedDate timeIntervalSinceDate:self.dataModel.birthTime] withUnit:self.mainView.incrementSpinner.centeredValue] intValue] withAnimation:NO];
    }
    else if (spinner == mainView.valueSpinner)
    {
        NSInteger difference = [value integerValue];
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        
        if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Seconds"])
        {
            [comps setSecond:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Minutes"])
        {
            [comps setMinute:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Hours"])
        {
            [comps setHour:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Days"])
        {
            [comps setDay:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Weeks"])
        {
            [comps setWeek:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Months"])
        {
            [comps setMonth:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Years"])
        {
            [comps setYear:difference];
        }
        else if ([self.mainView.incrementSpinner.centeredValue isEqualToString:@"Decades"])
        {
            [comps setYear:(10*difference)];
        }
        
        self.calculatedDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self.dataModel.birthTime options:0];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.calculatedDate];
        
        [mainView.daySpinner goToRow:[components day]-1 withAnimation:NO];
        self.day = [components day];
        [mainView.monthSpinner goToRow:[components month]-1 withAnimation:NO];
        self.month = [components month];
        [mainView.yearSpinner goToRow:[components year] withAnimation:NO];
        self.year = [components year];
        [self adjustYouSpinnerWithMainView:mainView];
    }
}

- (void)timeView:(AWTimeView *)timeView spinner:(ZASpinnerView *)spinner didChangeTo:(NSString *)value
{
    
}

- (void)timeView:(AWTimeView *)timeView spinner:(ZASpinnerView *)spinner didSelectRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    if (spinner == timeView.menuSpinner) {
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
        
        if ([contentValue isEqualToString:@"Calculator"]) {
            self.timeView.hidden = YES;
        }
    }

}

- (void)adjustYouSpinnerWithMainView:(AWMainView*)mainView
{
    if ([self.calculatedDate compare:[NSDate date]] == NSOrderedSame)
    {
        [mainView.youSpinner goToRow:1 withAnimation:YES];
    }
    else if ([self.calculatedDate compare:[NSDate date]] == NSOrderedDescending)
    {
        [mainView.youSpinner goToRow:2 withAnimation:YES];
    }
    else
    {
        [mainView.youSpinner goToRow:0 withAnimation:YES];
    }
}


- (NSInteger)getResult:(NSInteger)result inSecondsFromUnit:(NSString*)unit
{
    if ([unit isEqualToString:@"Seconds"])
    {
        return result;
    }
    else if ([unit isEqualToString:@"Minutes"])
    {
        return result*60;
    }
    else if ([unit isEqualToString:@"Hours"])
    {
        return result*60*60;
    }
    else if ([unit isEqualToString:@"Days"])
    {
        return result*60*60*24;
    }
    else if ([unit isEqualToString:@"Weeks"])
    {
        return result*60*60*24*7;
    }
    else if ([unit isEqualToString:@"Months"])
    {
        return result*60*60*24*365.25/12;
    }
    else if ([unit isEqualToString:@"Years"])
    {
        return result*60*60*24*365.25;
    }
    else if ([unit isEqualToString:@"Decades"])
    {
        return result*60*60*24*365.25*10;
    }
    return 0;
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
        
        NSString * date = [NSString stringWithFormat:@"%@/%@/%@", month, day, year];
        
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
        
        if ([contentValue isEqualToString:@"Time"]) {
            self.timeView.date = date;
            self.timeView.hidden = NO;
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
