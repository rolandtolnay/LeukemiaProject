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

-(RLMResults *)painDataOnDate:(NSDate *) date{
    return [RTPainData objectsWhere:@"date > %@ && date < %@",[self setTimeOnDate:date :0 :0 :0],[self setTimeOnDate:date :23 :59 :59]];
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
