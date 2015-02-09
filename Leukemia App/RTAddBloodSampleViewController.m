//
//  RTAddBloodSampleViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 14/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTAddBloodSampleViewController.h"

@interface RTAddBloodSampleViewController ()

@property RTDataManagement *dataManagement;

@property NSDateFormatter *dateFormatter;

@property UIPopoverController* popover;

@end

@implementation RTAddBloodSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManagement = [RTDataManagement singleton];
    
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    //[self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.selectedDate = [NSDate date];
    NSDateFormatter *dayShortFormatter = [[NSDateFormatter alloc] init];
    [dayShortFormatter setDateFormat:@"dd/MM"];
    [self.btnDateSelector setTitle:[dayShortFormatter stringFromDate:self.selectedDate] forState:UIControlStateNormal];
    
    [self resetView];
}


-(void)resetView {
    for (UITextField *txf in self.bloodSamples)
    {
        [txf setText:(@"")];
        txf.delegate = self;
        [txf resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    for (UITextField *txf in self.bloodSamples)
    {
        if (textField.tag < 5)
            if (txf.tag == textField.tag + 1)
                [txf becomeFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    for (UITextField *txf in self.bloodSamples)
        if ([txf isFirstResponder] && [touch view] != txf)
            [txf resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Sample CRUD

- (IBAction)addSample:(id)sender {
    NSMutableDictionary *sampleData = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *dataTobeSaved = [self.dataManagement medicineDataAtDate:self.selectedDate];
    
    if(dataTobeSaved == nil){
        dataTobeSaved = [self.dataManagement newMedicineData:self.selectedDate];
    }
    
   for (UITextField *txf in self.bloodSamples)
   {
        NSNumber *bloodSampleValue = [NSNumber numberWithInteger:[txf.text integerValue]];
        switch (txf.tag) {
            case 0:
                [sampleData setObject:bloodSampleValue forKey:@"hemoglobin"];
                break;
            case 1:
                [sampleData setObject:bloodSampleValue forKey:@"thrombocytes"];
                break;
            case 2:
                [sampleData setObject:bloodSampleValue forKey:@"leukocytes"];
                break;
            case 3:
                [sampleData setObject:bloodSampleValue forKey:@"neutrofile"];
                break;
            case 4:
                [sampleData setObject:bloodSampleValue forKey:@"crp"];
                break;
            case 5:
                [sampleData setObject:bloodSampleValue forKey:@"alat"];
                break;
            default:
                break;
        }
    }
    
    [dataTobeSaved setObject:sampleData forKey:@"bloodSample"];
    [self.dataManagement writeToPList];
    [self resetView];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"bloodSampleDatePicker"]){
        RTGraphCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.pickedDate = self.selectedDate;
        controller.markedDates = [self.dataManagement datesWithBloodSamplesFromDate:self.selectedDate];
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
}

#pragma mark - Calendar Picker Delegate

-(void)dateSelected:(NSDate *)date
{
    self.selectedDate = date;
    NSDateFormatter *dayShortFormatter = [[NSDateFormatter alloc] init];
    [dayShortFormatter setDateFormat:@"dd/MM"];
    [self.btnDateSelector setTitle:[dayShortFormatter stringFromDate:self.selectedDate] forState:UIControlStateNormal];
    
    if ([[RTService singleton] isDate:date earlierThanDate:[NSDate date]])
        self.btnAddSample.hidden = NO;
    else self.btnAddSample.hidden = YES;
    
    [self.popover dismissPopoverAnimated:YES];
    [self resetView];
}

-(NSArray *)monthChanged:(NSInteger)month
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthString = [@(month) stringValue];
    NSDate *newDate = [dateFormatter dateFromString:monthString];
    return [self.dataManagement datesWithBloodSamplesFromDate:newDate];
}

@end
