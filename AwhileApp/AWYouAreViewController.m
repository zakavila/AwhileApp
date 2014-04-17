//
//  AWYouAreViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYouAreViewController.h"
#import "AWYouAreView.h"
#import "AWMilestonesViewController.h"

#import "TCAwhileView.h"

// screen dimensions
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AWYouAreViewController ()

@property (nonatomic, strong) AWYouAreView *youAreView;

@end

@implementation AWYouAreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setUpStatusBar];
	
    [self.view addSubview:self.youAreView];
}

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)milestonesButtonPressed {
    [self.navigationController pushViewController:[[AWMilestonesViewController alloc] init] animated:YES];
}

- (void)homeButtonPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - You are view

- (AWYouAreView *)youAreView {
	if (!_youAreView) {
		_youAreView = [[AWYouAreView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	}
	
	return _youAreView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
