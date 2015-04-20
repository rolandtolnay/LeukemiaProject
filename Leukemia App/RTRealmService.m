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

#pragma mark - Retrieve pain data methods
//Gets paindata on the given date
-(RLMResults *)painDataOnDate:(NSDate *) date{
    return [RTPainData objectsWhere:@"date >= %@ && date =< %@",[self setTimeOnDate:date :0 :0 :0],[self setTimeOnDate:date :23 :59 :59]];
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
