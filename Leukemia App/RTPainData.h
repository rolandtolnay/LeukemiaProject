//
//  RTPainData.h
//  Leukemia App
//
//  Created by Nicolai Duus on 20/03/15.
//  Copyright (c) 2015 Nicolai Duus. All rights reserved.
//

#import <Realm/Realm.h>

@interface RTPainData : RLMObject

@property (strong,nonatomic) NSString *dataId;
@property (strong,nonatomic) NSString *drawingPath;
@property (strong,nonatomic) NSString *photoPath;
@property (strong,nonatomic) NSString *morphineType;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSString *painType;
@property (nonatomic) BOOL paracetamol;
@property (nonatomic) NSInteger painLevel;
@property (nonatomic) NSInteger morphineLevel;
@property int day;
@property int month;
@property int year;

@end
