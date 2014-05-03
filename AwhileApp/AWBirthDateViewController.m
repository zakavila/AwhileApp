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
    
    [self setUpStatusBar];
    
    [self setUpComponents];
    
    [self.view addSubview:self.birthDateView];
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
    if ([spinner.spinnerName isEqualToString:@"daySpinner"])
    {
        self.day = value;
    }
    else if ([spinner.spinnerName isEqualToString:@"monthSpinner"])
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
    else if ([spinner.spinnerName isEqualToString:@"yearSpinner"])
    {
        NSLog(value);
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
        [UIApplication sharedApplication].keyWindow.rootViewController = [[AWBirthTimeViewController alloc] initWithDay:self.day Month:self.month Year:self.year];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
