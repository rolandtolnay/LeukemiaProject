//
//  RTSmileyTableViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 10/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTSmileyTableDelegate <NSObject>

-(void) didSelectSmiley:(NSInteger)smiley;

@end

@interface RTSmileyTableViewController : UIViewController

@property (nonatomic,assign) id delegate;

-(IBAction)didTapSmiley:(id)sender;

@end
