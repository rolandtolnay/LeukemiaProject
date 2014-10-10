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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"painScaleCell";
    RTDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.detailCellLabel.text = @"Wong baker scale";
    }
    else if (indexPath.row == 1){
        cell.detailCellLabel.text = @"Bieri Faces pain scale";
    }
    cell.detailCellImage.image = [UIImage imageNamed: cell.detailCellLabel.text];
    if (indexPath.row == self.dataManagement.selectedRowPainScale) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.imageView.backgroundColor = [UIColor lightGrayColor];
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
