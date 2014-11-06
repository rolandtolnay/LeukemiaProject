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
    if (self.dataManagement.kemoTreatmentData.count == 0) {
        self.mtxText.enabled = YES;
        self.m6Text.enabled = YES;
        self.addHighDoseKemo.hidden = NO;
        self.saveDose.hidden = NO;
    }
    else{
        self.editDose.hidden = NO;
        self.mtxText.text = [self.dataManagement.kemoTreatmentData objectForKey:@"mtx"];
        self.m6Text.text = [self.dataManagement.kemoTreatmentData  objectForKey:@"6mp"];
        self.addHighDoseKemo.hidden = YES;
        self.editHighDoseKemo.hidden = NO;
    }
}

#pragma mark - Doses

- (IBAction)saveDose:(id)sender {
    [self.dataManagement.kemoTreatmentData setObject:self.mtxText.text forKey:@"mtx"];
    [self.dataManagement.kemoTreatmentData setObject:self.m6Text.text forKey:@"6mp"];
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
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:[self.dataManagement.kemoTreatmentData objectForKey:@"kemoTreatment"]];
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
    [self.dataManagement.kemoTreatmentData setObject:kemoType forKey:@"kemoTreatment"];
    [self.dataManagement writeToPList];
}
@end
