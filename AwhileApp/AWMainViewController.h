//
//  AWMainViewController.h
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWMainView.h"
#import "AWDataModel.h"

@interface AWMainViewController : UIViewController <AWMainViewDelegate>

- (id)initWithData:(AWDataModel*)dateModel;

@end
