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
#import "RTChangepainScaleTableViewController.h"
#import "RTSmileyTableViewController.h"
#import "RTPainInfoViewController.h"
#import "RTPainData.h"

@interface RTPainScaleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, RTSmileyTableDelegate,RTChangePainScalePopoverDelegate, UIPopoverControllerDelegate>

//Views that contains the to types of pain scales
@property (weak, nonatomic) IBOutlet UIView *smileyScaleView;
@property (weak, nonatomic) IBOutlet UIView *flaccScaleView;

//Properties connected to smileyScaleView
@property (weak, nonatomic) IBOutlet UIImageView *imageSmiley;
@property (weak, nonatomic) IBOutlet UILabel *lblPainDescription;
@property (weak, nonatomic) IBOutlet UISlider *sliderPainNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblPainNumber;
@property (weak, nonatomic) IBOutlet UISegmentedControl *painTypeSelectorSmiley;
@property (strong,nonatomic) NSArray* smileys;
@property (strong,nonatomic) NSArray* numberScale;
@property (strong,nonatomic) NSArray* painDescription;

//Properties connected to flaccScaleView
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *comfortButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cryingButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *activityButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *legsButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *faceButtons;
@property (weak, nonatomic) IBOutlet UILabel *painScoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *painTypeSelectorFlacc;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (strong,nonatomic) UIColor *btnPressedColor;

//General properties
@property (weak, nonatomic) IBOutlet UISwitch *switchParmol;
@property (weak, nonatomic) IBOutlet UITextField *morphineInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *morphineType;
@property (weak, nonatomic) IBOutlet UIButton *btnDrawPain;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (strong,nonatomic) UIImage *drawingToBeSaved;
@property (strong,nonatomic) UIImage *cameraImageToBeSaved;
@property(strong,nonatomic) NSString *painType;
@property (strong, nonatomic) RTDataManagement *dataManagement;
@property BOOL newMedia;
@property (nonatomic) NSInteger painScore;

//Public methods
-(IBAction)useCamera:(id)sender;
-(IBAction)submitAndCheckData:(id)sender;
-(IBAction)painTypeSelected:(id)sender;
-(IBAction)flaccTableButtonSelected:(id)sender;
-(void)syncImagesWithSlider;
-(void)setButtonImageHighlight;
-(void)sliderPainNumberChanged:(UISlider *)sender;



@end
