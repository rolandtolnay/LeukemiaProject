//
//  RTSettingItem.m
//  Leukemia App
//
//  Created by DMU-24 on 28/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import "RTSettingItem.h"

@implementation RTSettingItem

-(NSMutableArray *)settingValues{
    if (!_settingValues) {
        _settingValues = [[NSMutableArray alloc]init];
    }
    return _settingValues;
}

@end
