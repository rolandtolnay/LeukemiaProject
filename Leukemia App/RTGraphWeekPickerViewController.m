//
//  RTGraphWeekPickerViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 23/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphWeekPickerViewController.h"

@interface RTGraphWeekPickerViewController ()
 
@end

@implementation RTGraphWeekPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weeks = [[NSMutableArray alloc] init];
    for (int i=1; i < 54; i++) {
        NSString *week = [NSString stringWithFormat:@"Week %d",i];
        [self.weeks addObject:week];
    }
    
    self.years = @[@"2014",@"2015",@"2016",@"2017",@"2018"];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 5;
    };
    return 53;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
        return self.years[row];
    return self.weeks[row];
}


@end
