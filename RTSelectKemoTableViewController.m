//
//  RTSelectKemoTableViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 30/09/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTSelectKemoTableViewController.h"

@interface RTSelectKemoTableViewController ()

@end

@implementation RTSelectKemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init] ;
    self.kemoTypes = @[ NSLocalizedString(@"High-dose Methotrexat", nil),@"Asparaginase", @"Dexametason",@"Prednisolon", @"Doxorubicin", @"Vincristin", @"Cyclofosfamid"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.kemoTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectKemoCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.kemoTypes objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString(@"Kemo types", nil);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectedRowInPopover:[self.kemoTypes objectAtIndex:indexPath.row]];
}

@end
