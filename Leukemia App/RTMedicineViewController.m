//
//  RTSecondViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTMedicineViewController.h"

@interface RTMedicineViewController ()

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
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    __weak typeof(self) weakSelf = self;
    self.weekSelector.didChangeSelectedDateBlock = ^(NSDate *selectedDate)
    {
        //Check if there is a sample on this day
        //if sample - Show it make it editable
        if([weakSelf.dataManagement.bloodSampleData objectForKey:[weakSelf.dateFormatter stringFromDate:weakSelf.weekSelector.selectedDate]] != nil){
            [weakSelf showBloodSampleUI:weakSelf.weekSelector.selectedDate];
        }
        //if no sample - Make it possible to add a sample
        else{
            [weakSelf noBloodSampleUI];
        }
    };
    
    [self.weekSelectorView addSubview:self.weekSelector];
    
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

-(void)addBloodSampleUI{
    self.addSampleButton.hidden = YES;
    self.noSampleLabel.text = @"";
    for (UILabel *label in self.bloodSampleLabels) {
        label.hidden = NO;
    }
    for(UITextField *txtField in self.bloodSampleTextFields){
        txtField.hidden = NO;
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
    [super touchesBegan:touches withEvent:event];
}
@end
