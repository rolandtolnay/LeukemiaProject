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

#pragma mark - Initializers

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

-(NSMutableArray *)kemoTreatmentArray{
    if(!_kemoTreatmentArray){
        _kemoTreatmentArray = [[NSMutableArray alloc]init];
    }
    return _kemoTreatmentArray;
}

-(NSMutableArray *)medicineData{
    if (!_medicineData) {
        _medicineData = [[NSMutableArray alloc]init];
    }
    return  _medicineData;
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
        self.painScaleWongBaker = [self.prefs boolForKey:@"painScaleWongBaker"];
        self.flaccScale = [self.prefs boolForKey:@"flaccScale"];
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
    [pList setObject:[self UniqueAppId] forKey:@"dataID"];
    return pList;
}

-(void)writeToPList{
    NSMutableDictionary *pList = [self readFromPlist];
    [pList setObject:self.painData forKey:@"painData"];
    [pList setObject:self.diaryData forKey:@"diaryData"];
    [pList setObject:self.medicineData forKey:@"medicineData"];
    //    [pList setObject:self.kemoTreatmentData forKey:@"kemoTreatmentData"];
    [pList setObject:self.kemoTreatmentArray forKey:@"kemoTreatmentArray"];
    [pList writeToFile:self.path atomically:YES];
}

-(void)saveUserPrefrences{
    [self.prefs setInteger:self.selectedRowPainScale forKey:@"selectedRowPainScale"];
    if (self.selectedRowPainScale == 0) {
        self.painScaleBieri = NO;
        self.painScaleWongBaker = YES;
        self.flaccScale = NO;
    }
    else if(self.selectedRowPainScale == 1){
        self.painScaleBieri = YES;
        self.painScaleWongBaker = NO;
        self.flaccScale = NO;
    }
    else if (self.selectedRowPainScale == 2){
        self.painScaleBieri = NO;
        self.painScaleWongBaker = NO;
        self.flaccScale = YES;
    }
    [self.prefs setBool:self.painScaleBieri forKey:@"painScaleBieri"];
    [self.prefs setBool:self.painScaleWongBaker forKey:@"painScaleWongBaker"];
    [self.prefs setBool:self.flaccScale forKey:@"flaccScale"];
    [self.prefs synchronize];
}

-(void)reloadPlist{
    NSMutableDictionary *pList = [self readFromPlist];
    self.painData = [pList objectForKey:@"painData"];
    self.diaryData = [pList objectForKey:@"diaryData"];
    self.medicineData = [pList objectForKey:@"medicineData"];
    //    self.kemoTreatmentData = [pList objectForKey:@"kemoTreatmentData"];
    self.kemoTreatmentArray = [pList objectForKey:@"kemoTreatmentArray"];
}

#pragma mark - Service methods

-(BOOL)isDate:(NSDate*) start earlierThanDate:(NSDate*) toCompare
{
    NSComparisonResult result = [start compare:toCompare];
    return (result == NSOrderedAscending || result == NSOrderedSame);
}

#pragma mark - Graph Data Management

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
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        
        NSString *hour = [NSString alloc];
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
            hour = [timeStamp componentsSeparatedByString:@" "][1];
            
            [timeStamps addObject:hour];
        }
    }
    
    return [timeStamps copy];
}

-(NSArray *)timeStampsAtDay:(NSString *) day forPainType:(NSString *) painType {
    NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        NSString *hour = [NSString alloc];
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
            NSString *painTypeReg = [painRegistration objectForKey:@"paintype"];
            if ([painTypeReg isEqualToString:painType])
            {
                hour = [timeStamp componentsSeparatedByString:@" "][1];
                [timeStamps addObject:hour];
            }
        }
    }
    
    return [timeStamps copy];
}

//Deprecated, kept for possible later use
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

-(BOOL) isEnoughDataAtDay:(NSString *)day forPainType:(NSString*) painType {
    if ([[self painLevelsAtDay:day forPainType:painType] count] >1) return YES;
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

//Creates an array with dates that contain weight OR notes data from the diary.
//Only searches in the month specified in the date parameter
-(NSArray*) datesWithDiaryDataFromDate: (NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"-MM-"];
    NSString *thisMonth = [dateFormatter stringFromDate:currentDate];
    
    for (NSDictionary *diaryRegistration in self.diaryData)
    {
        NSString *timeStamp = [diaryRegistration objectForKey:@"date"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
        {
            NSMutableDictionary *diaryData = [self diaryDataAtDate:[dateFormatter dateFromString:timeStamp]];
            if (diaryData!=nil)
            {
                NSString *weight = [diaryData objectForKey:@"weight"];
                NSString *notes = [diaryData objectForKey:@"notes"];
                if (![weight isEqualToString:@""] || ![notes isEqualToString:@""])
                {
                    NSNumber *dateToBeAdded = [NSNumber numberWithInt:[[dateFormatter dateFromString:timeStamp] day]];
                    [dates addObject:dateToBeAdded];
                }
            }
        }
    }
    
    return [dates copy];
}

-(NSArray*) datesWithBloodSamplesFromDate: (NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"-MM-"];
    NSString *thisMonth = [dateFormatter stringFromDate:currentDate];
    
    for (NSDictionary *medicineRegistration in self.medicineData)
    {
        NSDictionary *bloodSamples = [medicineRegistration objectForKey:@"bloodSample"];
        if (bloodSamples != nil)
        {
            NSString *timeStamp = [medicineRegistration objectForKey:@"date"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
            {
                NSNumber *dateToBeAdded = [NSNumber numberWithInt:[[dateFormatter dateFromString:timeStamp]day]];
                [dates addObject:dateToBeAdded];
            }
        }
    }
    
    return [dates copy];
}

//returns an NSMutableDictionary with all diary data if it exists in the storage
//Date is without format
-(NSMutableDictionary*) diaryDataAtDate:(NSDate*) date
{
    for (NSMutableDictionary *diaryRegistration in self.diaryData)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *diaryRegDate = [diaryRegistration objectForKey:@"date"];
        if ([diaryRegDate isEqualToString:[dateFormat stringFromDate:date]])
        {
            return diaryRegistration;
        }
    }
    return nil;
}

//returns an NSMutableDictionary with all medicine data if it exists in the storage
//Date is without format
-(NSMutableDictionary*) medicineDataAtDate:(NSDate*) date
{
    for (NSMutableDictionary *medicineRegistration in self.medicineData)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *medicineRegDate = [medicineRegistration objectForKey:@"date"];
        if ([medicineRegDate isEqualToString:[dateFormat stringFromDate:date]])
        {
            return medicineRegistration;
        }
    }
    return nil;
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

//Returns the kemoTreatment that is in progress for a given day
-(NSMutableDictionary*) relevantkemoTreatmentForDay: (NSDate*) date
{
    NSMutableDictionary *kemoTreatment = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //a check to see if there was any treatment on a previous date than the current one
    BOOL isKemo = NO;
    
    if (self.kemoTreatmentArray.count>0)
    {
        NSDate *closestDate = [dateFormatter dateFromString:[self.kemoTreatmentArray[0] objectForKey:@"date"]];
        
        for (NSMutableDictionary *kemoTreatmentRegistration in self.kemoTreatmentArray)
        {
            NSString *kemoTreatmentDateString = [kemoTreatmentRegistration objectForKey:@"date"];
            NSDate *kemoTreatmentDate = [dateFormatter dateFromString:kemoTreatmentDateString];
            
            if ([self isDate:closestDate earlierThanDate:kemoTreatmentDate] && [self isDate:kemoTreatmentDate earlierThanDate:date])
            {
                closestDate = kemoTreatmentDate;
                kemoTreatment = kemoTreatmentRegistration;
                isKemo = YES;
            }
        }
        
        if (!isKemo) return nil;
        
    } else {
        
        return nil;
    }
    
    return kemoTreatment;
}

//Returns the kemoTreatment for a given day from the kemoTreatmentArray
-(NSMutableDictionary *) kemoTreatmentForDay: (NSDate*)date
{
    NSMutableDictionary *kemoTreatment;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    if (self.kemoTreatmentArray.count>0)
    {
        for (NSMutableDictionary *kemoTreatmentRegistration in self.kemoTreatmentArray)
        {
            NSString *kemoTreatmentDateString = [kemoTreatmentRegistration objectForKey:@"date"];
            NSString *dateToSearchString = [dateFormatter stringFromDate:date];
            
            if ([kemoTreatmentDateString isEqual:dateToSearchString])
            {
                kemoTreatment = kemoTreatmentRegistration;
                break;
            }
        }
    } else {
        
        return nil;
    }

    
    return kemoTreatment;
}

#pragma mark - Init data methods

-(NSMutableDictionary*)newMedicineData: (NSDate*)date{
    
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    
    //ID and Date information
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLog(@"Stringfromdate: %@",[dateFormatter stringFromDate:date]);
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *idString = [[[self readFromPlist]objectForKey:@"dataID"]stringByAppendingString:[dateFormatter stringFromDate:date]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dataToBeSaved setObject:idString forKey:@"id"];
    [dataToBeSaved setObject:[dateFormatter stringFromDate:date] forKey:@"date"];
    
    //Kemo-data
    NSMutableDictionary *kemoTreatmentDictionary = [self relevantkemoTreatmentForDay:date];
    if (kemoTreatmentDictionary != nil)
    {
        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"mtx"] forKey:@"mtx"];
        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"6mp"] forKey:@"6mp"];
        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"kemoTreatment"] forKey:@"kemoTreatment"];
    } else {
        [dataToBeSaved setObject:[NSNumber numberWithInt:0] forKey:@"mtx"];
        [dataToBeSaved setObject:[NSNumber numberWithInt:0] forKey:@"6mp"];
        [dataToBeSaved setObject:@"" forKey:@"kemoTreatment"];
    }
    
    //BloodSample Data
    NSMutableDictionary *bloodSampleData = [[NSMutableDictionary alloc] init];
    [bloodSampleData setObject:@"" forKey:@"hemoglobin"];
    [bloodSampleData setObject:@"" forKey:@"thrombocytes"];
    [bloodSampleData setObject:@"" forKey:@"neutrofile"];
    [bloodSampleData setObject:@"" forKey:@"crp"];
    [bloodSampleData setObject:@"" forKey:@"leukocytes"];
    [bloodSampleData setObject:@"" forKey:@"alat"];
    [bloodSampleData setObject:@"" forKey:@"other"];
    [dataToBeSaved setObject:bloodSampleData forKey:@"bloodSample"];
    
    [self.medicineData addObject:dataToBeSaved];
    return dataToBeSaved;
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

#pragma mark - Test Data

-(void) initTestData {
    int painRegToGenerate = 30;
    for (int idx=0; idx < painRegToGenerate;idx++)
    {
        
        NSMutableDictionary *painRegistration = [[NSMutableDictionary alloc]init];
        
        NSNumber *painLevel = [NSNumber numberWithInt:arc4random_uniform(11)];
        [painRegistration setObject:[painLevel stringValue] forKey:@"painlevel"];
        
        [painRegistration setObject:@"" forKey:@"drawingpath"];
        [painRegistration setObject:@"" forKey:@"photopath"];
        
        NSNumber *morphineLevel = [NSNumber numberWithInt:arc4random_uniform(40)+10];
        [painRegistration setObject:[morphineLevel stringValue] forKey:@"morphinelevel"];
        
        NSDate *currentDate = [[[[NSDate date] offsetDay:arc4random_uniform(5)-2] offsetHours:11] offsetMinutes:idx*2];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *currentTime = [dateFormatter stringFromDate:currentDate];
        [painRegistration setObject:currentTime forKey:@"time"];
        
        NSString *painType;
        switch (arc4random_uniform(3)) {
            case 0:
                painType = @"Mouth";
                break;
            case 1:
                painType = @"Stomach";
                break;
            case 2:
                painType = @"Other";
                break;
            default:
                break;
        }
        [painRegistration setObject:painType forKey:@"paintype"];
        
        [self.painData addObject:painRegistration];
    }
    
    [self writeToPList];
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
