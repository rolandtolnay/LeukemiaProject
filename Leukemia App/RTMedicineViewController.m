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
@property RTService *service;

@end

@implementation RTMedicineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.mtxText.delegate = self;
    self.m6Text.delegate = self;
    
    self.dataManagement = [RTDataManagement singleton];
    
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
        NSMutableDictionary *currentKemoTreatment = self.dataManagement.kemoTreatmentArray[index];
        
        self.editDose.hidden = NO;
        self.mtxText.text = [[currentKemoTreatment objectForKey:@"mtx"] stringValue];
        self.m6Text.text = [[currentKemoTreatment  objectForKey:@"mercaptopurin"] stringValue];
        NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
        self.highDoseKemoLabel.text = [labelText stringByAppendingString:[currentKemoTreatment objectForKey:@"kemoTreatment"]];
        self.addHighDoseKemo.hidden = YES;
        self.editHighDoseKemo.hidden = NO;
    }
}

#pragma mark - Convenience methods

//-(NSInteger)bloodSampleCountBeforeDate: (NSDate*) date{
//    NSInteger count = 0;
//    
//    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
//        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//        NSDate *regDate = [self.dateFormatter dateFromString:[tempDict objectForKey:@"date"]];
//        if ([self.service isDate:regDate earlierThanDate:date])
//        {
//            if([tempDict objectForKey:@"bloodSample"] != nil){
//                count++;
//            }
//        }
//    }
//    return count;
//}

/**
 * Returns a dictionary with all bloodsample dictionaries, where the key is the blood-sample date.
 */
-(NSMutableDictionary*)bloodSampleDictionary{
    
    NSMutableDictionary *daysWithBloodsamples = [[NSMutableDictionary alloc]init];
    NSDate *tempDate;
    NSString *dateString;
    
    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData){
        NSMutableDictionary *bloodSampleDic = [tempDict objectForKey:@"bloodSample"];
        if( bloodSampleDic != nil){
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            tempDate = [self.dateFormatter dateFromString:[tempDict objectForKey:@"date"]];
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateString = [self.dateFormatter stringFromDate:tempDate];
            
            [daysWithBloodsamples setObject:bloodSampleDic forKey:dateString];
        }
    }
    return daysWithBloodsamples;
}

////Returns an array of dates that have blood samples
//-(NSArray*)datesWithBloodSamples
//{
//    NSMutableArray *dates = [[NSMutableArray alloc]init];
//    
//    //the while loop starts by decrementing the current date by 1 day each iteration and checks for a key value in the
//    //blood sample dictionary for that date. If it finds one, increases the number of found items, and adds the date to the array.
//    //the loop runs until it finds the number of entries it that match the previous requirement (default 6).
//    NSUInteger found = 0;
//    NSDate *dateToSearch = [self.selectedDate offsetDay:1];
//    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSMutableDictionary *bloodSampleDictionary = [self bloodSampleDictionary];
//    while (found < entries) {
//        dateToSearch = [dateToSearch offsetDay:-1];
//        NSString *keyToSearch = [self.dateFormatter stringFromDate:dateToSearch];
//        
//        if ([bloodSampleDictionary objectForKey:keyToSearch]!=nil)
//        {
//            found++;
//            [dates addObject:[self.dateFormatter dateFromString:keyToSearch]];
//        }
//        
//    };
//    
//    return [dates copy];
//}

//Returns an array with blood sample values for a given date
-(NSArray *)bloodSampleForDay:(NSDate*) date
{
    NSMutableArray *bloodSample = [[NSMutableArray alloc] init];
    NSMutableDictionary *medicineRegistration = [[self.dataManagement medicineDataAtDate:date] objectForKey:@"bloodSample"];
    [bloodSample addObject:[medicineRegistration objectForKey:@"hemoglobin"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"thrombocytes"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"neutrofile"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"crp"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"leukocytes"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"alat"]];
    [bloodSample addObject:[medicineRegistration objectForKey:@"other"]];
    
    return [bloodSample copy];
}

-(NSArray *)kemoForDay:(NSDate*) date
{
    NSMutableArray *kemo = [[NSMutableArray alloc]init];
    NSMutableDictionary *medicineRegistration = [self.dataManagement medicineDataAtDate:date];
    
    [kemo addObject:[medicineRegistration objectForKey:@"mtx"]];
    [kemo addObject:[medicineRegistration objectForKey:@"mercaptopurin"]];
    
    return [kemo copy];
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
    [kemoTreatment setObject:[NSNumber numberWithInt:[self.m6Text.text intValue]] forKey:@"mercaptopurin"];
    
    NSMutableDictionary *medicineRegistration = [self.dataManagement medicineDataAtDate:[NSDate date]];
    if (medicineRegistration !=nil)
    {
        [medicineRegistration setObject:[NSNumber numberWithInt:[self.mtxText.text intValue]] forKey:@"mtx"];
        [medicineRegistration setObject:[NSNumber numberWithInt:[self.m6Text.text intValue]] forKey:@"mercaptopurin"];
    }
        
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

-(void)showKemoUI{
    NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
    int index = (int)self.dataManagement.kemoTreatmentArray.count - 1;
    NSString *kemoType = [self.dataManagement.kemoTreatmentArray[index] objectForKey:@"kemoTreatment"];
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:kemoType];
    self.addHighDoseKemo.hidden = YES;
    self.editHighDoseKemo.hidden = NO;
}

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

- (IBAction)unwindToMedicine:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if ([sourceViewController isKindOfClass:[RTAddBloodSampleViewController class]])
    {
        [sourceViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma  mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - RTSelectKemo delegate

-(void)didSelectKemo:(NSString *)kemoType{
    NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
    
    [self.kemoPopover dismissPopoverAnimated:YES];
    self.highDoseKemoLabel.text = [labelText stringByAppendingString:kemoType];
    
    NSMutableDictionary *kemoTreatment = [self.dataManagement kemoTreatmentForDay:[NSDate date]];
    if (kemoTreatment == nil) {
        kemoTreatment = [[NSMutableDictionary alloc] init];
        [kemoTreatment setObject:[NSNumber numberWithInt:0] forKey:@"mtx"];
        [kemoTreatment setObject:[NSNumber numberWithInt:0] forKey:@"mercaptopurin"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [kemoTreatment setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        [self.dataManagement.kemoTreatmentArray addObject:kemoTreatment];
    }
    
    NSMutableDictionary *medicineRegistration = [self.dataManagement medicineDataAtDate:[NSDate date]];
    if (medicineRegistration !=nil)
    {
        [medicineRegistration setObject:kemoType forKey:@"kemoTreatment"];
    }
    
    [kemoTreatment setObject:kemoType forKey:@"kemoTreatment"];
    
    [self.dataManagement writeToPList];
}

#pragma mark - CollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTBloodSampleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bloodSampleCell" forIndexPath:indexPath];
    
    
    return cell;
    
}

@end
