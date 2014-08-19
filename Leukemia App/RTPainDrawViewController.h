//
//  RTFirstViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 15/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTPainDrawViewController : UIViewController <UIActionSheetDelegate>

@property CGPoint lastPoint;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat brush;
@property CGFloat opacity;
@property BOOL mouseWiped;
@property (weak, nonatomic) IBOutlet UIView *drawingView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *drawImage;

- (IBAction)colorPressed:(id)sender;
- (IBAction)resetDrawing:(id)sender;

@end
