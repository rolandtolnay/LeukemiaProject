//
//  RTMucositisInfoTableViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 09/02/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import "RTMucositisInfoTableViewController.h"

@interface RTMucositisInfoTableViewController ()

@end

@implementation RTMucositisInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoContent = @[
                             (NSLocalizedString(@"Mild Oral Mucositis - Level 1", nil)),
                             (NSLocalizedString(@"Moderate Oral Mucositis - Level 2", nil)),
                             (NSLocalizedString(@"Severe Oral Mucositis - Level 3", nil)),
                             (NSLocalizedString(@"Severe Oral Mucositis - Level 4", nil))
                             ];
    
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMouthInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.infoLabel.text = [self.infoContent objectAtIndex:indexPath.row];
    cell.mucositisImageView.image = [UIImage imageNamed:[self.infoContent objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
