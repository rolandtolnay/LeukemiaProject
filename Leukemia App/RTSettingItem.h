//
//  RTSettingItem.h
//  Leukemia App
//
//  Created by DMU-24 on 28/08/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTSettingItem : NSObject
@property (strong,nonatomic) NSString *settingTitle;
@property (strong, nonatomic) NSMutableArray *settingValues;
@end
