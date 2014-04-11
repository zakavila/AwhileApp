//
//  AWYoullBeViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYoullBeViewController.h"
#import "AWYoullBeView.h"
#import "AWMilestonesViewController.h"

@interface AWYoullBeViewController ()
@property (nonatomic, strong) AWYoullBeView *mainView;
@end

@implementation AWYoullBeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainView = [[AWYoullBeView alloc] initWithFrame:self.view.frame];
    [self.mainView.milestonesButton addTarget:self action:sel_registerName("milestonesButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.homeButton addTarget:self action:sel_registerName("homeButtonPressed") forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainView];
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
