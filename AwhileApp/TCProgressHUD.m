//
//  TCProgressHUD.m
//  AwhileApp
//
//  Created by Troy Chmieleski on 4/30/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "TCProgressHUD.h"

@interface TCProgressHUD ()

@property (nonatomic, readwrite) TCProgressHUDMaskType maskType;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *progressBackgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activtyIndicatorView;

@end

@implementation TCProgressHUD

+ (TCProgressHUD *)sharedView {
	static TCProgressHUD *sharedView;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
	});
	
	return sharedView;
}

#pragma mark - Show methods

+ (void)show {
	[[self sharedView] showMaskType:TCProgressHUDMaskTypeNone];
}

+ (void)showWithMaskType:(TCProgressHUDMaskType)maskType {
	[[self sharedView] showMaskType:maskType];
}

+ (void)dismiss {
	[[self sharedView] dismiss];
}

- (void)showMaskType:(TCProgressHUDMaskType)maskType {
	if (!self.overlayView.superview) {
		NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
		
		for (UIWindow *window in frontToBackWindows) {
			if (window.windowLevel == UIWindowLevelNormal) {
				[window addSubview:self.overlayView];
				break;
			}
		}
	}
	
	if (!self.superview) {
		[self.overlayView addSubview:self];
	}
	
	self.maskType = maskType;
	
	if (maskType == TCProgressHUDMaskTypeBlack) {
		[self.progressBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
	}
	
	else if (maskType == TCProgressHUDMaskTypeGradient) {
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = self.progressBackgroundView.bounds;
		gradient.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor colorWithWhite:0.75f alpha:1.0].CGColor];
		[self.progressBackgroundView.layer insertSublayer:gradient atIndex:0];
		
		[self.progressBackgroundView setAlpha:0.5];
	}
	
	[self addSubview:self.progressBackgroundView];
	[self addSubview:self.activtyIndicatorView];
	
	if (self.alpha != 1) {		
		[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
			self.activtyIndicatorView.transform = CGAffineTransformScale(self.activtyIndicatorView.transform, 1/1.3, 1/1.3);
			self.alpha = 1;
		} completion:^(BOOL finished) {
			// no-op
		}];
		
		[self setNeedsDisplay];
	}
	
	[self.activtyIndicatorView startAnimating];
}

- (void)dismiss {
	[self.activtyIndicatorView stopAnimating];
	
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.activtyIndicatorView.transform = CGAffineTransformScale(self.activtyIndicatorView.transform, 0.8, 0.8);
		
		self.alpha = 0;
		
	} completion:^(BOOL finished) {
		[_activtyIndicatorView removeFromSuperview];
		_activtyIndicatorView = nil;
		
		[_progressBackgroundView removeFromSuperview];
		_progressBackgroundView = nil;
		
		[_overlayView removeFromSuperview];
		_overlayView = nil;
		
		// Tell the rootViewController to update the StatusBar appearance
		UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
		if ([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
			[rootController setNeedsStatusBarAppearanceUpdate];
		}
	}];
}

#pragma mark - Overlay view

- (UIView *)overlayView {
	if (!_overlayView) {
		_overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		[_overlayView setBackgroundColor:[UIColor clearColor]];
	}
	
	return _overlayView;
}

#pragma mark - Progress background view

- (UIView *)progressBackgroundView {
	if (!_progressBackgroundView) {
		_progressBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
		[_progressBackgroundView setBackgroundColor:[UIColor clearColor]];
	}
	
	return _progressBackgroundView;
}

#pragma mark - Activity indicator view

- (UIActivityIndicatorView *)activtyIndicatorView {
	if (!_activtyIndicatorView) {
		_activtyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[_activtyIndicatorView setCenter:self.center];
	}
	
	return _activtyIndicatorView;
}

@end
