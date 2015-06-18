//
//  RTMucositisViewController.m
//  Leukemia App
//
//  Created by DMU-24 on 29/01/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import "RTMucositisViewController.h"

@interface RTMucositisViewController ()

@property UIPopoverController *popover;

@end

@implementation RTMucositisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.dataManagement = [RTDataManagement singleton];
    self.btnPressedColor = [UIColor colorWithRed:105.0/255.0 green:147.0/255.0 blue:197.0/255.0 alpha:1.0];
    self.painScore = 0;
    self.rednessScore = 0;
    self.foodConsumptionScore = 0;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"mucositisInfoSegue"]){
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
}

- (IBAction)unwindToMucositisController:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if([sourceViewController isKindOfClass:[RTMouthDrawViewController class]]){
        RTMouthDrawViewController *controller = segue.sourceViewController;
        if (controller.mainImage.image)
        {
            UIGraphicsBeginImageContextWithOptions(controller.mainImage.bounds.size, NO,0.0);
            [controller.mainImage.image drawInRect:CGRectMake(0, 0, controller.mainImage.frame.size.width, controller.mainImage.frame.size.height)];
            self.drawingToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
}

#pragma mark - Methods related specific to saving data

- (IBAction)saveAndSubmit:(id)sender {
    RTMucositisData *dataToBeSaved = [[RTMucositisData alloc]init];
    dataToBeSaved.date = [NSDate date];
    dataToBeSaved .painScore = self.painScore;
    dataToBeSaved .redNessScore = self.rednessScore;
    dataToBeSaved .foodScore = self.foodConsumptionScore;
    dataToBeSaved .drawingPath = @"";
    dataToBeSaved .nrOfVomitting = [self.vomittingTxt.text integerValue];
    dataToBeSaved .nrOfStools = [self.stoolsTxt.text integerValue];
    dataToBeSaved .fluidsDrunkML = [self.fluidsDrunkTxt.text integerValue];
    dataToBeSaved .fluidsInDropML = [self.fluidsInDropTxt.text integerValue];
    dataToBeSaved .urinML = [self.urinTxt.text integerValue];
    dataToBeSaved .weightKG = [self.weightTxt.text integerValue];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:dataToBeSaved];
    [realm commitWriteTransaction];
    [self resetView];
}

#pragma mark - Methods related specific to Mucositis table
- (IBAction)mucositisTableButtonSelected:(id)sender {
    UIButton *selectedButton = sender;
    if(!selectedButton.backgroundColor){
        selectedButton.backgroundColor = self.btnPressedColor;
        selectedButton.alpha = 0.3;
    }
    else{
        selectedButton.backgroundColor = nil;
    }
    if([self.painButtons containsObject:selectedButton]){
        self.painScore = selectedButton.tag;
        for(UIButton *btnInSelectedRow in self.painButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    else if([self.rednessButtons containsObject:selectedButton]){
        self.rednessScore = selectedButton.tag;
        for(UIButton *btnInSelectedRow in self.rednessButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    else if([self.foodButtons containsObject:selectedButton]){
        self.foodConsumptionScore = selectedButton.tag;
        for(UIButton *btnInSelectedRow in self.foodButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
}

#pragma mark - Help methods
-(void) resetView{
    for (UIButton *button in self.allButtons) {
        if (button.backgroundColor) {
            button.backgroundColor = nil;
        }
    }
    for(UITextField *txtField in self.allTxtFields){
        txtField.text = @"";
    }
}

@end
