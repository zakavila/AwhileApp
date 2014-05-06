//
//  AWBirthDateViewController.m
//  AwhileApp
//
//  Created by Deren Kudeki on 4/25/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWBirthDateViewController.h"
#import "AWBirthTimeViewController.h"
#import "ZASpinnerView.h"
#import "AWAppDelegate.h"
#import "AWFallingCircleAnimator.h"

@interface AWBirthDateViewController ()
@property (nonatomic, strong) AWBirthDateView *birthDateView;
@property (nonatomic, strong) NSString* day;
@property (nonatomic, strong) NSString* month;
@property (nonatomic, strong) NSString* year;
@end

@implementation AWBirthDateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.view.bounds = CGRectMake(self.view.bounds.origin.x, statusBarHeight-20.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self setUpStatusBar];
    
    [self setUpComponents];
    
    [self.view addSubview:self.birthDateView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *userBirthday = [userDefaults objectForKey:USER_BIRTHDAY_KEY];
    if (userBirthday) {
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:userBirthday];
        
        [self.birthDateView.daySpinner goToRow:[components day]-1 withAnimation:NO];
        self.day = [NSString stringWithFormat:@"%i",[components day]];
        [self.birthDateView.monthSpinner goToRow:[components month]-1 withAnimation:NO];
        self.month = [NSString stringWithFormat:@"%i",[components month]];
        [self.birthDateView.yearSpinner goToRow:[components year] withAnimation:NO];
        self.year = [NSString stringWithFormat:@"%i",[components year]];
    }
    self.circles = self.birthDateView.circleViews;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setUpComponents {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    self.day = [NSString stringWithFormat:@"%ld",(long)[components day]];
    self.month = [NSString stringWithFormat:@"%ld",(long)[components month]];
    self.year = [NSString stringWithFormat:@"%ld",(long)[components year]];
}

- (void)statusBarFrameDidChange:(NSNotification*)notification
{
    NSValue* newFrameValue = [[notification userInfo] objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect newFrameRect;
    [newFrameValue getValue:&newFrameRect];
    self.view.bounds = CGRectMake(self.view.bounds.origin.x, newFrameRect.size.height-20.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view layoutIfNeeded];
}

- (AWBirthDateView*)birthDateView
{
    if (!_birthDateView) {
        _birthDateView = [[AWBirthDateView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight)];
        _birthDateView.delegate = self;
    }
    return _birthDateView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)birthDateView:(AWBirthDateView*)birthDateView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value
{
    if (spinner == birthDateView.daySpinner)
    {
        self.day = value;
    }
    else if (spinner == birthDateView.monthSpinner)
    {
        if ([value isEqualToString:@"Jan"])
        {
            self.month = @"1";
        }
        else if ([value isEqualToString:@"Feb"])
        {
            self.month = @"2";
        }
        else if ([value isEqualToString:@"Mar"])
        {
            self.month = @"3";
        }
        else if ([value isEqualToString:@"Apr"])
        {
            self.month = @"4";
        }
        else if ([value isEqualToString:@"May"])
        {
            self.month = @"5";
        }
        else if ([value isEqualToString:@"Jun"])
        {
            self.month = @"6";
        }
        else if ([value isEqualToString:@"Jul"])
        {
            self.month = @"7";
        }
        else if ([value isEqualToString:@"Aug"])
        {
            self.month = @"8";
        }
        else if ([value isEqualToString:@"Sep"])
        {
            self.month = @"9";
        }
        else if ([value isEqualToString:@"Oct"])
        {
            self.month = @"10";
        }
        else if ([value isEqualToString:@"Nov"])
        {
            self.month = @"11";
        }
        else if ([value isEqualToString:@"Dec"])
        {
            self.month = @"12";
        }
    }
    else if (spinner == birthDateView.yearSpinner)
    {
        self.year = value;
    }
}

- (void)birthDateView:(AWBirthDateView *)birthDateView spinner:(ZASpinnerView *)spinner didSelectRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    NSString *selectedString = [spinner contentValueForIndexPath:indexPath];
    NSLog(selectedString);
    [spinner goToRow:indexPath.row withAnimation:YES];
}

- (void)birthDateView:(AWBirthDateView *)birthDateView nextButtonTouched:(UIButton *)nextButton
{
    if ([self.day intValue] < 29 || [self.month isEqualToString:@"1"] || [self.month isEqualToString:@"3"] || [self.month isEqualToString:@"5"] || [self.month isEqualToString:@"7"] || [self.month isEqualToString:@"8"] || [self.month isEqualToString:@"10"] || [self.month isEqualToString:@"12"] || (([self.month isEqualToString:@"4"] || [self.month isEqualToString:@"6"] || [self.month isEqualToString:@"9"] || [self.month isEqualToString:@"11"]) && [self.day intValue] < 31) || ([self.month isEqualToString:@"2"] && [self.day intValue] < 29) || ([self.month isEqualToString:@"2"] && [self.day intValue] < 30 && [self.year intValue] % 4 == 0))
    {
        AWBirthTimeViewController *timeVC = [[AWBirthTimeViewController alloc] initWithDay:self.day Month:self.month Year:self.year];
        timeVC.transitioningDelegate = self;
        timeVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:timeVC animated:YES completion:nil];

    }
}

#pragma mark Transitioning Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    AWFallingCircleAnimator *animator = [[AWFallingCircleAnimator alloc] init];
    return animator;
}


@end
