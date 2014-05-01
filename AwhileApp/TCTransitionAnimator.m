//
//  TCTransitionAnimator.m
//  AwhileApp
//
//  Created by Troy Chmieleski on 5/1/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "TCTransitionAnimator.h"
#import "AWBirthTimeView.h"
#import "AWBirthDateView.h"

@implementation TCTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if (self.presenting) {
		[fromViewController.view setUserInteractionEnabled:NO];
		
		[transitionContext.containerView addSubview:fromViewController.view];
		[transitionContext.containerView addSubview:toViewController.view];
		
		CGRect startFrame = fromViewController.view.frame;
		startFrame.origin.y += fromViewController.view.frame.size.height;
		
		CGRect endFrame = fromViewController.view.frame;
		
		toViewController.view.frame = endFrame;
		
		AWBirthTimeView *birthTimeView;
		
		for (UIView *subView in toViewController.view.subviews) {
			if ([subView isKindOfClass:[AWBirthTimeView class]]) {
				birthTimeView = (AWBirthTimeView *)subView;
			}
		}
		
		for (UIView *circleView in birthTimeView.circleViews) {
			CGRect circleFrame = circleView.frame;
			circleFrame.origin.x = toViewController.view.frame.size.width/2;
			circleFrame.origin.y = toViewController.view.frame.size.height;
			circleView.frame = circleFrame;
		}

		[UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
			fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			
			NSInteger index = 0;
			
			for (UIView *circleView in birthTimeView.circleViews) {
				CGRect circleFrame = circleView.frame;
				circleFrame.size.width = 1;
				circleFrame.size.height = 1;
				[circleView setFrame:circleFrame];
				
				index++;
			}
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
		}];
	}
	
	else {
		[toViewController.view setUserInteractionEnabled:NO];
	}
}

@end
