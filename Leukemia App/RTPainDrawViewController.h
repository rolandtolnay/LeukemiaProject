//
//  RTFirstViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSettingsViewController.h"

@interface RTPainDrawViewController : UIViewController <UIActionSheetDelegate,UIPopoverControllerDelegate>

@property CGPoint lastPoint;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat brush;
@property CGFloat opacity;

@property BOOL mouseWiped;
@property BOOL actualColor;

@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet UIButton *yelBtn;
@property (weak, nonatomic) IBOutlet UIButton *greenBtn;

@property (weak, nonatomic) IBOutlet UIView *drawingView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *drawImage;
@property (weak, nonatomic) IBOutlet UITextView *painDescriptionTxtField;
@property (weak, nonatomic) IBOutlet UIImageView *btnPreview;

@property (strong,nonatomic) NSString* redDescription;
@property (strong,nonatomic) NSString* yellowDescription;
@property (strong,nonatomic) NSString* greenDescription;


- (IBAction)colorPressed:(id)sender;
- (IBAction)resetDrawing:(id)sender;


@end
