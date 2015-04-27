//
//  RTMedicineData.h
//  Leukemia App
//
//  Created by Nicolai Duus on 20/04/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import <Realm/Realm.h>
#import "RTBloodSample.h"

@interface RTMedicineData : RLMObject

@property (strong, nonatomic) NSString *dataId;
@property (strong, nonatomic) NSString *kemoTreatment;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) NSInteger mtx;
@property (nonatomic) NSInteger mercaptopurin;
@property RTBloodSample *bloodSample;

@end
