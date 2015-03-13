//
//  RTDataManagement.m
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTDataManagement.h"

@implementation RTDataManagement

static RTDataManagement *dataManagement = nil;

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
        if (dataManagement == nil)
        {
            dataManagement = [[self alloc] initWithPlistAndUserPreferences];
        }
    }
    
    return dataManagement;
}

#pragma mark - PList methods

//Initialises RTDataManagement with values from pList

-(id)initWithPlistAndUserPreferences{
    if (self = [super init]){
        self.selectedRowPainScale = [self.prefs integerForKey:@"selectedRowPainScale"];
        self.painScaleBieri = [self.prefs boolForKey:@"painScaleBieri"];
        self.painScaleWongBaker = [self.prefs boolForKey:@"painScaleWongBaker"];
        self.flaccScale = [self.prefs boolForKey:@"flaccScale"];
        self.patientID = [self.prefs valueForKey:@"patientID"];
        self.patientName = [self.prefs valueForKey:@"patientName"];
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
    if (self.patientID !=nil)
        [pList setObject:self.patientID forKey:@"patientID"];
    return pList;
}

-(void)writeToPList{
    NSMutableDictionary *pList = [self readFromPlist];
    [pList setObject:self.painData forKey:@"painData"];
    [pList setObject:self.diaryData forKey:@"diaryData"];
    [pList setObject:self.medicineData forKey:@"medicineData"];
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
    [self.prefs setValue:self.patientID forKey:@"patientID"];
    [self.prefs setValue:self.patientName forKey:@"patientName"];
    [self.prefs synchronize];
}

-(void)reloadPlist{
    NSMutableDictionary *pList = [self readFromPlist];
    self.painData = [pList objectForKey:@"painData"];
    self.diaryData = [pList objectForKey:@"diaryData"];
    self.medicineData = [pList objectForKey:@"medicineData"];
    self.kemoTreatmentArray = [pList objectForKey:@"kemoTreatmentArray"];
}

#pragma mark - Pain Data Management

- (NSArray*) painLevelsAtDay:(NSString *) day forPainType:(NSString*) painType{
    NSMutableArray *painLevels = [[NSMutableArray alloc] init];
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *painTypeReg = [painRegistration objectForKey:@"paintype"];
        if ([painTypeReg isEqualToString:painType])
        {
            NSNumber *painLevel = [painRegistration objectForKey:@"painlevel"];
            NSString *timeStamp = [painRegistration objectForKey:@"date"];
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
        NSString *timeStamp = [painRegistration objectForKey:@"date"];
        
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
            NSString *hour = [timeStamp componentsSeparatedByString:@" "][1];
            
            [timeStamps addObject:hour];
        }
    }
    
    return [timeStamps copy];
}

-(NSArray *)timeStampsAtDay:(NSString *) day forPainType:(NSString *) painType {
    NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"date"];
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
            NSString *painTypeReg = [painRegistration objectForKey:@"paintype"];
            if ([painTypeReg isEqualToString:painType])
            {
                NSString *hour = [timeStamp componentsSeparatedByString:@" "][1];
                [timeStamps addObject:hour];
            }
        }
    }
    
    return [timeStamps copy];
}



//Used for marking dates in the calendar
-(NSArray*) datesWithPainFromDate: (NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"-MM-"];
    NSString *thisMonth = [dateFormatter stringFromDate:currentDate];
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"date"];
        if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
        {
            NSString *day = [timeStamp componentsSeparatedByString:@"-"][2];
            day = [day substringToIndex:2];
            NSNumber *dateToBeAdded = [NSNumber numberWithInt:[day intValue]];
            
            //check for duplicates
            if ([dates count] < 1 || ![dates[[dates count]-1] isEqualToValue:dateToBeAdded])
                [dates addObject:dateToBeAdded];
            
        }
    }
    
    return [dates copy];
}

#pragma mark - Graph data management

//Returns an array with dates as NSNumber objects for the current month which contain enough data to display a graph
//Used to mark dates on the calendar in the graph tab
-(NSArray*) datesWithGraphFromDate: (NSDate*) currentDate{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"-MM-"];
    NSString *thisMonth = [dateFormatter stringFromDate:currentDate];
    
    for (NSDictionary *painRegistration in self.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"date"];
        if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
        {
            NSString *day = [timeStamp componentsSeparatedByString:@"-"][2];
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

-(BOOL) isEnoughDataAtDay:(NSString *) day {
    if ([[self painLevelsAtDay:day forPainType:@"Mouth"] count] > 1)  return YES;
    if ([[self painLevelsAtDay:day forPainType:@"Stomach"] count] >1) return YES;
    if ([[self painLevelsAtDay:day forPainType:@"Other"] count] >1) return YES;
    
    return NO;
}

-(BOOL) isEnoughDataAtDay:(NSString *)day forPainType:(NSString*) painType {
    if ([[self painLevelsAtDay:day forPainType:painType] count] >1) return YES;
    return NO;
}

#pragma mark - Diary Data Management

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
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
        {
            NSMutableDictionary *diaryData = [self diaryDataAtDate:[dateFormatter dateFromString:timeStamp]];
            if (diaryData!=nil)
            {
                NSString *weight = [[diaryData objectForKey:@"weight"]stringValue];
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

//returns an NSMutableDictionary with all diary data if it exists in the storage
//date is without format
-(NSMutableDictionary*) diaryDataAtDate:(NSDate*) date
{
    for (NSMutableDictionary *diaryRegistration in self.diaryData)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSDate *tempDate = [dateFormat dateFromString:[diaryRegistration objectForKey:@"date"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        if ([[dateFormat stringFromDate:tempDate] isEqualToString:[dateFormat stringFromDate:date]])
        {
            return diaryRegistration;
        }
    }
    return nil;
}

#pragma mark - Medicine Data Management

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
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            if ([timeStamp rangeOfString:thisMonth].location != NSNotFound)
            {
                NSDate *timeStampDate = [dateFormatter dateFromString:timeStamp];
                NSNumber *dateToBeAdded = [NSNumber numberWithInt:[timeStampDate day]];
                [dates addObject:dateToBeAdded];
            }
        }
    }
    
    return [dates copy];
}

//returns an NSMutableDictionary with all medicine data if it exists in the storage
//Date is without format
-(NSMutableDictionary*) medicineDataAtDate:(NSDate*) date
{
    for (NSMutableDictionary *medicineRegistration in self.medicineData)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSDate *tempDate = [dateFormat dateFromString:[medicineRegistration objectForKey:@"date"]];

        if ([date isEqualToDate:tempDate]){
            return medicineRegistration;
        }
    }
    return nil;
}


//Returns the kemoTreatment that is in progress for a given day
-(NSMutableDictionary*) relevantKemoTreatmentForDay: (NSDate*) date
{
    NSMutableDictionary *kemoTreatment = [[NSMutableDictionary alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    RTService *service = [RTService singleton];
    
    //a check to see if there was any treatment on a previous date than the current one
    BOOL isKemo = NO;
    
    if (self.kemoTreatmentArray.count>0)
    {
        NSDate *closestDate = [dateFormatter dateFromString:[self.kemoTreatmentArray[0] objectForKey:@"date"]];
        
        for (NSMutableDictionary *kemoTreatmentRegistration in self.kemoTreatmentArray)
        {
            NSString *kemoTreatmentDateString = [kemoTreatmentRegistration objectForKey:@"date"];
            NSDate *kemoTreatmentDate = [dateFormatter dateFromString:kemoTreatmentDateString];
            
            if ([service isDate:closestDate earlierThanDate:kemoTreatmentDate] && [service isDate:kemoTreatmentDate earlierThanDate:date])
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

-(NSMutableDictionary*)newMedicineData:(NSDate*)date{
    
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    
    //ID and Date information
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [dataToBeSaved setObject:[dateFormatter stringFromDate:date] forKey:@"date"];
    [dataToBeSaved setObject:[[RTService singleton] dataID] forKey:@"id"];
    
    //Kemo-data
    NSMutableDictionary *kemoTreatmentDictionary = [self relevantKemoTreatmentForDay:date];
    if (kemoTreatmentDictionary != nil)
    {
        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"mtx"] forKey:@"mtx"];
        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"mercaptopurin"] forKey:@"mercaptopurin"];
        [dataToBeSaved setObject:[kemoTreatmentDictionary objectForKey:@"kemoTreatment"] forKey:@"kemoTreatment"];
    } else {
        [dataToBeSaved setObject:[NSNumber numberWithInt:0] forKey:@"mtx"];
        [dataToBeSaved setObject:[NSNumber numberWithInt:0] forKey:@"mercaptopurin"];
        [dataToBeSaved setObject:@"" forKey:@"kemoTreatment"];
    }
    
    //BloodSample Data
    NSMutableDictionary *bloodSampleData = [[NSMutableDictionary alloc] init];
    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"hemoglobin"];
    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"thrombocytes"];
    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"leukocytes"];
    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"neutrofile"];
    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"crp"];
    [bloodSampleData setObject:[NSNumber numberWithInteger:[@"" intValue]] forKey:@"alat"];
    [dataToBeSaved setObject:bloodSampleData forKey:@"bloodSample"];
    
    [self.medicineData addObject:dataToBeSaved];
    return dataToBeSaved;
}



#pragma mark - Test Data
//Needs rework
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
                painType = @"";
                break;
        }
        [painRegistration setObject:painType forKey:@"paintype"];
        
        [self.painData addObject:painRegistration];
    }
    
    [self writeToPList];
}


#pragma mark - Saving data methods
-(void)saveMucositisData:(RTMucositisData *)data{
    NSLog(@"DATA: %@",data);
}

-(RTMucositisData *)readMucositisDataFromDate: (NSDate *)date{
    return 0;
}




@end
