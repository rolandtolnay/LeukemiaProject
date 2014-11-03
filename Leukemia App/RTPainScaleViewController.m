//
//  RTPainScaleViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 18/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTPainScaleViewController.h"

@interface RTPainScaleViewController ()

@property UIPopoverController *popover;
@property UIPopoverController *smileyTablePopover;

@end

@implementation RTPainScaleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataManagement = [RTDataManagement singleton];
    
    [self.dataManagement saveUserPrefrences]; //To make sure that there is a current painscale, the very first time the app is run
    
    //Set up smileyView properties
    [self initSliderPainNumber];
    self.smileys = @[@("A"),@("B"),@("C"),@("D"),@("E"),@("F")];
    self.painDescription = @[
                             (NSLocalizedString(@"No hurt", @"0-1 on painscale")),
                             (NSLocalizedString(@"Hurts little bit", @"2-3 on painscale")),
                             (NSLocalizedString(@"Hurts little more", @"4-5 on painscale")),
                             (NSLocalizedString(@"Hurts even more", @"6-7 on painscale")),
                             (NSLocalizedString(@"Hurts whole lot", @"8-9 on painscale")),
                             (NSLocalizedString(@"Hurts worst", @"10 on painscale"))
                             ];
    
    //Set up flaccScaleView properties
    self.btnPressedColor = [UIColor colorWithRed:137.0/255.0 green:76.0/255.0 blue:137.0/255.0 alpha:1.0];
    self.painScoreLabel.text = NSLocalizedString(@"Painscore is: 0", nil);
    
    //Setting up general properties
    self.morphineInput.delegate = self;
    self.painScore = 0;
    
    [self initPainScale];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setButtonImageHighlight];
}

#pragma mark - Methods related specific to FLACC scale

- (IBAction)flaccTableButtonSelected:(id)sender {
    UIButton *selectedButton = sender;
    self.painScore = 0;
    if(!selectedButton.backgroundColor){
        selectedButton.backgroundColor = self.btnPressedColor;
        selectedButton.alpha = 0.4;
    }
    else{
        selectedButton.backgroundColor = nil;
    }
    if([self.faceButtons containsObject:selectedButton]){
        for(UIButton *btnInSelectedRow in self.faceButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    else if([self.legsButtons containsObject:selectedButton]){
        for(UIButton *btnInSelectedRow in self.legsButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    else if([self.activityButtons containsObject:selectedButton]){
        for(UIButton *btnInSelectedRow in self.activityButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    else if([self.cryingButtons containsObject:selectedButton]){
        for(UIButton *btnInSelectedRow in self.cryingButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    else if([self.comfortButtons containsObject:selectedButton]){
        for(UIButton *btnInSelectedRow in self.comfortButtons){
            if(selectedButton != btnInSelectedRow){
                btnInSelectedRow.backgroundColor = nil;
            }
        }
    }
    for (UIButton *button in self.allButtons) {
        if (button.backgroundColor) {
            self.painScore = self.painScore + button.tag;
        }
    }
    self.painScoreLabel.text = [NSLocalizedString(@"The painscore is: ", @"Sets text on flacc scale when score changes") stringByAppendingString:[NSString stringWithFormat:@"%d", (int)self.painScore]];
}

#pragma mark - Method related to camera

-(IBAction)useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}

#pragma mark - Method related to UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.morphineInput isFirstResponder] && [touch view] != self.morphineInput) {
        [self.morphineInput resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Methods related to UISlider

-(void)sliderPainNumberChanged:(UISlider *)sender {
    NSUInteger index = (NSUInteger)(self.sliderPainNumber.value+0.5);
    [self.sliderPainNumber setValue:index animated:NO];
    self.painScore = index;
    [self syncImagesWithSlider];
}

- (IBAction)painTypeSelected:(id)sender {
    UISegmentedControl *control = sender;
    if([control selectedSegmentIndex]==0){
        self.painType = @"Mouth";
    }
    else if([control selectedSegmentIndex]==1){
        self.painType = @"Stomach";
    }
    else if([control selectedSegmentIndex]==2){
        self.painType = @"Other";
    }
}

#pragma mark - Navigation

- (IBAction)unwindToPainScale:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if([sourceViewController isKindOfClass:[RTPainDrawViewController class]]){
        
        RTPainDrawViewController *controller = segue.sourceViewController;
        if (controller.mainImage.image)
        {
            UIGraphicsBeginImageContextWithOptions(controller.mainImage.bounds.size, NO,0.0);
            [controller.mainImage.image drawInRect:CGRectMake(0, 0, controller.mainImage.frame.size.width, controller.mainImage.frame.size.height)];
            self.drawingToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"smileyTable"])
    {
        RTSmileyTableViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        
        self.smileyTablePopover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.smileyTablePopover.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"changePainScale"]){
        RTChangepainScaleTableViewController *controller = [segue destinationViewController];
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
        controller.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"infoSegue"]){
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
}

#pragma mark - Convenience methods

-(void)resetView{
    //reset general properties
    self.morphineInput.text = @"";
    self.drawingToBeSaved = nil;
    self.cameraImageToBeSaved = nil;
    self.switchParmol.on = NO;
    self.painScore = 0;
    self.painType = nil;
    
    //Reset properties connected to smileyView
    self.sliderPainNumber.value = 0.0;
    self.lblPainNumber.text = @"0";
    self.painTypeSelectorSmiley.selectedSegmentIndex = -1;
    
    //Reset properties connected to flaccView
    for(UIButton *button in self.allButtons){
        button.backgroundColor = nil;
    }
    self.painTypeSelectorFlacc.selectedSegmentIndex = -1;
    self.painScoreLabel.text = NSLocalizedString(@"Painscore is: 0", nil);;
    [self syncImagesWithSlider];
}

-(void)syncImagesWithSlider{
    int painNumber = (int)self.sliderPainNumber.value;
    self.lblPainNumber.text = [[NSNumber numberWithInt:painNumber] stringValue];
    if (painNumber == 0)
    {
        self.lblPainDescription.text = self.painDescription[0];
        if(self.dataManagement.painScaleBieri){
            self.imageSmiley.image = [UIImage imageNamed:@"bieriSmileyA"];
            [self.painTypeSelectorSmiley setTintColor:[UIColor blackColor]];
        }
        else if (self.dataManagement.painScaleWongBaker){
            self.imageSmiley.image = [UIImage imageNamed:@"smileyA"];
            [self.painTypeSelectorSmiley setTintColor:[UIColor colorWithRed:31.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]];
        }
    }
    else if (painNumber % 2 == 0)
    {
        painNumber = painNumber-1;
    }
    
    if (painNumber % 2 == 1)
    {
        int smileyIndex = (painNumber+1)/2;
        self.lblPainDescription.text = self.painDescription[smileyIndex];
        NSString *imageName;
        if(self.dataManagement.painScaleBieri){
            imageName = [@"bieriSmiley" stringByAppendingString:self.smileys[smileyIndex]];
            [self.painTypeSelectorSmiley setTintColor:[UIColor blackColor]];
        }
        else if (self.dataManagement.painScaleWongBaker){
            imageName = [@"smiley" stringByAppendingString:self.smileys[smileyIndex]];
            [self.painTypeSelectorSmiley setTintColor:[UIColor colorWithRed:31.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]];
        }
        self.imageSmiley.image = [UIImage imageNamed:imageName];
    }
    [self setButtonImageHighlight];
}

-(void)setButtonImageHighlight{
    if (self.drawingToBeSaved != nil)
    {
        [self.btnDrawPain setImage:[UIImage imageNamed:@"btnPainDrawComplete.png"] forState:UIControlStateNormal];
    } else {
        [self.btnDrawPain setImage:[UIImage imageNamed:@"btnPainDraw.png"] forState:UIControlStateNormal];
    }
    if (self.cameraImageToBeSaved != nil) {
        [self.btnPhoto setImage:[UIImage imageNamed:@"btnPainPhotoComplete.png"] forState:UIControlStateNormal];
    }
    else {
        [self.btnPhoto setImage:[UIImage imageNamed:@"btnPainPhoto.png"] forState:UIControlStateNormal];
    }
}

-(void)initPainScale
{
    if(self.dataManagement.painScaleBieri || self.dataManagement.painScaleWongBaker){
        self.smileyScaleView.hidden = NO;
        self.flaccScaleView.hidden = YES;
        [self syncImagesWithSlider];
    }
    else{
        self.smileyScaleView.hidden = YES;
        self.flaccScaleView.hidden = NO;
    }
}

-(void)initSliderPainNumber
{
    self.numberScale = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10)];
    NSInteger numberOfSteps = ((float)[self.numberScale count]-1);
    self.sliderPainNumber.maximumValue =numberOfSteps;
    self.sliderPainNumber.minimumValue = 0;
    
    self.sliderPainNumber.continuous = YES;
    [self.sliderPainNumber addTarget:self action:@selector(sliderPainNumberChanged:) forControlEvents:UIControlEventValueChanged];
    self.sliderPainNumber.value=0;
}

-(NSString*)morphineTypeToText
{
    NSString* mType = @"Unknown type";
    if (self.morphineType.selectedSegmentIndex == 0)
        mType = @"mg";
    if (self.morphineType.selectedSegmentIndex == 1)
        mType = @"mg/L";
    
    return mType;
}

#pragma mark - PList methods

- (IBAction)submitAndCheckData:(id)sender {
    if(self.painType){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *idString = [[[self.dataManagement readFromPlist]objectForKey:@"dataID"]stringByAppendingString:[dateFormatter stringFromDate:currentDate]];
        NSString *currentTime = [dateFormatter stringFromDate:currentDate];
        NSString *drawingImagePath = [[NSString alloc]init];
        NSString *photoPath = [[NSString alloc]init];
        
        if (self.drawingToBeSaved)
        {
            drawingImagePath = [currentTime stringByAppendingString:@" DrawingImage.png"];
            NSLog(@"%@",drawingImagePath);
            [self.dataManagement UIImageWriteToFile:self.drawingToBeSaved :drawingImagePath];
        }
        if (self.cameraImageToBeSaved)
        {
            photoPath = [currentTime stringByAppendingString:@" CameraImage.jpg"];
            NSLog(@"%@",photoPath);
            [self.dataManagement UIImageWriteToFile:self.cameraImageToBeSaved :photoPath];
        }
        [self saveToPlist:drawingImagePath :photoPath :currentTime :idString];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No paintype selected", @"Title for no paintype selected alert")
                                                        message:NSLocalizedString(@"You need to select a paintype before you can save!", @"Shown when no paintype is selected")
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
}

-(void)saveToPlist:(NSString *)drawingImagePath :(NSString *)photoPath :(NSString *)currentTime :(NSString*)idString{
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    [dataToBeSaved setObject:idString forKey:@"id"];
    [dataToBeSaved setObject:[NSString stringWithFormat:@"%d",(int)self.painScore]forKey:@"painlevel"];
    [dataToBeSaved setObject:drawingImagePath forKey:@"drawingpath"];
    [dataToBeSaved setObject:photoPath forKey:@"photopath"];
    [dataToBeSaved setObject:self.morphineInput.text forKey:@"morphinelevel"];
    [dataToBeSaved setObject:[self morphineTypeToText] forKey:@"morphineType"];
    [dataToBeSaved setObject:currentTime forKey:@"time"];
    [dataToBeSaved setObject:self.painType forKey:@"paintype"];
    [dataToBeSaved setObject:[NSNumber numberWithBool:self.switchParmol.on] forKey:@"paracetamol"];
    [self.dataManagement.painData addObject:dataToBeSaved];
    [self.dataManagement writeToPList];
    
    for (NSString *str in self.dataManagement.painData) {
        NSLog(@"%@",str);
    }
    NSLog(@"Entries: %lu",(unsigned long)self.dataManagement.painData.count);
    
    NSString *message = NSLocalizedString(@"Your data is saved..", @"Shown when data is saved") ;
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Saving", @"Title on saving alertview")
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 0.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
    [self resetView];
}


//FEATURE REMOVED BY CUSTOMER REQUEST
//- (IBAction)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 100)
//    {
//        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Draw"])
//        {
//            RTPainDrawViewController *drawViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"painDrawViewController"];
//            [self.navigationController pushViewController:drawViewController animated:YES];
//        }
//        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo"])
//        {
//            [self useCamera:self];
//        }
//        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No thank you, just save"])
//        {
//            NSDate *currentDate = [NSDate date];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//            NSString *currentTime = [dateFormatter stringFromDate:currentDate];
//            [self saveToPlist:@"" :@"" :currentTime];
//        }
//    }
//}

#pragma mark - UITextField delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - RTChangePainScalePopoverDelegate method

-(void)didSelectPainScale{
    [self.popover dismissPopoverAnimated:YES];
    [self initPainScale];
}

#pragma mark - RTSmileyTable Delegate

-(void)didSelectSmiley:(NSInteger)smiley
{
    [self.smileyTablePopover dismissPopoverAnimated:YES];
    [self.sliderPainNumber setValue:(float)smiley];
    [self syncImagesWithSlider];
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES  completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.cameraImageToBeSaved = image;
        
        if (_newMedia) UIImageWriteToSavedPhotosAlbum(image,
                                                      self,
                                                      @selector(image:finishedSavingWithError:contextInfo:),
                                                      nil);
    }
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Save failed", @"Title on saving image alert")
                              message:NSLocalizedString(@"Failed to save image", @"Shown when saving image fails")
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
