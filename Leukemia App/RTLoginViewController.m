//
//  RTLoginViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 13/11/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTLoginViewController.h"

#define ActivationPassword @"2468"

@interface RTLoginViewController ()


@end

@implementation RTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblError.hidden = YES;
}

- (IBAction)confirm:(id)sender {
    
    if ([self.txfPassword.text isEqual:ActivationPassword])
    {
        [RTDataManagement singleton].patientID = self.txfPatientId.text;
        [RTDataManagement singleton].patientName = self.txfPatientName.text;
        [[RTDataManagement singleton] saveUserPrefrences];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil                                                             message:NSLocalizedString(@"Activation succesful!", @"Message on succesfull login")
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 1; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });

    } else {
        [self.lblError setText:@"Invalid activation password."];
        [self.txfPassword setText:@""];
        self.lblError.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txfPassword isFirstResponder] && [touch view] != self.txfPassword) {
        [self.txfPassword resignFirstResponder];
    }
    if ([self.txfPatientId isFirstResponder] && [touch view] != self.txfPatientId) {
        [self.txfPatientId resignFirstResponder];
    }
    if ([self.txfPatientName isFirstResponder] && [touch view] != self.txfPatientName) {
        [self.txfPatientName resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
