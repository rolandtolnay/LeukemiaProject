//
//  RTTabAnimator.m
//  Leukemia App
//
//  Created by dmu-23 on 09/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTTabAnimator.h"

static const NSTimeInterval AnimationDuration = 0.25;

@implementation RTTabAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return AnimationDuration;
}

-(void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    
    NSUInteger fromIndex = [self.tabBarController.viewControllers indexOfObject:fromViewController];
    
    NSUInteger toIndex =[self.tabBarController.viewControllers indexOfObject:toViewController];
    
    BOOL goRight = (fromIndex < toIndex);
    
    UIView *container = [transitionContext containerView];
    
    CGRect initialFromFrame = [transitionContext initialFrameForViewController:fromViewController];
    
    CGRect finalToFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGRect offscreenLeft = CGRectOffset(initialFromFrame, - CGRectGetWidth(container.bounds), 0.0);
    
    
    CGRect offscreenRight = CGRectOffset(initialFromFrame, CGRectGetWidth(container.bounds), 0.0);
    
    CGRect initialToFrame;
    CGRect finalFromFrame;
    if (goRight)
    {
        initialToFrame = offscreenRight;
        finalFromFrame = offscreenLeft;
    } else
    {
        initialToFrame = offscreenLeft;
        finalFromFrame = offscreenRight;
    }
    
    fromViewController.view.frame = initialFromFrame;
    toViewController.view.frame = initialToFrame;
    
    [container addSubview:fromViewController.view];
    [container addSubview:toViewController.view];
    
    UIViewAnimationOptions options = 0;
    if ([transitionContext isInteractive])
    {
        options = UIViewAnimationOptionCurveLinear;
    }
    
    [UIView animateWithDuration:AnimationDuration
     delay:0.0
     options:options
     animations:^{
         toViewController.view.frame = finalToFrame;
         fromViewController.view.frame = finalFromFrame;
     } completion:^(BOOL finished) {
         BOOL didComplete = ![transitionContext transitionWasCancelled];
         
         if (!didComplete)
         {
             toViewController.view.frame = initialToFrame;
             fromViewController.view.frame = initialFromFrame;
         }
         
         [transitionContext completeTransition:didComplete];
     }];
}

@end
