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
    
    [self datesWithBloodSamples];

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

-(NSArray *)bloodSampleForDay:(NSDate*) date
{
    NSMutableArray *bloodSample = [[NSMutableArray alloc] init];
    NSMutableDictionary *bloodSampleRegistration = [self.dataManagement.bloodSampleData objectForKey:[self.dateFormatter stringFromDate:date]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"hemo"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"thrombo"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"neutro"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"crp"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"leukocytter"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"alat"]];
    [bloodSample addObject:[bloodSampleRegistration objectForKey:@"other"]];
    
    return [bloodSample copy];
}

-(NSArray*)datesWithBloodSamples
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    
    //Number of past entries to look for in dictionary
    NSUInteger entries = 6;
    if ([self.dataManagement.bloodSampleData count]<6) entries = [self.dataManagement.bloodSampleData count];
    NSLog(@"Entries to look for: %lu",(unsigned long)entries);
    NSLog(@"Dictionary with blood samples: %@",self.dataManagement.bloodSampleData);
    
    //the while loop starts by decrementing the current date by 1 day each iteration and checks for a key value in the
    //blood sample dictionary for that date. If it finds one, increases the number of found items, and adds the date to the array.
    //the loop runs until it finds the number of entries it that match the previous requirement (default 6).
    NSUInteger found = 0;
    NSDate *dateToSearch = [NSDate date];
    while (found<entries) {
        
        NSString *keyToSearch = [self.dateFormatter stringFromDate:[dateToSearch offsetDay:-1]];
        NSLog(@"keyToSearch: %@",keyToSearch);
        if ([self.dataManagement.bloodSampleData objectForKey:keyToSearch]!=nil)
        {
            found++;
            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
        }
    };
    NSLog(@"Dates with bloodsamples: %@",dates);
    
    return [dates copy];
}

@end
