//
//  RTDataManagement.h
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTDataManagement : NSObject

@property (strong,nonatomic) NSMutableDictionary *painData;
@property (strong, nonatomic) NSString *path;

+(RTDataManagement *)singleton;
-(id)initWithPlist;
-(void)writeToPList;
-(void)reloadPlist;

@end
