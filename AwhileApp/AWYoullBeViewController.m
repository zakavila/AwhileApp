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

@end

@implementation AWYoullBeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
