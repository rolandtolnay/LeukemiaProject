//
//  RTDiaryViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"

@interface RTDiaryViewController : UIViewController <VRGCalendarViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *calendarView;

@end
