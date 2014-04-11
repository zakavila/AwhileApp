//
//  AWBirthViewController.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWBirthViewController.h"
#import "AWBirthView.h"

@interface AWBirthViewController ()
@property (nonatomic, strong) AWBirthView *mainView;
@end

@implementation AWBirthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainView = [[AWBirthView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mainView];
    [self.mainView showBirthday];
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
