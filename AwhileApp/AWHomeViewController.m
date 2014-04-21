//
//  AWHomeViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWHomeViewController.h"
#import "AWHomeView.h"
#import "AWYouAreViewController.h"
#import "AWYoullBeViewController.h"
#import "AWDataModel.h"

@interface AWHomeViewController () <AWHomeViewDelegate>

@property (nonatomic, strong) AWHomeView *homeView;
@property (nonatomic, strong) AWDataModel* dataModel;

@end

@implementation AWHomeViewController

- (id)init {
    self = [super init];
	
    if (self) {
		self.dataModel = [[AWDataModel alloc] init];
		[self.dataModel check];
		
		[self.view addSubview:self.homeView];
    }
	
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.view addSubview:self.homeView];
}

- (void)yourAgeButtonPressed {
    AWYouAreViewController *youAre = [[AWYouAreViewController alloc] init];
    youAre.dataModel = self.dataModel;
    [self.navigationController pushViewController:youAre animated:YES];
}

- (void)calculatorButtonPressed {
    AWYoullBeViewController *youllBe = [[AWYoullBeViewController alloc] init];
    youllBe.dataModel = self.dataModel;
    [self.navigationController pushViewController:youllBe animated:YES];
}

#pragma mark - Home view

- (AWHomeView *)homeView {
	if (!_homeView) {
		_homeView = [[AWHomeView alloc] initWithFrame:self.view.frame];
		[_homeView setDelegate:self];
	}
	
	return _homeView;
}

#pragma mark - Home view delegate

- (void)awHomeView:(AWHomeView *)awHomeView calculatorButtonTouched:(UIButton *)calculatorButtonTouched {
	AWYoullBeViewController *youllBeViewController = [[AWYoullBeViewController alloc] init];
	[youllBeViewController setDataModel:self.dataModel];
	
	[self presentViewController:youllBeViewController animated:YES completion:nil];
}

- (void)awHomeView:(AWHomeView *)awHomeView yourAgeButtonTouched:(UIButton *)yourAgeButtonTouched {
	AWYouAreViewController *youAreViewController = [[AWYouAreViewController alloc] init];
	[youAreViewController setDataModel:self.dataModel];
	
	[self presentViewController:youAreViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
