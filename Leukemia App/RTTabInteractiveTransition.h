//
//  RTTabInteractiveTransition.h
//  Leukemia App
//
//  Created by dmu-23 on 09/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTTabInteractiveTransition : UIPercentDrivenInteractiveTransition <UITabBarControllerDelegate>

-(id) initWithTabBarController:(UITabBarController *) parent;

- (void)handleLeftPan:(UIPanGestureRecognizer *)recognizer;
- (void)handleRightPan:(UIPanGestureRecognizer *)recognizer;

@end
