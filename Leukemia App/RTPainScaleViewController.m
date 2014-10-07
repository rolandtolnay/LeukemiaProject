//
//  RTPainScaleViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 18/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTPainScaleViewController.h"

@interface RTPainScaleViewController ()

@end

@implementation RTPainScaleViewController

- (void)viewDidLoad
{
    self.dataManagement = [RTDataManagement singleton];
    
    [self initSliderPainNumber];
    
    self.smileys = @[@("A"),@("B"),@("C"),@("D"),@("E"),@("F")];
    self.painDescription = @[
                             @("No hurt"),
                             @("Hurts little bit"),
                             @("Hurts little more"),
                             @("Hurts even more"),
                             @("Hurts whole lot"),
                             @("Hurts worst")
                             ];
    
    self.morphineInput.delegate = self;
    
    [self initImages];
    
    [super viewDidLoad];
}

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

-(void)viewWillAppear:(BOOL)animated
{
    [self setButtonImageHighlight];
}

#pragma mark - #pragma mark UIImagePickerControllerDelegate

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

-(void) image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Save failed"
                              message:@"Failed to save image"
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.morphineInput isFirstResponder] && [touch view] != self.morphineInput) {
        [self.morphineInput resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
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

-(void)sliderPainNumberChanged:(UISlider *)sender {
    NSUInteger index = (NSUInteger)(self.sliderPainNumber.value+0.5);
    [self.sliderPainNumber setValue:index animated:NO];
    NSNumber *painNumber = self.numberScale[index];
    self.lblPainNumber.text = [painNumber stringValue];
    
    [self initImages];
    
//    if ([painNumber intValue] == 0)
//    {
//        self.lblPainDescription.text = self.painDescription[0];
//        if(self.dataManagement.painScaleBieri){
//            self.imageSmiley.image = [UIImage imageNamed:@"bieriSmileyA"];
//        }
//        else{
//            self.imageSmiley.image = [UIImage imageNamed:@"smileyA"];
//        }
//    }
//    else if ([painNumber intValue] % 2 == 0)
//    {
//        painNumber = @([painNumber intValue]-1);
//    }
//    
//    if ([painNumber intValue] % 2 == 1)
//    {
//        int smileyIndex = ([painNumber intValue]+1)/2;
//        self.lblPainDescription.text = self.painDescription[smileyIndex];
//        NSString *imageName;
//        if(self.dataManagement.painScaleBieri){
//            imageName = [@"bieriSmiley" stringByAppendingString:self.smileys[smileyIndex]];
//        }
//        else{
//            imageName = [@"smiley" stringByAppendingString:self.smileys[smileyIndex]];
//        }
//        self.imageSmiley.image = [UIImage imageNamed:imageName];
//    }
}

//Saving and reading images
- (IBAction)unwindToPainScale:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if([sourceViewController isKindOfClass:[RTPainDrawViewController class]]){
       
        RTPainDrawViewController *controller = segue.sourceViewController;
//        if (controller.drawImage.image)
//        {
//            UIGraphicsBeginImageContextWithOptions(controller.drawImage.bounds.size, NO,0.0);
//            [controller.drawImage.image drawInRect:CGRectMake(0, 0, controller.drawImage.frame.size.width, controller.drawImage.frame.size.height)];
//            self.drawingToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }
        if (controller.mainImage.image)
        {
            UIGraphicsBeginImageContextWithOptions(controller.mainImage.bounds.size, NO,0.0);
            [controller.mainImage.image drawInRect:CGRectMake(0, 0, controller.mainImage.frame.size.width, controller.mainImage.frame.size.height)];
            self.drawingToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
}

//Method that saves images and data to pList
- (IBAction)submitAndSaveData:(id)sender {
    
    if(self.painTypeSelector.selectedSegmentIndex != -1){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSString *currentTime = [dateFormatter stringFromDate:currentDate];
        
        NSString *drawingImagePath = [[NSString alloc]init];
        NSString *photoPath = [[NSString alloc]init];
        
        //Checks if there is a drawing/photo to be saved, and if there is, creates drawing/photo path
        if (!self.drawingToBeSaved && !self.cameraImageToBeSaved)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add extra features"
                                                            message:@"For a more precise diagnostic consider using the Draw and Photo features."
                                                           delegate:self
                                                  cancelButtonTitle:@"No thank you, just save"
                                                  otherButtonTitles:@"Draw",@"Photo",nil];
            [alert show];
            alert.tag = 100;
        }
        else
        {
            NSDateFormatter *photoTimeFormatter = [[NSDateFormatter alloc] init];
            [photoTimeFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *photoTime = [photoTimeFormatter stringFromDate:currentDate];
            if (self.drawingToBeSaved)
            {
                drawingImagePath = [photoTime stringByAppendingString:@" DrawingImage.png"];
                NSLog(@"%@",drawingImagePath);
                [self.dataManagement UIImageWriteToFile:self.drawingToBeSaved :drawingImagePath];
            }
            if (self.cameraImageToBeSaved)
            {
                photoPath = [photoTime stringByAppendingString:@" CameraImage.jpg"];
                NSLog(@"%@",photoPath);
                [self.dataManagement UIImageWriteToFile:self.cameraImageToBeSaved :photoPath];
            }
            [self saveToPlist:drawingImagePath :photoPath :currentTime];
            NSLog(@"%@",self.dataManagement.painData);
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No paintype selected"
                                                        message:@"You need to select a paintype before you can save!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (IBAction)painTypeSelected:(id)sender {
    self.painType = [self.painTypeSelector titleForSegmentAtIndex:self.painTypeSelector.selectedSegmentIndex];
    NSLog(@"%@",self.painType);
}

- (IBAction)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Draw"])
        {
            RTPainDrawViewController *drawViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"painDrawViewController"];
            [self.navigationController pushViewController:drawViewController animated:YES];
        }
        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo"])
        {
            [self useCamera:self];
        }
        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No thank you, just save"])
        {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            NSString *currentTime = [dateFormatter stringFromDate:currentDate];
            [self saveToPlist:@"" :@"" :currentTime];
        }
    }
}


-(void)resetView{
    self.sliderPainNumber.value = 0.0;
    self.lblPainNumber.text = @"0";
    self.morphineInput.text = @"";
    self.drawingToBeSaved = nil;
    self.cameraImageToBeSaved = nil;
    self.painTypeSelector.selectedSegmentIndex = -1;
    [self initImages];
}

//-(void)initImages{
//    if(self.dataManagement.painScaleBieri){
//        self.imageSmiley.image = [UIImage imageNamed:@"bieriSmileyA"];
//        [self.painTypeSelector setTintColor:[UIColor blackColor]];
//    }
//    else{
//        self.imageSmiley.image = [UIImage imageNamed:@"smileyA"];
//        [self.painTypeSelector setTintColor:[UIColor colorWithRed:31.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]];
//    }
//    self.lblPainDescription.text = self.painDescription[0];
//    [self setButtonImageHighlight];
//}

-(void)initImages{
    NSLog(@"initImages kaldt");
    int painNumber = (int)self.sliderPainNumber.value;
    if (painNumber == 0)
    {
        self.lblPainDescription.text = self.painDescription[0];
        if(self.dataManagement.painScaleBieri){
            self.imageSmiley.image = [UIImage imageNamed:@"bieriSmileyA"];
            [self.painTypeSelector setTintColor:[UIColor blackColor]];
        }
        else{
            self.imageSmiley.image = [UIImage imageNamed:@"smileyA"];
            [self.painTypeSelector setTintColor:[UIColor colorWithRed:31.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]];
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
            [self.painTypeSelector setTintColor:[UIColor blackColor]];
        }
        else{
            imageName = [@"smiley" stringByAppendingString:self.smileys[smileyIndex]];
            [self.painTypeSelector setTintColor:[UIColor colorWithRed:31.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]];
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

-(void)saveToPlist:(NSString *)drawingImagePath :(NSString *)photoPath :(NSString *)currentTime{
    NSMutableDictionary *dataToBeSaved = [[NSMutableDictionary alloc]init];
    [dataToBeSaved setObject:self.lblPainNumber.text forKey:@"painlevel"];
    [dataToBeSaved setObject:drawingImagePath forKey:@"drawingpath"];
    [dataToBeSaved setObject:photoPath forKey:@"photopath"];
    [dataToBeSaved setObject:self.morphineInput.text forKey:@"morphinelevel"];
    [dataToBeSaved setObject:currentTime forKey:@"time"];
    [dataToBeSaved setObject:self.painType forKey:@"paintype"];
    [self.dataManagement.painData addObject:dataToBeSaved];
    [self.dataManagement writeToPList];
    
    for (NSString *str in self.dataManagement.painData) {
        NSLog(@"%@",str);
    }
    NSLog(@"Entries: %lu",(unsigned long)self.dataManagement.painData.count);
    
    NSString *message = @"Your data is saved..";
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:@"Saving"
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
@end
