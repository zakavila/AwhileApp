//
//  AWYouAreViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYouAreViewController.h"
#import "AWYouAreView.h"

#import "TCAwhileView.h"

// screen dimensions
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AWYouAreViewController () <AWYouAreViewDelegate>

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

#pragma mark - You are view

- (AWYouAreView *)youAreView {
	if (!_youAreView) {
		_youAreView = [[AWYouAreView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
		[_youAreView setDelegate:self];
	}
	
	return _youAreView;
}

#pragma mark - You are view delegate

- (void)youAreView:(AWYouAreView *)youAreView homeButtonTouched:(UIButton *)homeButton {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)youAreView:(AWYouAreView *)youAreView spinner:(ZASpinnerView *)spinner didChangeTo:(NSString *)value {
	 NSString *totalAgeString = [[self.dataModel youAreUnit:value] stringValue];
	
	self.youAreView.valueText.text = totalAgeString;
	
	[self.youAreView setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
