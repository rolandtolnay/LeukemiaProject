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
    
    self.medicineView.layer.borderWidth = 1.0;
    self.medicineView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.weekSelector = [[LSWeekView alloc] initWithFrame:CGRectZero style:LSWeekViewStyleDefault];
    self.weekSelector.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.weekSelector.calendar = [NSCalendar currentCalendar];

    self.weekSelector.selectedDate = [NSDate date];
    
    __weak typeof(self) weakSelf = self;
    self.weekSelector.didChangeSelectedDateBlock = ^(NSDate *selectedDate)
    {
        [weakSelf updateNoSampleLabel];
        [weakSelf removeBloodSampleUI];
    };
    
    [self.weekSelectorView addSubview:self.weekSelector];
    
}

-(void)updateNoSampleLabel{
    NSLog(@"%@",self.weekSelector.selectedDate);
    if(self.weekSelector.selectedDate.day != 10){
        self.addSampleButton.hidden = NO;
    self.noSampleLabel.text = @"There is no bloodsample for this date";
    }
    else{
        self.noSampleLabel.text = @"Det er den 10. idag";
        self.addSampleButton.hidden = YES;
    }
}


- (IBAction)addSample:(id)sender {
    [self addBloodSampleUI];
}

- (IBAction)saveSample:(id)sender {
    [self removeBloodSampleUI];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.hemoText isFirstResponder] && [touch view] != self.hemoText) {
        [self.hemoText resignFirstResponder];
    }
    else if ([self.thrombotext isFirstResponder] && [touch view] != self.thrombotext) {
        [self.thrombotext resignFirstResponder];
    }
    else if ([self.neutroText isFirstResponder] && [touch view] != self.neutroText) {
        [self.neutroText resignFirstResponder];
    }
    else if ([self.crptext isFirstResponder] && [touch view] != self.crptext) {
        [self.crptext resignFirstResponder];
    }
    else if ([self.natriumtext isFirstResponder] && [touch view] != self.natriumtext) {
        [self.natriumtext resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)addBloodSampleUI{
    self.addSampleButton.hidden = YES;
    self.noSampleLabel.text = @"";
    for (UILabel *label in self.bloodSampleLabels) {
        label.hidden = NO;
    }
    for(UITextField *txtField in self.bloodSampleTextFields){
        txtField.hidden = NO;
    }
    self.saveSampleButton.hidden = NO;
}

-(void)removeBloodSampleUI{
    for (UILabel *label in self.bloodSampleLabels) {
        label.hidden = YES;
    }
    for(UITextField *txtField in self.bloodSampleTextFields){
        txtField.hidden = YES;
    }
    self.saveSampleButton.hidden = YES;
    self.addSampleButton.hidden = NO;
    self.noSampleLabel.text = @"There is no bloodsample for this date";

}
@end
