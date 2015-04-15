//
//  RTDiaryData.h
//  Leukemia App
//
//  Created by Nicolai Duus on 13/04/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import <Realm/Realm.h>

@interface RTDiaryData : RLMObject

@property (strong, nonatomic) NSString *dataId;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *notes;
@property (nonatomic) NSInteger protocolTreatmentDay;

@end
