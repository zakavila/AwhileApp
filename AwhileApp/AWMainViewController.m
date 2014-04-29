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
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

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
 
}
- (void)eventEditViewController:(EKEventEditViewController*)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
