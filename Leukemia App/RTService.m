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
    //truncates down hours, minutes and seconds
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    start = [dateFormatter dateFromString:[dateFormatter stringFromDate:start]];
    toCompare = [dateFormatter dateFromString:[dateFormatter stringFromDate:toCompare]];
    
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

#pragma mark - Sending data to webservice

- (void)exportData {
    RTDataManagement *dataManagement = [RTDataManagement singleton];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [self showToastWithMessage:NSLocalizedString(@"An internet connection is needed to export data.", nil)];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } else {
        
        NSError* error;
        NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys: [[dataManagement readFromPlist] objectForKey:@"patientID"],@"patientID",
                                                                                dataManagement.painData, @"painData",
                                                                                dataManagement.medicineData, @"medicineData",
                                                                                dataManagement.diaryData, @"diaryData",
                                                                                nil];
        //convert object to data
        NSData* postData = [NSJSONSerialization dataWithJSONObject:jsonData
                                                           options:kNilOptions error:&error]; //kNilOptions instead of NJSONWritingPrettyPrinted if we want to send the data over the internet
        NSString *urlString = @"http://10.10.133.166:50601/Service1.svc/saveData";
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
        NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
        NSString *dataText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!data)
        {
            // An error occurred while calling the JSON web service.
            NSLog(@"Could not call the web service: %@", urlString);
            [self showToastWithMessage:NSLocalizedString(@"An error (1) occured while trying to connect to the web service.", nil)];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        NSLog(@"%@",dataText);
        NSString *resultString = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding: NSUTF8StringEncoding];
        if(resultString==nil){
            NSLog(@"An exception occured: %@",error.localizedDescription);
            [self showToastWithMessage:NSLocalizedString(@"An error (2) occured while trying to connect to the web service.",nil)];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if(dict==nil){
            NSLog(@"Unable to parse return json into string");
            [self showToastWithMessage:NSLocalizedString(@"An error (3) occured while trying to connect to the web service.",nil)];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        else{
            NSLog(@"WasSuccessful: %d",[[dict valueForKey:@"WasSuccessful"] integerValue]);
            [self showToastWithMessage:NSLocalizedString(@"The data was sent to the web server succesfully!",nil)];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

-(void)showToastWithMessage:(NSString*) message
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [toast show];
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
