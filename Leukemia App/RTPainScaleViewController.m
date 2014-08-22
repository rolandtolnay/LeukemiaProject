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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	
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

#pragma mark - #pragma mark UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES  completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.cameraImageToBeSaved = image;
        
        _testImageView.image = image;
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
    
    if ([painNumber intValue] == 0)
    {
        self.lblPainDescription.text = self.painDescription[0];
        self.imageSmiley.image = [UIImage imageNamed:@"smileyA"];
    } else if ([painNumber intValue] % 2 == 0) painNumber = @([painNumber intValue]-1);
        
    if ([painNumber intValue] % 2 == 1)
    {
        int smileyIndex = ([painNumber intValue]+1)/2;
        
        self.lblPainDescription.text = self.painDescription[smileyIndex];
        NSString *imageName = [@"smiley" stringByAppendingString:self.smileys[smileyIndex]];
        self.imageSmiley.image = [UIImage imageNamed:imageName];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Saving and reading images
- (IBAction)unwindToPainScale:(UIStoryboardSegue *)segue
{
    UIViewController *sourceViewController = segue.sourceViewController;
    if([sourceViewController isKindOfClass:[RTPainDrawViewController class]]){
        RTPainDrawViewController *controller = segue.sourceViewController;
        if (controller.drawImage.image)
        {
            UIGraphicsBeginImageContextWithOptions(controller.drawImage.bounds.size, NO,0.0);
            [controller.drawImage.image drawInRect:CGRectMake(0, 0, controller.drawImage.frame.size.width, controller.drawImage.frame.size.height)];
            self.drawingToBeSaved = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        //[self UIImageWriteToFile:saveImage :@"test.png"];
    }
}

-(void) UIImageWriteToFile:(UIImage *)image :(NSString *)fileName
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = dirPaths[0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
}

-(void) UIImageReadFromFile:(UIImage **)image :(NSString *)fileName
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = dirPaths[0];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:fileName];
    
    *image = [UIImage imageWithContentsOfFile:filePath];
}

- (IBAction)testImage:(id)sender {
    UIImage *imageToshow;
    [self UIImageReadFromFile:&imageToshow :self.tempImageFileName];
    [self.testImageView setImage:imageToshow];
}

- (IBAction)submitAndSaveData:(id)sender {
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm"];
    NSString *currentDate = [dateFormatter stringFromDate:currentTime];
   
    if (!self.drawingToBeSaved && !self.cameraImageToBeSaved)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add extra features"
                                                        message:@"For a more precise diagnostic consider using the Draw and Photo features."
                                                       delegate:self
                                              cancelButtonTitle:@"No, thank you"
                                              otherButtonTitles:@"Draw",@"Photo",nil];
        [alert show];
        alert.tag = 100;
    } else
    {
        NSString *imageName;
        if (self.drawingToBeSaved)
        {
            imageName = [currentDate stringByAppendingString:@"DrawingImage.png"];
            NSLog(@"%@",imageName);
            self.tempImageFileName = imageName;
            [self UIImageWriteToFile:self.drawingToBeSaved :imageName];
            self.drawingToBeSaved = nil;
        }
        if (self.cameraImageToBeSaved)
        {
            imageName = [currentDate stringByAppendingString:@"CameraImage.jpg"];
            NSLog(@"%@",imageName);
            [self UIImageWriteToFile:self.cameraImageToBeSaved :imageName];
            self.cameraImageToBeSaved = nil;
        }
    }
    
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
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo"])
            [self useCamera:self];
            
    }
}
@end
