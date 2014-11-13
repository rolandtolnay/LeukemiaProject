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
        NSString *week = [NSString stringWithFormat:NSLocalizedString(@"Week %d", nil) ,i];
        [self.weeks addObject:week];
    }
    
    self.years = @[@"2014",@"2015",@"2016",@"2017",@"2018"];
    int pickedWeek = [self.pickedDate week];
    NSNumber *pickedYear = [NSNumber numberWithInt:[self.pickedDate year]];
    NSLog(@"yearFromDate: %@",pickedYear);
    NSInteger pickedYearIndex = [self.years indexOfObject:[pickedYear stringValue]];
    NSLog(@"pickedYearIndex: %ld",(long)pickedYearIndex);
    
    [self.weekPicker selectRow:pickedWeek-1 inComponent:1 animated:YES];
    [self.weekPicker selectRow:pickedYearIndex inComponent:0 animated:YES];
    
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.years count];
    };
    return [self.weeks count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
        return self.years[row];
    return self.weeks[row];
}

-(void)showGraph:(id)sender
{
    int year = [self.years[[self.weekPicker selectedRowInComponent:0]] intValue];
    long weekNumber = [self.weekPicker selectedRowInComponent:1]+1;
    [self.delegate weekSelected:[[RTService singleton] allDatesInWeek:weekNumber forYear:year]];
}


@end
