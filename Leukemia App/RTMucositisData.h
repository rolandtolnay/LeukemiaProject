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
@property (nonatomic) NSInteger painScore;
@property (nonatomic) NSInteger redNessScore;
@property (nonatomic) NSInteger foodScore;
@property (strong,nonatomic) NSString *drawingPath;
@property (nonatomic) NSInteger nrOfVomitting;
@property (nonatomic) NSInteger nrOfStools;
@property (nonatomic) NSInteger fluidsDrunkML;
@property (nonatomic) NSInteger fluidsInDropML;
@property (nonatomic) NSInteger urinML;
@property (nonatomic) NSInteger weightKG;

@end
