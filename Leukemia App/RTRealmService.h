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


@interface RTRealmService : NSObject
+(RTRealmService *) singleton;
-(RLMResults *)painDataOnDate:(NSDate *) date;
-(RTDiaryData *)diaryDataOnDate:(NSDate *) date;
@end
