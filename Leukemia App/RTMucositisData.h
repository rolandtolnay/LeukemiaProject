//
//  RTMucositisData.h
//  Leukemia App
//
//  Created by DMU-24 on 16/02/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RTMucositisData : RLMObject

@property (strong, nonatomic) NSString *dataId;
@property (strong,nonatomic) NSNumber *painScore;
@property (strong,nonatomic) NSNumber *redNessScore;
@property (strong,nonatomic) NSNumber *foodScore;
@property (strong,nonatomic) NSString *drawingPath;
@property (strong,nonatomic) NSNumber *nrOfVomitting;
@property (strong,nonatomic) NSNumber *nrOfStools;
@property (strong,nonatomic) NSNumber *fluidsDrunkML;
@property (strong,nonatomic) NSNumber *fluidsInDropML;
@property (strong,nonatomic) NSNumber *urinML;
@property (strong,nonatomic) NSNumber *weightKG;

@end
