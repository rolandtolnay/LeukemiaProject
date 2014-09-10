//
//  RTDataManagement.h
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTConstants.h"

@interface RTDataManagement : NSObject

//pList properties
@property (strong,nonatomic) NSMutableArray *painData;
@property (strong, nonatomic) NSString *path;

//NSUserDefault - painScaleSettings
@property NSInteger selectedRowPainScale;
@property BOOL painScaleBieri;
//NSUserDefault - notificationsettings
@property NSInteger selectedRowNotification;
@property BOOL notificationsOn;

@property (nonatomic) NSUserDefaults *prefs;

+(RTDataManagement *)singleton;
-(void)saveUserPrefrences;
//-(id)initWithPlistAndUserPreferences;
-(void)writeToPList;
-(void)reloadPlist;

//service methods
-(NSArray*) painLevelsAtDay:(NSString*) day forPainType:(NSString *) painType;
-(NSArray*) timeStampsAtDay:(NSString*) day;
-(BOOL) isEnoughDataAtDay:(NSString *) day;
-(NSArray*) datesWithGraphFromDate: (NSDate*) currentDate;

@end
