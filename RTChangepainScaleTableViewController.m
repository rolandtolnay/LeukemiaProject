//
//  RTChangepainScaleTableViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 10/10/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTChangepainScaleTableViewController.h"

@interface RTChangepainScaleTableViewController ()

@end

@implementation RTChangepainScaleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManagement = [RTDataManagement singleton];
    
    self.tableView.tableFooterView = [[UIView alloc] init] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"painScaleCell";
    RTDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.detailCellLabel.text = NSLocalizedString(@"Wong baker pain scale", nil);
        cell.detailCellImage.image = [UIImage imageNamed:@"Wong baker scale"];
    }
    else if (indexPath.row == 1){
        cell.detailCellLabel.text = NSLocalizedString(@"Bieri Faces pain scale",nil);
        cell.detailCellImage.image = [UIImage imageNamed: @"Bieri Faces pain scale"];
    }
    else if (indexPath.row == 2){
        cell.detailCellLabel.text = NSLocalizedString(@"FLACC pain scale", nil);
        cell.detailCellImage.image = [UIImage imageNamed: @"FLACC skala"];
    }
    if (indexPath.row == self.dataManagement.selectedRowPainScale) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        self.dataManagement.selectedRowPainScale = indexPath.row;
        [self.dataManagement saveUserPrefrences];
        [self.tableView reloadData];
        [self.delegate didSelectPainScale];
}


@end
