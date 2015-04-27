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
