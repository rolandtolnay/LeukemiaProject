//
//  RTRealmService.h
//  Leukemia App
//
//  Created by Nicolai Duus on 20/03/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTPainData.h"
#import "RTDiaryData.h"
#import "RTMedicineData.h"
#import "RTBloodSample.h"
#import "RTKemoTreatment.h"
#import "NSDate+convenience.h"
#import "RTService.h"


@interface RTRealmService : NSObject

+(RTRealmService *) singleton;
//PainData
-(RLMResults *)painDataOnDate:(NSDate *) date;
//DiaryData
-(RTDiaryData *)diaryDataOnDate:(NSDate *) date;
-(NSArray *) datesToBeMarkedInMonthFromDate: (NSDate*) currentDate;
//BloodSampleData
-(RTBloodSample *)bloodSampleForDate:(NSDate *) date;
-(RLMResults*)daysWithBloodSamplesSorted;
-(NSArray*) datesWithBloodSamplesFromDate: (NSDate*) currentDate;
//MedicineData
-(RTMedicineData *) medicineDataAtDate:(NSDate*) date;
-(RTMedicineData *) newMedicineData:(NSDate*)date;
-(RTKemoTreatment *) relevantKemoTreatmentForDay: (NSDate*) date;
//Kemodata
//-(NSArray *)kemoForDate:(NSDate*) date;
-(RTKemoTreatment *) kemoTreatmentForDay: (NSDate*)date;
//Service methods for mucositis data-management
-(void)saveMucositisData:(RTMucositisData *) data;
-(RTMucositisData *)readMucositisDataFromDate: (NSDate *)date;

@end
