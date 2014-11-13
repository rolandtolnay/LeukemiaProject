//
//  RTDataManagement.h
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
#import "NSDate+convenience.h"
#import "SSKeyChain.h"
@import AdSupport;
#import "RTService.h"

@interface RTDataManagement : NSObject

//pList properties
@property (strong,nonatomic) NSMutableArray *painData;
@property (strong,nonatomic) NSMutableArray *diaryData;
@property (strong, nonatomic) NSMutableArray *medicineData;
@property (strong, nonatomic) NSMutableArray *kemoTreatmentArray;
@property (strong, nonatomic) NSString *path;

//NSUserDefault
@property (nonatomic) NSUserDefaults *prefs;
@property NSInteger selectedRowPainScale;
@property BOOL painScaleBieri;
@property BOOL painScaleWongBaker;
@property BOOL flaccScale;

//pList methods
+(RTDataManagement *)singleton;
-(void)saveUserPrefrences;
-(void)writeToPList;
-(void)reloadPlist;
-(NSMutableDictionary *)readFromPlist;

//Service methods for graph data-management
-(NSArray *) painLevelsAtDay:(NSString *) day forPainType:(NSString *) painType;
-(NSArray *) timeStampsAtDay:(NSString *) day;
-(NSArray *) timeStampsAtDay:(NSString *) day forPainType:(NSString *) painType;
-(BOOL) isEnoughDataAtDay:(NSString *) day;
-(BOOL) isEnoughDataAtDay:(NSString *) day forPainType:(NSString *) painType;
-(NSArray *) datesWithGraphFromDate: (NSDate*) currentDate;

//Service methods for diary data-managenment
-(NSArray *) datesWithDiaryDataFromDate: (NSDate*) currentDate;
-(NSMutableDictionary *) diaryDataAtDate:(NSDate*) date;

//Service methods for medicine data-managenment
-(NSMutableDictionary *) medicineDataAtDate:(NSDate*) date;
-(NSMutableDictionary *) relevantKemoTreatmentForDay: (NSDate*) date;
-(NSMutableDictionary *) kemoTreatmentForDay: (NSDate*)date;
-(NSMutableDictionary *) newMedicineData:(NSDate*)date;

//Service methods for bloodsample data-management
-(NSArray *) datesWithBloodSamplesFromDate: (NSDate*) currentDate;

//testing
-(void) initTestData;

@end
