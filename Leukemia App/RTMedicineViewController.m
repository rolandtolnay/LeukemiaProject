//
//  RTSecondViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTMedicineViewController.h"

@interface RTMedicineViewController ()

@property UIPopoverController *kemoPopover;

@end

@implementation RTMedicineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.mtxText.delegate = self;
    self.m6Text.delegate = self;
    
    self.dataManagement = [RTDataManagement singleton];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.medicineView.layer.borderWidth = 1.0;
    self.medicineView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self initMedicineView];
}

-(void)initMedicineView{
    if (self.dataManagement.kemoTreatmentArray.count == 0) {
        self.mtxText.enabled = YES;
        self.m6Text.enabled = YES;
        self.addHighDoseKemo.hidden = NO;
        self.saveDose.hidden = NO;
    }
    else{
        //Index of the latest entry - this is current kemo treatment
        int index = (int)self.dataManagement.kemoTreatmentArray.count - 1;
        
        self.editDose.hidden = NO;
        self.mtxText.text = [[self.dataManagement.kemoTreatmentArray[index] objectForKey:@"mtx"] stringValue];
        self.m6Text.text = [[self.dataManagement.kemoTreatmentArray[index]  objectForKey:@"6mp"] stringValue];
        self.addHighDoseKemo.hidden = YES;
        self.editHighDoseKemo.hidden = NO;
    }
}

#pragma mark - Doses

- (IBAction)saveDose:(id)sender {
    NSMutableDictionary *kemoTreatment = [self.dataManagement kemoTreatmentForDay:[NSDate date]];
    
    if (kemoTreatment == nil) {
        kemoTreatment = [[NSMutableDictionary alloc] init];
        [kemoTreatment setObject:@"" forKey:@"kemoTreatment"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [kemoTreatment setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        [self.dataManagement.kemoTreatmentArray addObject:kemoTreatment];
    }

    [kemoTreatment setObject:[NSNumber numberWithInt:[self.mtxText.text intValue]] forKey:@"mtx"];
    [kemoTreatment setObject:[NSNumber numberWithInt:[self.m6Text.text intValue]] forKey:@"6mp"];
    
    self.mtxText.enabled = NO;
    self.m6Text.enabled = NO;
    self.saveDose.hidden = YES;
    self.editDose.hidden = NO;
    [self.dataManagement writeToPList];
}

- (IBAction)editDose:(id)sender {
    self.mtxText.enabled = YES;
    self.m6Text.enabled = YES;
    self.saveDose.hidden = NO;
    self.editDose.hidden = YES;
}

#pragma mark - Kemo

-(void)noKemoUI{
    self.highDoseKemoLabel.text = NSLocalizedString(@"No high-dose kemo today", nil);
    self.addHighDoseKemo.hidden = NO;
    self.editHighDoseKemo.hidden = YES;
}

-(void)showKemoUI: (NSDate *)date{
    NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
    int index = (int)self.dataManagement.kemoTreatmentArray.count - 1;
    NSString *kemoType = [self.dataManagement.kemoTreatmentArray[index] objectForKey:@"kemoTreatment"];
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:kemoType];
    self.addHighDoseKemo.hidden = YES;
    self.editHighDoseKemo.hidden = NO;
}

#pragma mark

//-(void)checkDate{
//    if([self.dataManagement.kemoTabletData objectForKey:@"mtx"] == nil){
//        
//        [self.dataManagement.kemoTabletData setObject:@"0" forKey:@"mtx"];
//        [self.dataManagement.kemoTabletData setObject:@"0" forKey:@"6mp"];
//    }
//    NSMutableDictionary *dataToCheck = [self.dataManagement medicineDataAtDate:self.weekSelector.selectedDate];
//    
//    //Check if there is a sample on this day
//    //if sample - Show it make it editable
//    if(dataToCheck != nil){
//        if([[dataToCheck objectForKey:@"bloodSample"]count]>0){
//            [self showBloodSampleUI:self.weekSelector.selectedDate];
//        }
//    }
//    //if no sample - Make it possible to add a sample
//    else{
//        [self noBloodSampleUI];
//    }
//    //Checks if there is highdosekemo this day
//    if(dataToCheck != nil){
//        
//        if([[dataToCheck objectForKey:@"kemoTreatment"]length]>1){
//            
//            [self showKemoUI:self.weekSelector.selectedDate];
//        }
//    }
//    //if no high-dose kemo - Make it possible to add
//    else{
//        [self noKemoUI];
//    }
//    
//    //always hides the view for adding samples when you change date
//    self.addBloodSampleView.hidden = YES;
//}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"selectKemo"]){
        RTSelectKemoTableViewController *controller = [segue destinationViewController];
        self.kemoPopover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.kemoPopover.delegate = self;
        controller.delegate = self;
        self.addHighDoseKemo.hidden = YES;
        self.editHighDoseKemo.hidden = NO;
    }
}

#pragma  mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - RTSelectKemo delegate

//TODO: change date-getter to label
-(void)didSelectKemo:(NSString *)kemoType{
    NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
    
    [self.kemoPopover dismissPopoverAnimated:YES];
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:kemoType];
    
    NSMutableDictionary *kemoTreatment = [self.dataManagement kemoTreatmentForDay:[NSDate date]];
    if (kemoTreatment == nil) {
        kemoTreatment = [[NSMutableDictionary alloc] init];
        [kemoTreatment setObject:[NSNumber numberWithInt:0] forKey:@"mtx"];
        [kemoTreatment setObject:[NSNumber numberWithInt:0] forKey:@"6mp"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [kemoTreatment setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        [self.dataManagement.kemoTreatmentArray addObject:kemoTreatment];
    }
    
    [kemoTreatment setObject:kemoType forKey:@"kemoTreatment"];
    
    [self.dataManagement writeToPList];
}
@end
