//
//  RTSecondViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTMedicineViewController.h"

@interface RTMedicineViewController ()

@end

@implementation RTMedicineViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.weekSelector = [[LSWeekView alloc] initWithFrame:CGRectZero style:LSWeekViewStyleDefault];
    self.weekSelector.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.weekSelector.calendar = [NSCalendar currentCalendar];
    self.weekSelector.selectedDate = [NSDate date];
    
    __weak typeof(self) weakSelf = self;
    self.weekSelector.didChangeSelectedDateBlock = ^(NSDate *selectedDate)
    {
        
    };
    
    [self.weekSelectorView addSubview:self.weekSelector];
    
}



@end
