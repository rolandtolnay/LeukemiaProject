//
//  RTGraphWeekPickerViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 23/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+convenience.h"
#import "RTDataManagement.h"

@protocol RTWeekPickerDelegate <NSObject>

-(void)weekSelected:(NSArray *)datesInWeek;

@end

@interface RTGraphWeekPickerViewController : UIViewController

@property NSMutableArray *weeks;
@property NSArray *years;
@property NSDate *pickedDate;
@property (weak, nonatomic) IBOutlet UIPickerView *weekPicker;

@property (nonatomic,assign) id delegate;

- (IBAction)showGraph:(id)sender;


@end
