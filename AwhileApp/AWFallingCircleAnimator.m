//
//  AWFallingCircleAnimator.m
//  AwhileApp
//
//  Created by Zak Avila on 5/2/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWFallingCircleAnimator.h"
#import "UIViewController+Animator.h"
#import "AWCircleViewController.h"

@implementation AWFallingCircleAnimator
{
    NSMutableArray *views;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (!views) {
        views = [[NSMutableArray alloc] init];
    }
    AWCircleViewController *fromVC = (AWCircleViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSInteger index = toVC.view.subviews.count;
	for (UIView *circleView in fromVC.circles) {
        UIView *ssView = [circleView resizableSnapshotViewFromRect:circleView.bounds afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        ssView.frame = circleView.frame;
        [views addObject:ssView];
        [toVC.view insertSubview:ssView atIndex:index];
    }
    [fromVC.view removeFromSuperview];
    [containerView addSubview:toVC.view];
    
    [self animateInnermostViewFallingFromViews:[views mutableCopy] andContext:transitionContext];
}

- (void)animateInnermostViewFallingFromViews:(NSMutableArray*)fallingViews andContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *innermostView = [fallingViews firstObject];
    [fallingViews removeObjectAtIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        innermostView.alpha = 0.9f;
        innermostView.bounds = CGRectMake(innermostView.bounds.size.width/2, innermostView.bounds.size.height/2, 0.0f, 0.0f);
	} completion:^(BOOL finished) {
		[innermostView removeFromSuperview];
        if (fallingViews.count > 0)
            [self animateInnermostViewFallingFromViews:fallingViews andContext:transitionContext];
        else {
            [views removeAllObjects];
            [transitionContext completeTransition:YES];
        }
	}];

}

@end
