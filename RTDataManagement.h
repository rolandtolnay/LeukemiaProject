//
//  RTDataManagement.h
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTConstants.h"
#include <stdlib.h>
#import "NSDate+convenience.h"

@interface RTDataManagement : NSObject

//pList properties
@property (strong,nonatomic) NSMutableArray *painData;
@property (strong,nonatomic) NSMutableArray *diaryData;
//@property (strong, nonatomic) NSMutableDictionary *bloodSampleData;
@property (strong, nonatomic) NSMutableArray *medicineData;
@property (strong, nonatomic) NSMutableDictionary *kemoTabletData;
//@property (strong, nonatomic) NSMutableDictionary *kemoTreatment;
@property (strong, nonatomic) NSString *path;

@property (nonatomic) NSUserDefaults *prefs;
//NSUserDefault - painScaleSettings
@property NSInteger selectedRowPainScale;
@property BOOL painScaleBieri;
@property BOOL painScaleWongBaker;
@property BOOL flaccScale;
//NSUserDefault - notificationsettings
@property NSInteger selectedRowNotification;
@property BOOL notificationsOn;

+(RTDataManagement *)singleton;
-(void)saveUserPrefrences;
//-(id)initWithPlistAndUserPreferences;
-(void)writeToPList;
-(void)reloadPlist;

//service methods for graph data-management
-(NSArray*) painLevelsAtDay:(NSString*) day forPainType:(NSString *) painType;
-(NSArray*) timeStampsAtDay:(NSString*) day;
-(NSArray *)timeStampsAtDay:(NSString *) day forPainType:(NSString *) painType;
-(BOOL) isEnoughDataAtDay:(NSString *) day;
-(BOOL) isEnoughDataAtDay:(NSString *)day forPainType:(NSString*) painType;
-(NSArray*) datesWithGraphFromDate: (NSDate*) currentDate;
-(NSArray*)allDatesInWeek:(long)weekNumber forYear:(int)year;

//diary
-(NSArray*) datesWithDiaryDataFromDate: (NSDate*) currentDate;
-(NSMutableDictionary*) diaryDataAtDate:(NSDate*) date;

//medicine
-(NSMutableDictionary*) medicineDataAtDate:(NSDate*) date;
-(NSMutableDictionary*)newData:(NSDate*)date;

//image reading and writing
-(void) UIImageWriteToFile:(UIImage *)image :(NSString *)fileName;
-(void) UIImageReadFromFile:(UIImage **)image :(NSString *)fileName;

//testing
-(void) initTestData;
-(NSMutableDictionary *)readFromPlist;

@end
