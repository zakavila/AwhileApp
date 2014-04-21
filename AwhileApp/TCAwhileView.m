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

// awhile bar padding view
#define AWHILE_BAR_PADDING_VIEW_HEIGHT 0.0f

@implementation TCAwhileView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self addSubview:self.awhileBar];
		[self addSubview:self.awhileBarPaddingView];
		
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

#pragma mark - Awhile bar padding view

- (UIView *)awhileBarPaddingView {
	if (!_awhileBarPaddingView) {
		_awhileBarPaddingView = [[UIView alloc] initWithFrame:CGRectZero];
	}
	
	return _awhileBarPaddingView;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// awhile bar apdding view
	[self.awhileBarPaddingView setFrame:CGRectMake(0, self.awhileBar.frame.origin.y + self.awhileBar.bounds.size.height, self.bounds.size.width, AWHILE_BAR_PADDING_VIEW_HEIGHT)];
}

@end
