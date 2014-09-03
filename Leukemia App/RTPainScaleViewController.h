//
//  RTPainScaleViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 18/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTPainDrawViewController.h"
#import "RTDataManagement.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface RTPainScaleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageSmiley;
@property (weak, nonatomic) IBOutlet UILabel *lblPainDescription;
@property (weak, nonatomic) IBOutlet UISlider *sliderPainNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPainNumber;
@property (weak, nonatomic) IBOutlet UITextField *morphineInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *painTypeSelector;


@property (strong,nonatomic) NSArray* smileys;
@property (strong,nonatomic) NSArray* numberScale;
@property (strong,nonatomic) NSArray* painDescription;

@property (strong,nonatomic) UIImage *drawingToBeSaved;
@property (strong,nonatomic) UIImage *cameraImageToBeSaved;

@property(strong,nonatomic) NSString *painType;


@property (strong, nonatomic) RTDataManagement *dataManagement;

@property BOOL newMedia;

- (IBAction)useCamera:(id)sender;
- (IBAction)submitAndSaveData:(id)sender;
- (IBAction)painTypeSelcected:(id)sender;


@end
