//
//  RTDataManagement.m
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTDataManagement.h"

@implementation RTDataManagement

-(NSMutableDictionary *)painData{
    if(!_painData){
        _painData = [[NSMutableDictionary alloc]init];
    }
    return _painData;
}

+ (RTDataManagement *)singleton {
    static RTDataManagement *dataMangement = nil;
    @synchronized(self) {
        if (dataMangement == nil)
            dataMangement = [[self alloc] initWithPlist];
    }
    return dataMangement;
}

-(id)initWithPlist{
    if (self = [super init]){
        [self reloadPlist];
    }
    return self;
}

-(void)writeToPList{
    
}

-(void)reloadPlist{
    
}

@end
