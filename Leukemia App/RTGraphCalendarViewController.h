//
//  RTGraphCalendarViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 28/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCalendar.h"
#import "NSDate+MDCalendar.h"
#import "UIColor+MDCalendarDemo.h"

@protocol RTCalendarPickerDelegate <NSObject>

- (void) dateSelected:(NSDate*) date;

@end

@interface RTGraphCalendarViewController : UIViewController <MDCalendarDelegate>

@property (strong, nonatomic) IBOutlet MDCalendar *calendarView;

@property (nonatomic,assign) id delegate;

@end
