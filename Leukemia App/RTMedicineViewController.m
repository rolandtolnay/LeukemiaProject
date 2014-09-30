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
    
    self.dataManagement = [RTDataManagement singleton];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.medicineView.layer.borderWidth = 1.0;
    self.medicineView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.weekSelector = [[LSWeekView alloc] initWithFrame:CGRectZero style:LSWeekViewStyleDefault];
    self.weekSelector.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.weekSelector.calendar = [NSCalendar currentCalendar];

    self.weekSelector.selectedDate = [NSDate date];
    
    [self checkDate];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    __weak typeof(self) weakSelf = self;
    self.weekSelector.didChangeSelectedDateBlock = ^(NSDate *selectedDate)
    {
        [weakSelf checkDate];
    };
    
    [self.weekSelectorView addSubview:self.weekSelector];
    
    [self initMedicineView];
}

- (IBAction)addSample:(id)sender {
    [self addBloodSampleUI];
}

- (IBAction)saveSample:(id)sender {
    self.saveSampleButton.hidden = YES;
    self.editSampleButton.hidden = NO;
    for (UITextField *txtField in self.bloodSampleTextFields) {
        txtField.enabled = NO;
    }
    //Save sample in datamangement
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    [dataToBeSaved setObject:self.hemoText.text forKey:@"hemo"];
    [dataToBeSaved setObject:self.thromboText.text forKey:@"thrombo"];
    [dataToBeSaved setObject:self.neutroText.text forKey:@"neutro"];
    [dataToBeSaved setObject:self.crpText.text forKey:@"crp"];
    [dataToBeSaved setObject:self.natriumText.text forKey:@"natrium"];
    [self.dataManagement.bloodSampleData setObject:dataToBeSaved forKey:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate]];
    [self.dataManagement writeToPList];
}

- (IBAction)editSample:(id)sender {
    self.saveSampleButton.hidden = NO;
    self.editSampleButton.hidden = YES;
    for (UITextField *txtField in self.bloodSampleTextFields) {
        txtField.enabled = YES;
    }
}

- (IBAction)saveDose:(id)sender {
    [self.dataManagement.medicineData setObject:self.mtxText.text forKey:@"mtx"];
    [self.dataManagement.medicineData setObject:self.m6Text.text forKey:@"m6"];
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

-(void)addBloodSampleUI{
    self.addSampleButton.hidden = YES;
    self.noSampleLabel.text = @"";
    for (UILabel *label in self.bloodSampleLabels) {
        label.hidden = NO;
    }
    for(UITextField *txtField in self.bloodSampleTextFields){
        txtField.hidden = NO;
        txtField.text = @"";
        txtField.enabled = YES;
    }
    self.saveSampleButton.hidden = NO;
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
    self.addSampleButton.hidden = NO;
    self.noSampleLabel.text = @"There is no bloodsample for this date";

}

-(void)showBloodSampleUI:(NSDate *)date{
    NSDictionary *tempDict = [self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate]];
    self.noSampleLabel.text = @"";
    self.hemoText.text = [tempDict objectForKey:@"hemo"];
    self.thromboText.text = [tempDict objectForKey:@"thrombo"];
    self.neutroText.text = [tempDict objectForKey:@"neutro"];
    self.crpText.text = [tempDict objectForKey:@"crp"];
    self.natriumText.text = [tempDict objectForKey:@"natrium"];
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

-(void)checkDate{
    //Check if there is a sample on this day
    //if sample - Show it make it editable
    if([self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:self.weekSelector.selectedDate]] != nil){
        [self showBloodSampleUI:self.weekSelector.selectedDate];
    }
    //if no sample - Make it possible to add a sample
    else{
        [self noBloodSampleUI];
    }
}

-(void)initMedicineView{
    NSLog(@"Count: %d",self.dataManagement.medicineData.count);
    if (self.dataManagement.medicineData.count == 0) {
        self.mtxText.enabled = YES;
        self.m6Text.enabled = YES;
        self.saveDose.hidden = NO;
    }
    else{
        self.editDose.hidden = NO;
        self.mtxText.text = [self.dataManagement.medicineData objectForKey:@"mtx"];
        self.m6Text.text = [self.dataManagement.medicineData objectForKey:@"m6"];
    }
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
    else if ([self.natriumText isFirstResponder] && [touch view] != self.natriumText) {
        [self.natriumText resignFirstResponder];
    }
    else if ([self.mtxText isFirstResponder] && [touch view] != self.mtxText) {
        [self.mtxText resignFirstResponder];
    }
    else if ([self.m6Text isFirstResponder] && [touch view] != self.m6Text) {
        [self.m6Text resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"selectKemo"]){
        RTSelectKemoTableViewController *controller = [segue destinationViewController];
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
        controller.delegate = self;
    }
}

-(void)didSelectedRowInPopover:(NSString *)kemoType{
    NSString *labelText = @"Høj-dosis kemo behandling i dag: ";
    [self.popover dismissPopoverAnimated:YES];
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:kemoType];
    self.highDoseKemoButton.titleLabel.text = @"Edit high-dose kemo";
}

@end
