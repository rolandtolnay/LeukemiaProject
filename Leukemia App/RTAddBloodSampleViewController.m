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


@end

@implementation RTAddBloodSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataManagement = [RTDataManagement singleton];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];

}

-(void)saveSampleWithDate:(NSDate*) selectedDate
{
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    [dataToBeSaved setObject:self.hemoText.text forKey:@"hemo"];
    [dataToBeSaved setObject:self.thromboText.text forKey:@"thrombo"];
    [dataToBeSaved setObject:self.neutroText.text forKey:@"neutro"];
    [dataToBeSaved setObject:self.crpText.text forKey:@"crp"];
    [dataToBeSaved setObject:self.leukocytterText.text forKey:@"leukocytter"];
    [dataToBeSaved setObject:self.alatText.text forKey:@"alat"];
    [dataToBeSaved setObject:self.otherText.text forKey:@"other"];
    [self.dataManagement.bloodSampleData setObject:dataToBeSaved forKey:[self.dateFormatter stringFromDate:selectedDate]];
    [self.dataManagement writeToPList];
    [self clearTextfields];
}

-(void)clearTextfields {
    for (UITextField *txtField in self.bloodSampleTextFields) {
        [txtField setText:@""];
    }
}

@end
