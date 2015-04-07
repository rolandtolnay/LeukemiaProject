//
//  RTDiaryDetailViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 15/09/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTDiaryDetailViewController.h"
#import "RTDataManagement.h"

@interface RTDiaryDetailViewController ()

@end

@implementation RTDiaryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    //[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = self.selectedData.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.labelDate setText:[NSString stringWithFormat:NSLocalizedString(@"Date: %@", nil),[dateFormat stringFromDate:date]]];
    NSInteger painLevel = self.selectedData.painLevel;
    [self.labelPainLevel setText:[NSString stringWithFormat:NSLocalizedString(@"Pain level: %@", nil),[@(painLevel) stringValue]]];
    NSString *painType = self.selectedData.painType;
    [self.labelPainType setText:[NSString stringWithFormat:NSLocalizedString(@"Pain type: %@", nil),painType]];
    NSInteger morphine = self.selectedData.morphineLevel;
    NSString *morphineUnit = self.selectedData.morphineType;
    if ([[@(morphine) stringValue] isEqualToString:@""])
        [self.labelMorphine setText: NSLocalizedString(@"Morphine: -", nil)];
    else
        [self.labelMorphine setText:[NSString stringWithFormat:NSLocalizedString(@"Morphine: %@ %@", nil),[@(morphine) stringValue],morphineUnit]];
    
    BOOL paracetamol = self.selectedData.paracetamol;
    if (paracetamol)
    {
        [self.labelParacetamol setText: NSLocalizedString( @"Paracetamol: Yes", nil)];
    } else
        [self.labelParacetamol setText:NSLocalizedString(@"Paracetamol: No", nil)];
    
    NSString *drawingImagePath = self.selectedData.drawingPath;
    if (![drawingImagePath isEqualToString:@""])
    {
        UIImage *drawing;
        [[RTService singleton] UIImageReadFromFile:&drawing :drawingImagePath];
        
        [self.imageDrawing setImage:drawing];
        self.labelNoDrawing.hidden = YES;
    }
    
    NSString *cameraPhotoPath = self.selectedData.photoPath;
    if (![cameraPhotoPath isEqualToString:@""])
    {
        UIImage *photo;
        [[RTService singleton] UIImageReadFromFile:&photo :cameraPhotoPath];
        UIImage *imageToBeShown = [UIImage imageWithCGImage:[photo CGImage]
                                                      scale:1.0
                                                orientation: UIImageOrientationRight];
        
        [self.imagePhoto setImage:imageToBeShown];
        self.labelNoPhoto.hidden = YES;
    }
    
}

@end
