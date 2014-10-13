//
//  RTSmileyTableViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 10/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDataManagement.h"

@protocol RTSmileyTableDelegate <NSObject>

-(void) didSelectSmiley:(NSInteger)smiley;

@end

@interface RTSmileyTableViewController : UIViewController

@property (nonatomic,assign) id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *smileyA;
@property (weak, nonatomic) IBOutlet UIImageView *smileyB;
@property (weak, nonatomic) IBOutlet UIImageView *smileyC;
@property (weak, nonatomic) IBOutlet UIImageView *smileyD;
@property (weak, nonatomic) IBOutlet UIImageView *smileyE;
@property (weak, nonatomic) IBOutlet UIImageView *smileyF;

-(IBAction)didTapSmiley:(id)sender;

@end
