//
//  RTLoginViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 13/11/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDataManagement.h"

@interface RTLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txfPatientName;
@property (weak, nonatomic) IBOutlet UITextField *txfPatientId;
@property (weak, nonatomic) IBOutlet UITextField *txfPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

- (IBAction)confirm:(id)sender;

@end
