//
//  RTTabInteractiveTransition.m
//  Leukemia App
//
//  Created by dmu-23 on 09/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTTabInteractiveTransition.h"
#import "RTTabAnimator.h"

@interface RTTabInteractiveTransition ()

@property (assign, nonatomic, getter = isInteractive) BOOL interactive;
@property (weak, nonatomic) UITabBarController *parent;

@property (assign, nonatomic) NSUInteger oldIndex;
@property (assign, nonatomic) NSUInteger newIndex;

@end

@implementation RTTabInteractiveTransition

- (id)initWithTabBarController:(UITabBarController *)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
        _interactive = NO;
    }
    return self;
}

//  We override the designated init method of its superclass. This time, we throw an exception if this method is called. This forces us to always use our designated initializer.
- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark = UITabBarControllerDelegate Methods

-(id<UIViewControllerAnimatedTransitioning>)tabBarController: (UITabBarController *)tabBarController
          animationControllerForTransitionFromViewController: (UIViewController *)fromVC
                                            toViewController: (UIViewController *)toVC
{
    RTTabAnimator *animator = [[RTTabAnimator alloc] init];
    animator.tabBarController = self.parent;
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController: (UITabBarController *)tabBarController
                     interactionControllerForAnimationController: (id<UIViewControllerAnimatedTransitioning>) animationController
{
    if (self.interactive)
    {
        return self;
    }
    
    return nil;
}

#pragma mark - Pan handling methods

- (void)handleLeftPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.parent.view];
    
    CGFloat percent = -translation.x / CGRectGetWidth(self.parent.view.bounds);
    
    percent = MAX(percent, 0.0f);
    percent = MIN(percent, 1.0f);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSAssert(self.oldIndex == 0, @"We shouldnt already have an old index value");
        NSAssert(self.newIndex == 0, @"We shouldn’t already have a new index value");
        
        self.oldIndex = self.parent.selectedIndex;
        NSAssert(self.oldIndex != NSNotFound, @"Interactive transitions from the More tab are not possible");
        
        self.newIndex = self.oldIndex + 1;
        NSAssert(self.newIndex < [self.parent.viewControllers count], @"Trying to navigate past the last tab");
        
    }
    
    [self handleRecognizer:recognizer forTransitionPercent:percent];
}

- (void)handleRightPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.parent.view];
    
    CGFloat percent = translation.x / CGRectGetWidth(self.parent.view.bounds);
    
    percent = MAX(percent, 0.0f);
    percent = MIN(percent, 1.0f);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSAssert(self.oldIndex == 0, @"We shouldnt already have an old index value");
        NSAssert(self.newIndex == 0, @"We shouldn’t already have a new index value");
        
        self.oldIndex = self.parent.selectedIndex;
        NSAssert(self.oldIndex != NSNotFound, @"Interactive transitions from the More tab are not possible");
        
        self.newIndex = self.oldIndex - 1;
        NSAssert(self.newIndex >= 0, @"Trying to navigate past the first tab");
        
    }
    
    [self handleRecognizer:recognizer forTransitionPercent:percent];
}

- (void)handleRecognizer:(UIPanGestureRecognizer *)recognizer
    forTransitionPercent:(CGFloat)percent
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            self.interactive = YES;
            self.parent.selectedIndex = self.newIndex;
            break;
            
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.completionSpeed = 0.5;
            [self cancelInteractiveTransition];
            self.interactive = NO;
            self.newIndex = 0;
            self.oldIndex = 0;
            break;
            
        case UIGestureRecognizerStateEnded:
            self.completionSpeed = 0.5;
            if (percent > 0.3)
            {
                [self finishInteractiveTransition];
            }
            else
            {
                [self cancelInteractiveTransition];
            }
            self.newIndex = 0;
            self.oldIndex = 0;
            self.interactive = NO;
            break;
            
        default:
            NSLog(@"*** Invalid state found %@ ***", @(recognizer.state));
    }
}

@end
