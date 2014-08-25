//
//  RTDataManagement.m
//  Leukemia App
//
//  Created by DMU-24 on 22/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTDataManagement.h"

@implementation RTDataManagement

static RTDataManagement *dataMangement = nil;

-(NSMutableArray *)painData{
    if(!_painData){
        _painData = [[NSMutableArray alloc]init];
    }
    return _painData;
}

//Singleton method

+ (RTDataManagement *)singleton {
    @synchronized(self) {
        if (dataMangement == nil)
            dataMangement = [[self alloc] initWithPlist];
    }
    return dataMangement;
}

//Initialises RTDataManagement with values from pList

-(id)initWithPlist{
    if (self = [super init]){
        [self reloadPlist];
    }
    return self;
}

//Path is the filepath of the pList
-(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"leukemiaApp.plist"];
}

//readFromPlist either reads data from an existing pList, or creates a new dictionary in the path of the pList, the first time data is saved
-(NSMutableDictionary *)readFromPlist{
    NSMutableDictionary *pList;
    if([[NSFileManager defaultManager] fileExistsAtPath:self.path]){
        pList = [[NSMutableDictionary alloc]initWithContentsOfFile:self.path];
    }
    else{
        pList = [[NSMutableDictionary alloc]init];
    }
    return pList;
}

-(void)writeToPList{
    NSMutableDictionary *pList = [self readFromPlist];
    [pList setObject:self.painData forKey:@"painData"];
    [pList writeToFile:self.path atomically:YES];
}

-(void)reloadPlist{
    self.painData = [[self readFromPlist]objectForKey:@"painData"];
}

@end
