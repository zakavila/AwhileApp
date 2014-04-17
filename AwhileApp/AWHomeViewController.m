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
#import "AWMilestonesViewController.h"
#import "AWDataModel.h"

@interface AWHomeViewController ()
@property (nonatomic, strong) AWHomeView *mainView;
@property (nonatomic, strong) AWDataModel* dataModel;
@end

@implementation AWHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataModel = [[AWDataModel alloc] init];
    [self.dataModel check];
    self.mainView = [[AWHomeView alloc] initWithFrame:self.view.frame];
    [self.mainView.yourAgeButton addTarget:self action:sel_registerName("yourAgeButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.calculatorButton addTarget:self action:sel_registerName("calculatorButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.milestonesButton addTarget:self action:sel_registerName("milestonesButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainView];
}

- (void)yourAgeButtonPressed
{
    AWYouAreViewController *youAre = [[AWYouAreViewController alloc] init];
    youAre.dataModel = self.dataModel;
    [self.navigationController pushViewController:youAre animated:YES];
}

- (void)calculatorButtonPressed
{
    AWYoullBeViewController *youllBe = [[AWYoullBeViewController alloc] init];
    youllBe.dataModel = self.dataModel;
    [self.navigationController pushViewController:youllBe animated:YES];
}
- (void)milestonesButtonPressed
{
    [self.navigationController pushViewController:[[AWMilestonesViewController alloc] init] animated:YES];
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
