//
//  RTBloodSampleTableViewCell.h
//  Leukemia App
//
//  Created by dmu-23 on 14/10/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTBloodSampleTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txfBloodSample;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dayLabels;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *daySeparators;

@end
