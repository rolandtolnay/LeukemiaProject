//
//  RTBloodSample.h
//  Leukemia App
//
//  Created by Nicolai Duus on 20/04/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import <Realm/Realm.h>

@interface RTBloodSample : RLMObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic) float neutroFile;
@property (nonatomic) NSInteger alat;
@property (nonatomic) NSInteger crp;
@property (nonatomic) float hemoglobin;
@property (nonatomic) float leukocytes;
@property (nonatomic) NSInteger thrombocytes;

@end
