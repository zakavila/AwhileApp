//
//  AWBirthTimeViewController.m
//  AwhileApp
//
//  Created by Deren Kudeki on 4/29/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWBirthTimeViewController.h"
#import "AWDataModel.h"
#import "AWMainViewController.h"
#import "ZASpinnerView.h"

@interface AWBirthTimeViewController ()
@property (nonatomic, strong) AWBirthTimeView *birthTimeView;
@property (nonatomic, strong) AWDataModel* dataModel;
@property (nonatomic, strong) NSString* part;
@property (nonatomic, strong) NSNumber* minute;
@property (nonatomic, strong) NSNumber* hour;
@end

@implementation AWBirthTimeViewController

- (id)initWithData:(AWDataModel *)dateModel {
    self = [super init];
	
    if (self) {
		self.dataModel = dateModel;
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpStatusBar];
    
    [self setUpComponents];
    
    [self.view addSubview:self.birthTimeView];
}

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setUpComponents {
    self.part = @"IDK";
    self.minute = 0;
    self.hour = [NSNumber numberWithInt:12];
}

- (AWBirthTimeView*)birthTimeView
{
    if (!_birthTimeView) {
        _birthTimeView = [[AWBirthTimeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight)];
        _birthTimeView.delegate = self;
    }
    return _birthTimeView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)birthTimeView:(AWBirthTimeView*)birthTimeView spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value
{
    if ([spinner.spinnerName isEqualToString:@"partSpinner"])
    {
        self.part = value;
    }
    else if ([spinner.spinnerName isEqualToString:@"minutesSpinner"])
    {
        self.minute = [NSNumber numberWithInt:[value intValue]];
    }
    else if ([spinner.spinnerName isEqualToString:@"hourSpinner"])
    {
        self.hour = [NSNumber numberWithInt:[value intValue]];
    }
}

- (void)birthTimeView:(AWBirthTimeView*)birthTimeView spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *selectedString = [spinner contentValueForIndexPath:indexPath];
    NSLog(selectedString);
    [spinner goToRow:indexPath.row withAnimation:YES];
}

- (void)birthTimeView:(AWBirthTimeView *)birthTimeView nextButtonTouched:(UIButton *)nextButton
{
    if (![self.part isEqualToString:@"IDK"])
    {
        int addSeconds = 0;
        if ([self.part isEqualToString:@"pm"])
        {
            addSeconds += 12 * 60 * 60;
        }
        
        if (self.hour != [NSNumber numberWithInt:12])
        {
            addSeconds += [self.hour intValue] * 60 * 60;
        }
        
        addSeconds += [self.minute intValue] * 60;
        
        self.dataModel.birthTime = [self.dataModel.birthTime dateByAddingTimeInterval:addSeconds];
    }
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[AWMainViewController alloc] initWithData:_dataModel];
}

@end
