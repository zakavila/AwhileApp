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

@interface AWYouAreViewController ()
@property (nonatomic, strong) AWYouAreView *mainView;
@end

@implementation AWYouAreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setUpStatusBar];
	
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	
    self.mainView = [[AWYouAreView alloc] initWithFrame:self.view.frame andData:self.dataModel];
    [self.mainView.milestonesButton addTarget:self action:sel_registerName("milestonesButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.homeButton addTarget:self action:sel_registerName("homeButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainView];
	
	TCAwhileView *awhileView = [[TCAwhileView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	[self.view addSubview:awhileView];
}

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)milestonesButtonPressed
{
    [self.navigationController pushViewController:[[AWMilestonesViewController alloc] init] animated:YES];
}

- (void)homeButtonPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
