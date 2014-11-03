//
//  RTRootTabBarController.m
//  Leukemia App
//
//  Created by dmu-23 on 09/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTRootTabBarController.h"
#import "RTTabInteractiveTransition.h"

@interface RTRootTabBarController ()

@property (strong,nonatomic) RTTabInteractiveTransition *interactiveTransition;

@end

@implementation RTRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.interactiveTransition = [[RTTabInteractiveTransition alloc] initWithTabBarController:self];
    
    self.delegate = self.interactiveTransition;
    [self setupEdgePanGestureRecognizers];
}

#pragma mark - Gesture Recognizers

//Add a gesture recognizer to each controller for swipe navigation between tabs
- (void)setupEdgePanGestureRecognizers
{
    NSUInteger count = [self.viewControllers count];
    for (NSUInteger index = 0; index < count; index++)
    {
        UIViewController *controller = self.viewControllers[index];
        
        if (index == 0) {
            [self addPanGestureRecognizerToViewController:controller
                                                 forEdges:UIRectEdgeRight];
        }
        else if (index == count - 1)
        {
            [self addPanGestureRecognizerToViewController:controller
                                                 forEdges:UIRectEdgeLeft];
        }
        else {
            [self addPanGestureRecognizerToViewController:controller
                                                 forEdges:UIRectEdgeRight];
            
            [self addPanGestureRecognizerToViewController:controller
                                                 forEdges:UIRectEdgeLeft];
        }
    }
}

- (void)addPanGestureRecognizerToViewController: (UIViewController *)controller
                                       forEdges: (UIRectEdge) edges
{
    NSParameterAssert((edges == UIRectEdgeLeft)||
                      (edges == UIRectEdgeRight));
    SEL selector;
    
    if (edges == UIRectEdgeLeft)
    {
        selector = @selector(handleRightPan:);
    }
    else
    {
        selector = @selector(handleLeftPan:);
    }
    
    UIScreenEdgePanGestureRecognizer *panRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.interactiveTransition action: selector];
    
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.edges = edges;
    [controller.view addGestureRecognizer:panRecognizer];
}


@end
