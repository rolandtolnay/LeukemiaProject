//
//  RTRealmService.m
//  Leukemia App
//
//  Created by Nicolai Duus on 20/03/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import "RTRealmService.h"

@implementation RTRealmService

static RTRealmService *realmService = nil;

//Singleton method
+ (RTRealmService *)singleton {
    @synchronized(self) {
        if (realmService == nil)
        {
            realmService = [[self alloc] init];
        }
    }
    
    return realmService;
}

#pragma mark - Retrieve medicinedata methods
//Get medicinedata at the given date
-(RTMedicineData *) medicineDataAtDate:(NSDate*) date
{
    RTMedicineData *dataToReturn;
    RLMResults *results = [RTMedicineData objectsWhere:@"date >= %@ && date =< %@",[self setTimeOnDate:date :0 :0 :0],[self setTimeOnDate:date :23 :59 :59]];
    if (results.count==1) {
        dataToReturn = [results objectAtIndex:0];
    }
    return  dataToReturn;
}

-(RTMedicineData *)newMedicineData:(NSDate*)date{
    
    RTMedicineData *dataToBeSaved = [[RTMedicineData alloc]init];
    
    //ID and Date information
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    //[dataToBeSaved setObject:[dateFormatter stringFromDate:date] forKey:@"date"];
    //[dataToBeSaved setObject:[[RTService singleton] dataID] forKey:@"id"];
    dataToBeSaved.date = date;
    dataToBeSaved.dataId = [[RTService singleton]dataID];
    
    //Kemo-data
    //NSMutableDictionary *kemoTreatmentDictionary = [self relevantKemoTreatmentForDay:date];
    RTKemoTreatment *kemoTreatment = [self relevantKemoTreatmentForDay:date];
    
//    if (kemoTreatmentDictionary != nil)
    if (kemoTreatment != nil)

    {
//        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"mtx"] forKey:@"mtx"];
//        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"mercaptopurin"] forKey:@"mercaptopurin"];
//        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"kemoTreatment"] forKey:@"kemoTreatment"];
        dataToBeSaved.mtx = kemoTreatment.mtx;
        dataToBeSaved.mercaptopurin = kemoTreatment.mercaptopurin;
        dataToBeSaved.kemoTreatment = kemoTreatment.kemoTreatmentType;
    } else {
//        [dataToBeSaved setObject:[NSNumber numberWithInt:0] forKey:@"mtx"];
//        [dataToBeSaved setObject:[NSNumber numberWithInt:0] forKey:@"mercaptopurin"];
//        [dataToBeSaved setObject:@"" forKey:@"kemoTreatment"];
        dataToBeSaved.mtx = 0;
        dataToBeSaved.mercaptopurin = 0;
        dataToBeSaved.kemoTreatment = @"";
    }
    
    //BloodSample Data
//    NSMutableDictionary *bloodSampleData = [[NSMutableDictionary alloc] init];
//    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"hemoglobin"];
//    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"thrombocytes"];
//    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"leukocytes"];
//    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"neutrofile"];
//    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"crp"];
//    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"alat"];
//    [dataToBeSaved setObject:bloodSampleData forKey:@"bloodSample"];
    
    RTBloodSample *bloodSampleData = [[RTBloodSample alloc] init];
    bloodSampleData.hemoglobin = 0.0;
    bloodSampleData.thrombocytes = 0;
    bloodSampleData.leukocytes = 0.0;
    bloodSampleData.neutroFile = 0;
    bloodSampleData.crp = 0;
    bloodSampleData.alat = 0;
    //[dataToBeSaved setObject:bloodSampleData forKey:@"bloodSample"];
    dataToBeSaved.bloodSample = bloodSampleData;
    
    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm beginWriteTransaction];
    [realm addObject:dataToBeSaved];
    [realm commitWriteTransaction];
    //[self.medicineData addObject:dataToBeSaved];
    return dataToBeSaved;
}

//Returns the kemoTreatment that is in progress for a given day
-(RTKemoTreatment *) relevantKemoTreatmentForDay: (NSDate*) date
{
    RTKemoTreatment *kemoTreatment = [[RTKemoTreatment alloc]init];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    RTService *service = [RTService singleton];
    
    //a check to see if there was any treatment on a previous date than the current one
    BOOL isKemo = NO;
    
    //if (self.kemoTreatmentArray.count>0)
    if([RTKemoTreatment allObjects].count>0)
    {
//        NSDate *closestDate = [dateFormatter dateFromString:[self.kemoTreatmentArray[0] objectForKey:@"date"]];
        NSDate *closestDate = [[[RTKemoTreatment allObjects] firstObject]date];

//        for (NSMutableDictionary *kemoTreatmentRegistration in self.kemoTreatmentArray)
//        {
//            NSString *kemoTreatmentDateString = [kemoTreatmentRegistration objectForKey:@"date"];
//            NSDate *kemoTreatmentDate = [dateFormatter dateFromString:kemoTreatmentDateString];
//            
//            if ([service isDate:closestDate earlierThanDate:kemoTreatmentDate] && [service isDate:kemoTreatmentDate earlierThanDate:date])
//            {
//                closestDate = kemoTreatmentDate;
//                kemoTreatment = kemoTreatmentRegistration;
//                isKemo = YES;
//            }
//        }
        for (RTKemoTreatment *kemoTreatmentRegistration in [RTKemoTreatment allObjects])
        {
            //NSString *kemoTreatmentDateString = [kemoTreatmentRegistration objectForKey:@"date"];
            NSDate *kemoTreatmentDate = kemoTreatmentRegistration.date;
            
            if ([service isDate:closestDate earlierThanDate:kemoTreatmentDate] && [service isDate:kemoTreatmentDate earlierThanDate:date])
            {
                closestDate = kemoTreatmentDate;
                kemoTreatment = kemoTreatmentRegistration;
                isKemo = YES;
            }
        }

        
        if (!isKemo){
            return nil;
        }
        
    } else {
        
        return nil;
    }
    
    return kemoTreatment;
}

#pragma mark - Retrieve bloodsample methods
-(RTBloodSample *)bloodSampleForDate:(NSDate *) date
{
    return [self medicineDataAtDate:date].bloodSample;
}

/**
 * Returns a dictionary with all bloodsample dictionaries, where the key is the blood-sample date.
 */
-(RLMResults*)daysWithBloodSamplesSorted{
    return [[RTBloodSample allObjects]sortedResultsUsingProperty:@"date" ascending:YES];
}

-(NSArray *) datesWithBloodSamplesFromDate:(NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"-MM-"];
    //NSString *thisMonth = [dateFormatter stringFromDate:currentDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    
    [nowComponents setDay:1];
    
    NSDate *beginningOfCurrentMonth = [calendar dateFromComponents:nowComponents];
    
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    
    [oneMonth setMonth:1];
    
    NSDate *beginningOfNextMonth = [calendar dateByAddingComponents:oneMonth toDate:beginningOfCurrentMonth options:0];
    RLMResults *datesWithBloodsamplesInMonth = [RTBloodSample objectsWhere:@"date >= %@ && date < %@",beginningOfCurrentMonth,beginningOfNextMonth];
    
    if(datesWithBloodsamplesInMonth != nil){
    for (RTBloodSample *bloodSample in datesWithBloodsamplesInMonth)
    {
//        NSDictionary *bloodSamples = [medicineRegistration objectForKey:@"bloodSample"];
//        if (bloodSamples != nil)
//        {
//            NSString *timeStamp = [medicineRegistration objectForKey:@"date"];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//            if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
//            {
//                NSDate *timeStampDate = [dateFormatter dateFromString:timeStamp];
//                NSNumber *dateToBeAdded = [NSNumber numberWithInt:[timeStampDate day]];
//                [dates addObject:dateToBeAdded];
//            }
//        }
         NSNumber *dateToBeAdded = [NSNumber numberWithInt:[bloodSample.date day]];
        [dates addObject:dateToBeAdded];
    }
    }
    
    return [dates copy];
}

#pragma mark - Retrieve pain data methods
//Gets paindata on the given date
-(RLMResults *)painDataOnDate:(NSDate *) date{
    return [RTPainData objectsWhere:@"date >= %@ && date =< %@",[self setTimeOnDate:date :0 :0 :0],[self setTimeOnDate:date :23 :59 :59]];
}

#pragma mark - Retrieve kemo data methods
//-(NSArray *)kemoForDate:(NSDate*) date
//{
//    NSMutableArray *kemo = [[NSMutableArray alloc]init];
//    RTMedicineData *medicineRegistration = [self medicineDataAtDate:date];
//
//    [kemo addObject:[NSNumber numberWithInteger:medicineRegistration.mtx]];
//    [kemo addObject:[NSNumber numberWithInteger:medicineRegistration.mercaptopurin]];
//
//    return [kemo copy];
//}

//Returns the kemoTreatment for a given day
-(RTKemoTreatment *) kemoTreatmentForDay: (NSDate*)date
{
    RTKemoTreatment *kemoTreatment;
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([RTKemoTreatment allObjects].count>0)
    {
        kemoTreatment = [[RTKemoTreatment objectsWhere:@"date >= %@ && date =< %@",[self setTimeOnDate:date :0 :0 :0],[self setTimeOnDate:date :23 :59 :59]]objectAtIndex:0];
        
    } else
    {
        return nil;
    }
    
    return kemoTreatment;
}

#pragma mark - Retrieve diary data methods
//Gets diarydata on the given date
-(RTDiaryData *)diaryDataOnDate:(NSDate *) date{
    RTDiaryData *dataToReturn;
    RLMResults *results = [RTDiaryData objectsWhere:@"date >= %@ && date =< %@",[self setTimeOnDate:date :0 :0 :0],[self setTimeOnDate:date :23 :59 :59]];
    if (results.count==1) {
        dataToReturn = [results objectAtIndex:0];
    }
    
    return  dataToReturn;
}

//Used for marking dates in the calendar
-(NSArray*) datesToBeMarkedInMonthFromDate: (NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    
    [nowComponents setDay:1];
    
    NSDate *beginningOfCurrentMonth = [calendar dateFromComponents:nowComponents];
    
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    
    [oneMonth setMonth:1];
    
    NSDate *beginningOfNextMonth = [calendar dateByAddingComponents:oneMonth toDate:beginningOfCurrentMonth options:0];
    
    RLMResults *datesWithPainDataInMonth = [RTPainData objectsWhere:@"date >= %@ && date < %@",beginningOfCurrentMonth,beginningOfNextMonth];
    
    for (RTPainData *painData in datesWithPainDataInMonth)
    {
        NSDate *dateToBeAdded = painData.date;
        
        //check for duplicates
            if ([dates count] < 1 || !([dates[dates.count-1]day]==dateToBeAdded.day))
                [dates addObject:dateToBeAdded];
    }
    return [dates copy];
}

#pragma mark - Dates helper method
-(NSDate *)setTimeOnDate:(NSDate *) date :(NSInteger) hour :(NSInteger) minute :(NSInteger) second{
    //gather current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    //set date components
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    
    //return date relative from date
    return [calendar dateFromComponents:dateComponents];
}
@end
