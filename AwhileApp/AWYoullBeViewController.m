//
//  AWYoullBeViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYoullBeViewController.h"
#import "AWYoullBeView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AWYoullBeViewController () <AWYoullBeViewDelegate>

@property (nonatomic, strong) AWYoullBeView *youllBeView;

@property (nonatomic, strong) NSNumber* value;
@property (nonatomic, strong) NSString* units;
@property (nonatomic, strong) NSNumber* day;
@property (nonatomic, strong) NSNumber* month;
@property (nonatomic, strong) NSNumber* year;

@end

@implementation AWYoullBeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.value = 0;
    self.units = @"Seconds";
    self.day = [NSNumber numberWithInt:1];
    self.month = [NSNumber numberWithInt:1];
    self.year = [NSNumber numberWithInt:1900];
    
    [self.view addSubview:self.youllBeView];
    [self.view bringSubviewToFront:self.youllBeView];
}

#pragma mark - Youll be view

- (AWYoullBeView *)youllBeView {
	if (!_youllBeView) {
		_youllBeView = [[AWYoullBeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andData:self.dataModel];
		[_youllBeView setDelegate:self];
	}
	
	return _youllBeView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Youll be view delegate

- (void)awYoullBeView:(AWYoullBeView *)awYoullBeView homeButtonTouched:(UIButton *)homeButton {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)youllBeView:(AWYoullBeView *)youllBeView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value
{
    if ([spinner.spinnerName isEqualToString:@"totalTimeSpinner"])
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
    }
}

- (void)spinToTimeInUnitWithSpinner:(ZASpinnerView*)spinner
{
    if ([self.units isEqualToString:@"Seconds"])
    {
        [spinner goToRow:[self.value intValue] withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Minutes"])
    {
        [spinner goToRow:([self.value intValue]/(60)) withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Hours"])
    {
        [spinner goToRow:([self.value intValue]/(60*60)) withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Days"])
    {
        [spinner goToRow:([self.value intValue]/(60*60*24)) withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Weeks"])
    {
        [spinner goToRow:([self.value intValue]/(60*60*24*7)) withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Months"])
    {
        [spinner goToRow:([self.value intValue]/(60*60*24*31)) withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Years"])
    {
        [spinner goToRow:([self.value intValue]/(60*60*24*365.25)) withAnimation:YES];
    }
    else if ([self.units isEqualToString:@"Decades"])
    {
        [spinner goToRow:([self.value intValue]/(60*60*24*365.25*10)) withAnimation:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
