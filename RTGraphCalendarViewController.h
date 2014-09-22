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

@protocol RTCalendarPickerDelegate <NSObject>

- (void) dateSelected:(NSDate*) date;

@end

@interface RTGraphCalendarViewController : UIViewController <VRGCalendarViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *calendarView;
@property NSDate* currentDate;

@property (nonatomic,assign) id delegate;

@end

