//
//  RTKemoTreatment.h
//  Leukemia App
//
//  Created by Nicolai Duus on 20/04/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import <Realm/Realm.h>

@interface RTKemoTreatment : RLMObject

@property (strong, nonatomic) NSDate *date;
@property (nonatomic) NSInteger mtx;
@property (nonatomic) NSInteger mercaptopurin;
@property (strong, nonatomic) NSString *kemoTreatmentType;

@end
