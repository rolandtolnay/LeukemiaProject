//
//  RTGraphCalendarViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 09/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "RTDataManagement.h"
#import "NSDate+convenience.h"

@protocol RTCalendarPickerDelegate <NSObject>

- (void) dateSelected:(NSDate*) date;
- (NSArray *) monthChanged:(NSInteger) month;

@end

@interface RTGraphCalendarViewController : UIViewController <VRGCalendarViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *calendarView;
@property NSDate* pickedDate;

@property NSArray* markedDates;

@property (nonatomic,assign) id delegate;

@end

