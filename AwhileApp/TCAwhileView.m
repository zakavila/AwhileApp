//
//  TCAwhileView.m
//  AwhileApp
//
//  Created by Troy Chmieleski on 4/16/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "TCAwhileView.h"

// awhile bar
#define AWHILE_BAR_IMAGE_NAME @"awhileBar"

@implementation TCAwhileView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self addSubview:self.awhileBar];
		[self setBackgroundColor:[UIColor whiteColor]];
    }
	
    return self;
}

#pragma mark - Awhile bar

- (UIImageView *)awhileBar {
	if (!_awhileBar) {
		_awhileBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:AWHILE_BAR_IMAGE_NAME]];
	}
	
	return _awhileBar;
}

@end
