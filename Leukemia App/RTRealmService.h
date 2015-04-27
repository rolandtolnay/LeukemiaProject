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
//MedicineData
-(RTMedicineData *) medicineDataAtDate:(NSDate*) date;
//Kemodata
//-(NSArray *)kemoForDate:(NSDate*) date;
-(RTKemoTreatment *) kemoTreatmentForDay: (NSDate*)date;

@end
