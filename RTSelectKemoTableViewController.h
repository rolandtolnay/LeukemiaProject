//
//  RTSelectKemoTableViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 30/09/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTPopoverContentDelegate <NSObject>
- (void)didSelectedRowInPopover:(NSString *)kemoType;
@end

@interface RTSelectKemoTableViewController : UITableViewController

@property (strong,nonatomic) NSArray *kemoTypes;

@property (nonatomic,assign) id delegate;

@end
