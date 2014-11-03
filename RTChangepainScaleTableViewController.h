//
//  RTChangepainScaleTableViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 10/10/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDetailTableViewCell.h"
#import "RTDataManagement.h"

@protocol RTChangePainScalePopoverDelegate <NSObject>
- (void)didSelectPainScale;
@end

@interface RTChangepainScaleTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *painScaleTableView;
@property (strong,nonatomic) RTDataManagement *dataManagement;
@property (nonatomic,assign) id delegate;

@end
