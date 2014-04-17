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

@end
