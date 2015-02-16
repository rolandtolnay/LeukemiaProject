//
//  RTMouthDrawViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 09/02/15.
//  Copyright (c) 2015 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTMouthDrawViewController : UIViewController <UIActionSheetDelegate,UIPopoverControllerDelegate>

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
@property (weak, nonatomic) IBOutlet UIView *mouthDrawView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *drawImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSaveImage;

- (IBAction)colorPressed:(id)sender;
- (IBAction)resetDrawing:(id)sender;

@end
