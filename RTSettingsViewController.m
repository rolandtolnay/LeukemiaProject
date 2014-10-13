//
//  RTSettingsViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 28/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTSettingsViewController.h"

@interface RTSettingsViewController ()

@end

@implementation RTSettingsViewController

-(NSMutableArray *)settingItems{
    if (!_settingItems) {
        _settingItems = [[NSMutableArray alloc]init];
    }
    return _settingItems;
}

- (void)viewDidLoad
{
    self.dataManagement = [RTDataManagement singleton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureSettings];
    
    self.tabBarController.delegate = self;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    if(tableView == self.painScaleSettingTableView || tableView == self.notificationSettingTableView){
        numberOfRows = self.actualItem.settingValues.count;
    }
    else if (tableView == self.masterTableview){
        numberOfRows = self.settingItems.count;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if(tableView == self.painScaleSettingTableView){
        CellIdentifier = @"detailCell";
        RTDetailTableViewCell *detailCell;
        detailCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        detailCell.detailCellLabel.text = [self.actualItem.settingValues objectAtIndex:indexPath.row];
        detailCell.detailCellImage.image = [UIImage imageNamed: detailCell.detailCellLabel.text];
        if (indexPath.row == self.dataManagement.selectedRowPainScale) {
            detailCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            detailCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return detailCell;
    }
    else if (tableView == self.notificationSettingTableView){
        CellIdentifier = @"notificationCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [self.actualItem.settingValues objectAtIndex:indexPath.row];
        if (indexPath.row == self.dataManagement.selectedRowNotification) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if (tableView == self.masterTableview){
        CellIdentifier = @"masterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [[self.settingItems objectAtIndex:indexPath.row]settingTitle];
        return cell;
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    if (tableView == self.painScaleSettingTableView || tableView == self.notificationSettingTableView) {
        title = self.actualItem.settingTitle;
    }
    else if (tableView == self.masterTableview){
        title = @"General Settings";
    }
    return title;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.masterTableview){
        self.actualItem = [self.settingItems objectAtIndex:indexPath.row];
        if([self.actualItem.settingTitle isEqualToString:@"Pain Scale"]){
            self.painScaleSettingTableView.hidden = NO;
            self.notificationSettingTableView.hidden = YES;
            [self.painScaleSettingTableView reloadData];
        }
        else if ([self.actualItem.settingTitle isEqualToString:@"Notification settings"]){
            self.painScaleSettingTableView.hidden = YES;
            self.notificationSettingTableView.hidden = NO;
            [self.notificationSettingTableView reloadData];
        }
    }
    else if (tableView == self.painScaleSettingTableView || tableView == self.notificationSettingTableView){
        if([self.actualItem.settingTitle isEqualToString:@"Pain Scale"]){
            self.dataManagement.selectedRowPainScale = indexPath.row;
            [self.painScaleSettingTableView reloadData];
        }
        else if ([self.actualItem.settingTitle isEqualToString:@"Notification settings"]){
            self.dataManagement.selectedRowNotification = indexPath.row;
            [self.notificationSettingTableView reloadData];
        }
        [self.dataManagement saveUserPrefrences];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    self.painScaleViewController = (RTPainScaleViewController *) [nav.viewControllers objectAtIndex:0];
    [self.painScaleViewController syncImagesWithSlider];
}

-(void)configureSettings{
    RTSettingItem *painScaleSettingItem = [[RTSettingItem alloc]init];
    painScaleSettingItem.settingTitle = @"Pain Scale";
    [painScaleSettingItem.settingValues addObject:@"Wong baker scale"];
    [painScaleSettingItem.settingValues addObject:@"Bieri Faces pain scale"];
    [self.settingItems addObject:painScaleSettingItem];
    
    RTSettingItem *notificationSettingItem = [[RTSettingItem alloc]init];
    notificationSettingItem.settingTitle = @"Notification settings";
    [notificationSettingItem.settingValues addObject:@"On"];
    [notificationSettingItem.settingValues addObject:@"Off"];
    [self.settingItems addObject:notificationSettingItem];
    
    self.masterTableview.delegate = self;
    self.masterTableview.dataSource = self;
    
    self.painScaleSettingTableView.delegate = self;
    self.painScaleSettingTableView.dataSource = self;
    
    self.notificationSettingTableView.delegate = self;
    self.notificationSettingTableView.dataSource = self;
    
    self.masterTableview.layer.borderWidth = 1.0;
    self.painScaleSettingTableView.layer.borderWidth = 1.0;
    self.notificationSettingTableView.layer.borderWidth = 1.0;
    
    self.masterTableview.layer.borderColor = [UIColor grayColor].CGColor;
    self.painScaleSettingTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.notificationSettingTableView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.masterTableview reloadData];
    [self.painScaleSettingTableView reloadData];
    [self.notificationSettingTableView reloadData];
    
    self.masterTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.painScaleSettingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.notificationSettingTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

@end
