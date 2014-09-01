//
//  RTSettingsViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 28/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RTSettingItem.h"
#import "RTDetailTableViewCell.h"
#import "RTDataManagement.h"

@interface RTSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *masterTableview;
@property (weak, nonatomic) IBOutlet UITableView *painScaleSettingTableView;
@property (weak, nonatomic) IBOutlet UITableView *notificationSettingTableView;

@property (strong, nonatomic) NSMutableArray *settingItems;
@property (strong,nonatomic) RTSettingItem *actualItem;
@property (strong,nonatomic) RTDataManagement *dataManagement;

@end
