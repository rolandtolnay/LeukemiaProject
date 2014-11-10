//
//  RTService.m
//  Leukemia App
//
//  Created by dmu-23 on 10/11/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTService.h"

@implementation RTService

static RTService *service = nil;

//Singleton method

+ (RTService *)singleton {
    @synchronized(self) {
        if (service == nil)
        {
            service = [[self alloc] init];
        }
    }
    
    return service;
}

//DEPRECATED, kept for possible later use
//-(NSArray*) commonHoursForPainTypeMouth:(NSArray*) mouthPain TypeStomach:(NSArray*) stomachPain TypeOther:(NSArray*) otherPain
//{
//    NSMutableArray *commonHours = [[NSMutableArray alloc]init];
//    
//    int index = 0;
//    while ([mouthPain count] > index || [stomachPain count] > index || [otherPain count] > index) {
//        
//        NSString *addedTitle;
//        NSString *mouthPainHours, *stomachPainHours, *otherPainHours;
//        if ([mouthPain count] > index)
//            mouthPainHours = [NSString stringWithFormat:@"%@ (M)",[mouthPain[index] componentsSeparatedByString:@":"][0]];
//        if ([stomachPain count] > index)
//            stomachPainHours = [NSString stringWithFormat:@"%@ (S)",[stomachPain[index] componentsSeparatedByString:@":"][0]];
//        if ([otherPain count] > index)
//            otherPainHours = [NSString stringWithFormat:@"%@ (O)",[otherPain[index] componentsSeparatedByString:@":"][0]];
//        
//        addedTitle = [NSString stringWithFormat:@"%@/%@/%@",mouthPainHours,stomachPainHours,otherPainHours];
//        [commonHours addObject:addedTitle];
//        index++;
//    };
//    
//    return [commonHours copy];
//}

#pragma mark - Date convenience methods

-(BOOL)isDate:(NSDate*) start earlierThanDate:(NSDate*) toCompare
{
    NSComparisonResult result = [start compare:toCompare];
    return (result == NSOrderedAscending || result == NSOrderedSame);
}

//Returns an array of NSDate objects for each day in a week for a given year
-(NSArray*)allDatesInWeek:(long)weekNumber forYear:(int)year{
    // determine weekday of first day of year:
    NSCalendar *greg = [[NSCalendar alloc]
                        initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [greg dateByAddingComponents:comps toDate:today options:0];
    const NSTimeInterval kDay = [tomorrow timeIntervalSinceDate:today];
    
    comps.year = year;
    today = [greg dateFromComponents:comps];
    comps = [greg components:NSYearCalendarUnit fromDate:today];
    NSLog(@"%@",comps);
    comps.day = 1;
    comps.month = 1;
    comps.hour = 12;
    NSDate *start = [greg dateFromComponents:comps];
    NSLog(@"NSDate start: %@",start);
    comps = [greg components:NSWeekdayCalendarUnit fromDate:start];
    
    
    if (weekNumber==1) {
        start = [start dateByAddingTimeInterval:-kDay*(comps.weekday-1)];
    } else {
        start = [start dateByAddingTimeInterval:
                 kDay*(8-comps.weekday+7*(weekNumber-2))];
    }
    NSMutableArray *result = [NSMutableArray array];
    //Loop makes it start from monday instead of sunday by adding one extra day (i=1)
    for (int i = 1; i<8; i++) {
        [result addObject:[start dateByAddingTimeInterval:kDay*i]];
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - Reading and Writing images

-(void) UIImageWriteToFile:(UIImage *)image :(NSString *)fileName
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = dirPaths[0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
}

-(void) UIImageReadFromFile:(UIImage **)image :(NSString *)fileName
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = dirPaths[0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:fileName];
    
    *image = [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - ID generators

-(NSString*)UniqueAppId
{
    NSString *Appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *strApplicationUUID = [SSKeychain passwordForService:Appname account:@"manab"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:Appname account:@"manab"];
    }
    return strApplicationUUID;
}

-(NSString*)dataID
{
    NSString *dataID = [[NSString alloc] initWithFormat:@"%@ %@",[self UniqueAppId],[NSDate date]];
    return dataID;
}

@end
