//
//  RTTabAnimator.h
//  Leukemia App
//
//  Created by dmu-23 on 09/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTTabAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (weak,nonatomic) UITabBarController *tabBarController;

@end
