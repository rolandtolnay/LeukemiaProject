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

//@property NSArray *sortedBloodSampleDates; Gl. property
@property RLMResults *sortedBloodSampleDates;
//@property NSMutableDictionary *selectedBloodSample; Gl. property
@property RTBloodSample *selectedBloodSample;
@end

@implementation RTMedicineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.mtxText.delegate = self;
    self.m6Text.delegate = self;
    
    self.dataManagement = [RTDataManagement singleton];
    self.realmService = [RTRealmService singleton]; 
    
    self.medicineView.layer.borderWidth = 1.0;
    self.medicineView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self initMedicineView];
}

-(void)initMedicineView{
    if ([[RTKemoTreatment allObjects]count] == 0) {
        self.mtxText.enabled = YES;
        self.m6Text.enabled = YES;
        self.addHighDoseKemo.hidden = NO;
        self.saveDose.hidden = NO;
    }
    else{
        //Index of the latest entry - this is current kemo treatment
        int index = (int)[[RTKemoTreatment allObjects]count] - 1;
        RTKemoTreatment *currentKemoTreatment = [[RTKemoTreatment  allObjects]objectAtIndex:index];
        self.editDose.hidden = NO;
        self.mtxText.text = [@(currentKemoTreatment.mtx) stringValue];
        self.m6Text.text = [@(currentKemoTreatment.mercaptopurin) stringValue];
        NSString *labelText = NSLocalizedString(@"High-dose kemo treatment today: ", nil);
        self.highDoseKemoLabel.text = [labelText stringByAppendingString:currentKemoTreatment.kemoTreatmentType];
        self.addHighDoseKemo.hidden = YES;
        self.editHighDoseKemo.hidden = NO;
    }
    self.selectedBloodSample = nil;
    //[self sortBloodSampleDates];
    self.sortedBloodSampleDates = [self.realmService daysWithBloodSamplesSorted];
}

#pragma mark - Convenience methods

/**
 * Returns a dictionary with all bloodsample dictionaries, where the key is the blood-sample date.
 */
//-(NSMutableDictionary*)bloodSampleDictionary{
//    
//    NSMutableDictionary *daysWithBloodsamples = [[NSMutableDictionary alloc]init];
//    NSDate *tempDate;
//    NSString *dateString;
//    
//    for(NSMutableDictionary *tempDict in self.dataManagement.medicineData)
//    {
//        NSMutableDictionary *bloodSampleDic = [tempDict objectForKey:@"bloodSample"];
//        if(bloodSampleDic != nil)
//        {
//            
//            NSString *tempString = [tempDict objectForKey:@"date"];
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//            tempDate = [dateFormatter dateFromString:tempString];
//            
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            dateString = [dateFormatter stringFromDate:tempDate];
//            
//            [daysWithBloodsamples setObject:bloodSampleDic forKey:dateString];
//        }
//    }
//    return daysWithBloodsamples;
//}

//Returns an array with blood sample values for a given date
//-(NSArray *)bloodSampleForDay:(NSDate*) date
//{
//    NSMutableArray *bloodSample = [[NSMutableArray alloc] init];
//    NSMutableDictionary *medicineRegistration = [[self.dataManagement medicineDataAtDate:date] objectForKey:@"bloodSample"];
//    [bloodSample addObject:[medicineRegistration objectForKey:@"hemoglobin"]];
//    [bloodSample addObject:[medicineRegistration objectForKey:@"thrombocytes"]];
//    [bloodSample addObject:[medicineRegistration objectForKey:@"leukocytes"]];
//    [bloodSample addObject:[medicineRegistration objectForKey:@"neutrofile"]];
//    [bloodSample addObject:[medicineRegistration objectForKey:@"crp"]];
//    [bloodSample addObject:[medicineRegistration objectForKey:@"alat"]];
//    
//    return [bloodSample copy];
//}

-(NSArray *)kemoForDay:(NSDate*) date
{
    NSMutableArray *kemo = [[NSMutableArray alloc]init];
    RTMedicineData *medicineRegistration = [self.realmService medicineDataAtDate:date];
    
    [kemo addObject:[NSNumber numberWithInteger:medicineRegistration.mtx]];
    [kemo addObject:[NSNumber numberWithInteger:medicineRegistration.mercaptopurin]];
    
    return [kemo copy];
}

//-(void) sortBloodSampleDates
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSMutableArray *datesWithBloodSamples = [[self bloodSampleDictionary].allKeys mutableCopy];
//    for (int i =0; i < datesWithBloodSamples.count; i++)
//    {
//        NSDate *bloodSampleDate = [dateFormatter dateFromString:datesWithBloodSamples[i]];
//        datesWithBloodSamples[i] = bloodSampleDate;
//    }
//    [datesWithBloodSamples sortUsingSelector:@selector(compare:)];
//    
//    self.sortedBloodSampleDates = [datesWithBloodSamples copy];
//}

#pragma mark - Doses

- (IBAction)saveDose:(id)sender {
    //NSMutableDictionary *kemoTreatment = [self.dataManagement kemoTreatmentForDay:[NSDate date]]; Gl. parameter
    RTKemoTreatment *kemoTreatment = [self.realmService kemoTreatmentForDay:[NSDate date]];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (kemoTreatment == nil) {
        kemoTreatment = [[RTKemoTreatment alloc]init];
        //[kemoTreatment setObject:@"" forKey:@"kemoTreatment"];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        [kemoTreatment setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        kemoTreatment.date = [[NSDate date] dateWithoutTime];
        kemoTreatment.mtx = [self.mtxText.text integerValue];
        kemoTreatment.mercaptopurin = [self.m6Text.text integerValue];
        //[self.dataManagement.kemoTreatmentArray addObject:kemoTreatment];
        [realm beginWriteTransaction];
        [realm addObject:kemoTreatment];
        [realm commitWriteTransaction];
    }
    else{
//        [kemoTreatment setObject:[NSNumber numberWithInt:[self.mtxText.text intValue]] forKey:@"mtx"];
//        [kemoTreatment setObject:[NSNumber numberWithInt:[self.m6Text.text intValue]] forKey:@"mercaptopurin"];
        kemoTreatment.mtx = [self.mtxText.text integerValue];
        kemoTreatment.mercaptopurin = [self.m6Text.text integerValue];
        [realm beginWriteTransaction];
        [RTKemoTreatment createOrUpdateInRealm:realm withObject:kemoTreatment];
        [realm commitWriteTransaction];
    }
    
    //NSMutableDictionary *medicineRegistration = [self.dataManagement medicineDataAtDate:[NSDate date]];
    RTMedicineData *medicineRegistration = [self.realmService medicineDataAtDate:[NSDate date]];
    if (medicineRegistration !=nil)
    {
        //[medicineRegistration setObject:[NSNumber numberWithInt:[self.mtxText.text intValue]] forKey:@"mtx"];
        //[medicineRegistration setObject:[NSNumber numberWithInt:[self.m6Text.text intValue]] forKey:@"mercaptopurin"];
        kemoTreatment.mtx = [self.mtxText.text integerValue];
        kemoTreatment.mercaptopurin = [self.m6Text.text integerValue];
        [realm beginWriteTransaction];
        [RTMedicineData createOrUpdateInRealm:realm withObject:medicineRegistration];
        [realm commitWriteTransaction];
    }
    
    self.mtxText.enabled = NO;
    self.m6Text.enabled = NO;
    self.saveDose.hidden = YES;
    self.editDose.hidden = NO;
    //[self.dataManagement writeToPList];
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
//    int index = (int)self.dataManagement.kemoTreatmentArray.count - 1;
    int index = (int)[RTKemoTreatment allObjects].count - 1;
    //NSString *kemoType = [self.dataManagement.kemoTreatmentArray[index] objectForKey:@"kemoTreatment"];
    NSString *kemoType = [[[RTKemoTreatment allObjects]objectAtIndex:index]kemoTreatmentType];
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
    if([segue.identifier isEqualToString:@"showBloodSampleSegue"]) {
        
        RTAddBloodSampleViewController *controller = [segue destinationViewController];
        controller.selectedBloodSample = self.selectedBloodSample;
    }
}

- (IBAction)unwindToMedicine:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if ([sourceViewController isKindOfClass:[RTAddBloodSampleViewController class]])
    {
        [sourceViewController dismissViewControllerAnimated:YES completion:nil];
        
        self.selectedBloodSample = nil;
        //[self sortBloodSampleDates];
        self.sortedBloodSampleDates = [self.realmService daysWithBloodSamplesSorted];
        [self.collectionBloodSamples reloadData];
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
    
    //NSMutableDictionary *kemoTreatment = [self.dataManagement kemoTreatmentForDay:[NSDate date]];
    RTKemoTreatment *kemoTreatment = [self.realmService kemoTreatmentForDay:[NSDate date]];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (kemoTreatment == nil) {
        //kemoTreatment = [[NSMutableDictionary alloc] init];
        kemoTreatment = [[RTKemoTreatment alloc]init];
        //[kemoTreatment setObject:[NSNumber numberWithInt:0] forKey:@"mtx"];
        //[kemoTreatment setObject:[NSNumber numberWithInt:0] forKey:@"mercaptopurin"];
        kemoTreatment.mtx = 0;
        kemoTreatment.mercaptopurin = 0;
        kemoTreatment.date = [[NSDate date] dateWithoutTime];
        kemoTreatment.kemoTreatmentType = kemoType;
        [realm beginWriteTransaction];
        [realm addObject:kemoTreatment];
        [realm commitWriteTransaction];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        [kemoTreatment setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
//        [self.dataManagement.kemoTreatmentArray addObject:kemoTreatment];
    }
    
    //NSMutableDictionary *medicineRegistration = [self.dataManagement medicineDataAtDate:[NSDate date]];
    RTMedicineData *medicineRegistration = [self.realmService medicineDataAtDate:[NSDate date]];
    if (medicineRegistration !=nil)
    {
        //[medicineRegistration setObject:kemoType forKey:@"kemoTreatment"];
        medicineRegistration.kemoTreatment = kemoType;
        [realm beginWriteTransaction];
        [RTMedicineData createOrUpdateInRealm:realm withObject:medicineRegistration];
        [realm commitWriteTransaction];
    }
    
    //[kemoTreatment setObject:kemoType forKey:@"kemoTreatment"];
    
    //[self.dataManagement writeToPList];
}

#pragma mark - CollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self bloodSampleDictionary].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTBloodSampleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bloodSampleCell" forIndexPath:indexPath];
    
    NSDate *cellDate = self.sortedBloodSampleDates[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM"];
    cell.lblDate.text = [dateFormatter stringFromDate:cellDate];
    
    NSArray *bloodSample = [self bloodSampleForDay:cellDate];
    for (UILabel *lbl in cell.bloodSampleLabels)
    {
        [lbl setText:[NSString stringWithFormat:@"%@",bloodSample[lbl.tag]]];
    }
    
     NSArray *kemo = [self kemoForDay:cellDate];
    [cell.lblMTX setText:[NSString stringWithFormat:@"%@",kemo[0]]];
    [cell.lbl6MP setText:[NSString stringWithFormat:@"%@",kemo[1]]];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *cellDate = self.sortedBloodSampleDates[indexPath.row];
    self.selectedBloodSample = [[self.dataManagement medicineDataAtDate:cellDate] objectForKey:@"bloodSample"];
    [self.selectedBloodSample setObject:cellDate forKey:@"date"];
    [self performSegueWithIdentifier:@"showBloodSampleSegue" sender:self];
}

@end
