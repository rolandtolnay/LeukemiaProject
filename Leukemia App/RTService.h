//
//  RTService.h
//  Leukemia App
//
//  Created by dmu-23 on 10/11/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+convenience.h"
#import "SSKeyChain.h"
@import AdSupport;
#import "Reachability.h"
#import "RTDataManagement.h"

@interface RTService : NSObject

+(RTService *) singleton;

//date convenience
-(BOOL)isDate:(NSDate*) start earlierThanDate:(NSDate*) toCompare;
-(NSArray*)allDatesInWeek:(long)weekNumber forYear:(int)year;

//image reading and writing
-(void) UIImageWriteToFile:(UIImage *)image :(NSString *)fileName;
-(void) UIImageReadFromFile:(UIImage **)image :(NSString *)fileName;

- (void)exportData;

//app-ID
-(NSString*)UniqueAppId;
-(NSString*)dataID;

@end
