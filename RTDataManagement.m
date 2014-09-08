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

-(NSUserDefaults *)prefs{
    if (!_prefs) {
        _prefs = [NSUserDefaults standardUserDefaults];
    }
    return _prefs;
}

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
            dataMangement = [[self alloc] initWithPlistAndUserPreferences];
    }
    return dataMangement;
}

//Initialises RTDataManagement with values from pList

-(id)initWithPlistAndUserPreferences{
    if (self = [super init]){
        self.selectedRowPainScale = [self.prefs integerForKey:@"selectedRowPainScale"];
        self.painScaleBieri = [self.prefs boolForKey:@"painScaleBieri"];
        self.selectedRowNotification = [self.prefs integerForKey:@"selectedRowNotification"];
        self.notificationsOn = [self.prefs boolForKey:@"notificationsOn"];
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

-(void)saveUserPrefrences{
    [self.prefs setInteger:self.selectedRowPainScale forKey:@"selectedRowPainScale"];
    if (self.selectedRowPainScale == 0) {
        self.painScaleBieri = NO;
    }
    else{
        self.painScaleBieri = YES;
    }
    [self.prefs setBool:self.painScaleBieri forKey:@"painScaleBieri"];
    
    [self.prefs setInteger:self.selectedRowNotification forKey:@"selectedRowNotification"];
    if (self.selectedRowNotification == 0) {
        self.notificationsOn = YES;
    }
    else{
        self.notificationsOn = NO;
    }
    [self.prefs setBool:self.notificationsOn forKey:@"notificationsOn"];
    
    [self.prefs synchronize];
}

-(void)reloadPlist{
    self.painData = [[self readFromPlist]objectForKey:@"painData"];
}

@end
