//
//  RTDataManagement.m
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTDataManagement.h"

@implementation RTDataManagement

static RTDataManagement *dataMangement = nil;

-(NSUserDefaults *)prefs{
    if (!_prefs) {
        _prefs = [NSUserDefaults standardUserDefaults];
    }
    return _prefs;
}

-(NSMutableArray *)painData{
    if(!_painData){
        _painData = [[NSMutableArray alloc]init];
    }
    return _painData;
}

-(NSMutableArray *)diaryData{
    if(!_diaryData){
        _diaryData = [[NSMutableArray alloc]init];
    }
    return _diaryData;
}

//Singleton method

+ (RTDataManagement *)singleton {
    @synchronized(self) {
        if (dataMangement == nil)
        {
            dataMangement = [[self alloc] initWithPlistAndUserPreferences];
        }
    }

    return dataMangement;
}

#pragma mark - PList methods

//Initialises RTDataManagement with values from pList

-(id)initWithPlistAndUserPreferences{
    if (self = [super init]){
        self.selectedRowPainScale = [self.prefs integerForKey:@"selectedRowPainScale"];
        self.painScaleBieri = [self.prefs boolForKey:@"painScaleBieri"];
        self.selectedRowNotification = [self.prefs integerForKey:@"selectedRowNotification"];
        self.notificationsOn = [self.prefs boolForKey:@"notificationsOn"];
        [self reloadPlist];
    }
    return self;
}

//Path is the filepath of the pList
-(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"leukemiaApp.plist"];
}

//readFromPlist either reads data from an existing pList, or creates a new dictionary in the path of the pList, the first time data is saved
-(NSMutableDictionary *)readFromPlist{
    NSMutableDictionary *pList;
    if([[NSFileManager defaultManager] fileExistsAtPath:self.path]){
        pList = [[NSMutableDictionary alloc]initWithContentsOfFile:self.path];
    }
    else{
        pList = [[NSMutableDictionary alloc]init];
    }
    return pList;
}

-(void)writeToPList{
    NSMutableDictionary *pList = [self readFromPlist];
    [pList setObject:self.painData forKey:@"painData"];
    [pList setObject:self.diaryData forKey:@"diaryData"];
    [pList writeToFile:self.path atomically:YES];
}

-(void)saveUserPrefrences{
    [self.prefs setInteger:self.selectedRowPainScale forKey:@"selectedRowPainScale"];
    if (self.selectedRowPainScale == 0) {
        self.painScaleBieri = NO;
    }
    else{
        self.painScaleBieri = YES;
    }
    [self.prefs setBool:self.painScaleBieri forKey:@"painScaleBieri"];
    
    [self.prefs setInteger:self.selectedRowNotification forKey:@"selectedRowNotification"];
    if (self.selectedRowNotification == 0) {
        self.notificationsOn = YES;
    }
    else{
        self.notificationsOn = NO;
    }
    [self.prefs setBool:self.notificationsOn forKey:@"notificationsOn"];
    
    [self.prefs synchronize];
}

-(void)reloadPlist{
    NSMutableDictionary *pList = [self readFromPlist];
    self.painData = [pList objectForKey:@"painData"];
    self.diaryData = [pList objectForKey:@"diaryData"];
}

#pragma mark - Service methods

//Methods used for graph data-management

- (NSArray*) painLevelsAtDay:(NSString *) day forPainType:(NSString*) painType{
    NSMutableArray *painLevels = [[NSMutableArray alloc] init];
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *painTypeReg = [painRegistration objectForKey:@"paintype"];
        if ([painTypeReg isEqualToString:painType])
        {
            NSNumber *painLevel = [NSNumber numberWithInt:[[painRegistration objectForKey:@"painlevel"] intValue]];
            NSString *timeStamp = [painRegistration objectForKey:@"time"];
            if ([timeStamp rangeOfString:day].location != NSNotFound)
            {
                [painLevels addObject:painLevel];
            }
        }
    }
    return [painLevels copy];
}

-(NSArray *)timeStampsAtDay:(NSString *) day {
    NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
    
//    NSMutableArray *mouthPain = [[NSMutableArray alloc] init];
//    NSMutableArray *stomachPain = [[NSMutableArray alloc]init];
//    NSMutableArray *otherPain = [[NSMutableArray alloc]init];
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        NSString *hour = [NSString alloc];
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
//            NSString *painType = [painRegistration objectForKey:@"paintype"];
            hour = [timeStamp componentsSeparatedByString:@" "][1];
            
//            if ([painType isEqualToString:MouthPain])
//                [mouthPain addObject:hour];
//            else if ([painType isEqualToString:StomachPain])
//                [stomachPain addObject:hour];
//            else [otherPain addObject:hour];
            
            [timeStamps addObject:hour];
        }
    }
    
//    NSLog(@"Mouthpain times: %@",mouthPain);
//    NSLog(@"Stomachpain times: %@",stomachPain);
//    NSLog(@"Otherpain times: %@",otherPain);
    
//    timeStamps = [self commonHoursForPainTypeMouth:mouthPain TypeStomach:stomachPain TypeOther:otherPain];
    
    return [timeStamps copy];
}

-(NSArray*) commonHoursForPainTypeMouth:(NSArray*) mouthPain TypeStomach:(NSArray*) stomachPain TypeOther:(NSArray*) otherPain
{
    NSMutableArray *commonHours = [[NSMutableArray alloc]init];
    
    int index = 0;
    while ([mouthPain count] > index || [stomachPain count] > index || [otherPain count] > index) {
        
        NSString *addedTitle;
        NSString *mouthPainHours, *stomachPainHours, *otherPainHours;
        if ([mouthPain count] > index)
            mouthPainHours = [NSString stringWithFormat:@"%@ (M)",[mouthPain[index] componentsSeparatedByString:@":"][0]];
        if ([stomachPain count] > index)
            stomachPainHours = [NSString stringWithFormat:@"%@ (S)",[stomachPain[index] componentsSeparatedByString:@":"][0]];
        if ([otherPain count] > index)
            otherPainHours = [NSString stringWithFormat:@"%@ (O)",[otherPain[index] componentsSeparatedByString:@":"][0]];
        
        addedTitle = [NSString stringWithFormat:@"%@/%@/%@",mouthPainHours,stomachPainHours,otherPainHours];
        [commonHours addObject:addedTitle];
        index++;
    };
    
    return [commonHours copy];
}

-(BOOL) isEnoughDataAtDay:(NSString *) day {
    if ([[self painLevelsAtDay:day forPainType:MouthPain] count] > 1)  return YES;
    if ([[self painLevelsAtDay:day forPainType:StomachPain] count] >1) return YES;
    if ([[self painLevelsAtDay:day forPainType:OtherPain] count] >1) return YES;
    
    return NO;
}

//Returns an array with dates as NSNumber objects for the current month which contain enough data to display a graph
//Used to mark dates on the calendar in the graph tab
-(NSArray*) datesWithGraphFromDate: (NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"-MM-"];
    NSString *thisMonth = [dateFormatter stringFromDate:currentDate];
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        NSString *day = [NSString alloc];
        if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
        {
            day = [timeStamp componentsSeparatedByString:@"-"][2];
            day = [day substringToIndex:2];
            if ([self isEnoughDataAtDay:day])
            {
                NSNumber *dateToBeAdded = [NSNumber numberWithInt:[day intValue]];
                if ([dates count] < 1 || ![dates[[dates count]-1] isEqualToValue:dateToBeAdded])
                    [dates addObject:dateToBeAdded];
            }
        }
    }
    
    return [dates copy];
}

//Methods for writing and reading images
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

@end
