//
//  RTSecondViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTMedicineViewController.h"

@interface RTMedicineViewController ()

@property UIPopoverController *popover;

@end

@implementation RTMedicineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(UITextField *txtField in self.bloodSampleTextFields){
        txtField.delegate = self;
    }
    
    self.mtxText.delegate = self;
    self.m6Text.delegate = self;
    
    self.dataManagement = [RTDataManagement singleton];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.medicineView.layer.borderWidth = 1.0;
    self.medicineView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.weekSelector = [[LSWeekView alloc] initWithFrame:CGRectZero style:LSWeekViewStyleDefault];
    self.weekSelector.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.weekSelector.calendar = [NSCalendar currentCalendar];
    
    self.weekSelector.selectedDate = [NSDate date];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [self checkDate];
    
    __weak typeof(self) weakSelf = self;
    self.weekSelector.didChangeSelectedDateBlock = ^(NSDate *selectedDate)
    {
        [weakSelf checkDate];
    };
    
    [self.weekSelectorView addSubview:self.weekSelector];
    
    [self initMedicineView];
    NSLog(@"medicine data: %@",self.dataManagement.medicineData);
}

#pragma mark - Blood sample data management

- (IBAction)saveSample:(id)sender {
    self.saveSampleButton.hidden = YES;
    self.editSampleButton.hidden = NO;
    for (UITextField *txtField in self.bloodSampleTextFields) {
        txtField.enabled = NO;
    }
    //Save sample in datamangement
    NSMutableDictionary *dataToBeSaved = [self.dataManagement medicineDataAtDate:self.weekSelector.selectedDate];
    if(dataToBeSaved == nil){
        dataToBeSaved = [self.dataManagement newMedicineData:self.weekSelector.selectedDate];
    }
    NSMutableDictionary *bloodSampleData = [dataToBeSaved objectForKey:@"bloodSample"];
    [bloodSampleData setObject:self.hemoText.text forKey:@"hemoglobin"];
    [bloodSampleData setObject:self.thromboText.text forKey:@"thrombocytes"];
    [bloodSampleData setObject:self.neutroText.text forKey:@"neutrofile"];
    [bloodSampleData setObject:self.crpText.text forKey:@"crp"];
    [bloodSampleData setObject:self.leukocytterText.text forKey:@"leukocytes"];
    [bloodSampleData setObject:self.alatText.text forKey:@"alat"];
    [bloodSampleData setObject:self.otherText.text forKey:@"other"];
    
    [self.dataManagement writeToPList];
}

- (IBAction)editSample:(id)sender {
    self.saveSampleButton.hidden = NO;
    self.editSampleButton.hidden = YES;
    for (UITextField *txtField in self.bloodSampleTextFields) {
        txtField.enabled = YES;
    }
}

#pragma mark - Blood sample UI

- (IBAction)addSample:(id)sender {
    self.addSampleButton.hidden = YES;
    self.noSampleLabel.text = @"";
    
    self.addBloodSampleView.hidden = NO;
}

- (IBAction)unwindToBloodSamples:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if([sourceViewController isKindOfClass:[RTAddBloodSampleViewController class]]){
        
        RTAddBloodSampleViewController *controller = segue.sourceViewController;
        [controller saveSampleWithDate:self.weekSelector.selectedDate];
        [self checkDate];
    }
    
}

-(void)noBloodSampleUI{
    for (UILabel *label in self.bloodSampleLabels) {
        label.hidden = YES;
    }
    for(UITextField *txtField in self.bloodSampleTextFields){
        txtField.hidden = YES;
    }
    self.saveSampleButton.hidden = YES;
    self.editSampleButton.hidden = YES;
    self.noSampleLabel.text = NSLocalizedString(@"There is no bloodsample for this date", nil);
    
    //bloodsamples can only be added to current date or past dates
    NSDate *today = [NSDate date];
    NSComparisonResult result = [self.weekSelector.selectedDate compare:today];
    if (result == NSOrderedSame || result == NSOrderedAscending)
        self.addSampleButton.hidden = NO;
    else self.addSampleButton.hidden = YES;
    
    
}

-(void)showBloodSampleUI:(NSDate *)date{
    //    NSDictionary *tempDict = [self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate]];
    NSMutableDictionary *bloodSampleData = [[self.dataManagement medicineDataAtDate:date]objectForKey:@"bloodSample"];
    self.noSampleLabel.text = @"";
    self.hemoText.text = [bloodSampleData objectForKey:@"hemoglobin"];
    self.thromboText.text = [bloodSampleData objectForKey:@"thrombocytes"];
    self.neutroText.text = [bloodSampleData objectForKey:@"neutrofile"];
    self.crpText.text = [bloodSampleData objectForKey:@"crp"];
    self.leukocytterText.text = [bloodSampleData objectForKey:@"leukocytes"];
    self.alatText.text = [bloodSampleData objectForKey:@"alat"];
    self.otherText.text = [bloodSampleData objectForKey:@"other"];
    self.addSampleButton.hidden = YES;
    self.saveSampleButton.hidden = YES;
    self.editSampleButton.hidden = NO;
    for (UILabel *label in self.bloodSampleLabels) {
        label.hidden = NO;
    }
    for (UITextField *txtField in self.bloodSampleTextFields) {
        txtField.enabled = NO;
        txtField.hidden = NO;
    }
}

#pragma mark - Doses

- (IBAction)saveDose:(id)sender {
    [self.dataManagement.kemoTabletData setObject:self.mtxText.text forKey:@"mtx"];
    [self.dataManagement.kemoTabletData setObject:self.m6Text.text forKey:@"6mp"];
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
    self.highDoseKemoButton.hidden = NO;
    self.editHighDoseKemo.hidden = YES;
}

-(void)showKemoUI: (NSDate *)date{
    NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:[[self.dataManagement medicineDataAtDate:date] objectForKey:@"kemoTreatment"]];
    self.highDoseKemoButton.hidden = YES;
    self.editHighDoseKemo.hidden = NO;
}

#pragma mark

//-(void)checkDate{
//    //Check if there is a sample on this day
//    //if sample - Show it make it editable
//    if([self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate]] != nil){
//        [self showBloodSampleUI:self.weekSelector.selectedDate];
//    }
//    //if no sample - Make it possible to add a sample
//    else{
//        [self noBloodSampleUI];
//    }
//    //Checks if there is highdosekemo this day
//    if([self.dataManagement.kemoTreatment objectForKey:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate]] != nil){
//        [self showKemoUI:self.weekSelector.selectedDate];
//    }
//    //if no high-dose kemo - Make it possible to add
//    else{
//        [self noKemoUI];
//    }
//
//    //always hides the view for adding samples when you change date
//    self.addBloodSampleView.hidden = YES;
//}

-(void)checkDate{
    if([self.dataManagement.kemoTabletData objectForKey:@"mtx"] == nil){
        
        [self.dataManagement.kemoTabletData setObject:@"0" forKey:@"mtx"];
        [self.dataManagement.kemoTabletData setObject:@"0" forKey:@"6mp"];
    }
    NSMutableDictionary *dataToCheck = [self.dataManagement medicineDataAtDate:self.weekSelector.selectedDate];
    
    //Check if there is a sample on this day
    //if sample - Show it make it editable
    if(dataToCheck != nil){
        if([[dataToCheck objectForKey:@"bloodSample"]count]>0){
            [self showBloodSampleUI:self.weekSelector.selectedDate];
        }
    }
    //if no sample - Make it possible to add a sample
    else{
        [self noBloodSampleUI];
    }
    //Checks if there is highdosekemo this day
    if(dataToCheck != nil){
        
        if([[dataToCheck objectForKey:@"kemoTreatment"]length]>1){
            
            [self showKemoUI:self.weekSelector.selectedDate];
        }
    }
    //if no high-dose kemo - Make it possible to add
    else{
        [self noKemoUI];
    }
    
    //always hides the view for adding samples when you change date
    self.addBloodSampleView.hidden = YES;
}

-(void)initMedicineView{
    if (self.dataManagement.kemoTabletData.count == 0) {
        self.mtxText.enabled = YES;
        self.m6Text.enabled = YES;
        self.saveDose.hidden = NO;
    }
    else{
        self.editDose.hidden = NO;
        self.mtxText.text = [self.dataManagement.kemoTabletData objectForKey:@"mtx"];
        self.m6Text.text = [self.dataManagement.kemoTabletData  objectForKey:@"6mp"];
    }
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"selectKemo"]){
        RTSelectKemoTableViewController *controller = [segue destinationViewController];
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
        controller.delegate = self;
        self.highDoseKemoButton.hidden = YES;
        self.editHighDoseKemo.hidden = NO;
    }
}

-(void)didSelectedRowInPopover:(NSString *)kemoType{
    NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
    NSMutableDictionary *dataToBeSaved = [self.dataManagement medicineDataAtDate:self.weekSelector.selectedDate];
    
    if(dataToBeSaved == nil){
        dataToBeSaved = [self.dataManagement newMedicineData:self.weekSelector.selectedDate];
        //        dataToBeSaved = [[NSMutableDictionary alloc]init];
        //        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //        [dataToBeSaved setObject:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate] forKey:@"date"];
        //        [dataToBeSaved setObject:[self.dataManagement.kemoTabletData objectForKey:@"mtx"] forKey:@"mtx"];
        //        [dataToBeSaved setObject:[self.dataManagement.kemoTabletData objectForKey:@"6mp"] forKey:@"6mp"];
        //        [dataToBeSaved setObject:[[NSMutableDictionary alloc]init]forKey:@"bloodSample"];
        //        [self.dataManagement.medicineData addObject:dataToBeSaved];
    }
    
    [self.popover dismissPopoverAnimated:YES];
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:kemoType];
    [dataToBeSaved setObject:kemoType forKey:@"kemoTreatment"];
    [self.dataManagement writeToPList];
}

#pragma  mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.hemoText isFirstResponder] && [touch view] != self.hemoText) {
        [self.hemoText resignFirstResponder];
    }
    else if ([self.thromboText isFirstResponder] && [touch view] != self.thromboText) {
        [self.thromboText resignFirstResponder];
    }
    else if ([self.neutroText isFirstResponder] && [touch view] != self.neutroText) {
        [self.neutroText resignFirstResponder];
    }
    else if ([self.crpText isFirstResponder] && [touch view] != self.crpText) {
        [self.crpText resignFirstResponder];
    }
    else if ([self.leukocytterText isFirstResponder] && [touch view] != self.leukocytterText) {
        [self.leukocytterText resignFirstResponder];
    }
    else if ([self.alatText isFirstResponder] && [touch view] != self.alatText) {
        [self.alatText resignFirstResponder];
    }
    else if ([self.otherText isFirstResponder] && [touch view] != self.otherText) {
        [self.otherText resignFirstResponder];
    }
    else if ([self.mtxText isFirstResponder] && [touch view] != self.mtxText) {
        [self.mtxText resignFirstResponder];
    }
    else if ([self.m6Text isFirstResponder] && [touch view] != self.m6Text) {
        [self.m6Text resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
@end
