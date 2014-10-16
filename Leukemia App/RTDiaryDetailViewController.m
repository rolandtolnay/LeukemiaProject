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

@property RTDataManagement *service;

@end

@implementation RTDiaryDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.service = [RTDataManagement singleton];
    
    NSString *date = [self.selectedData objectForKey:@"time"];
    [self.labelDate setText:[NSString stringWithFormat:NSLocalizedString(@"Date: %@", nil),date]];
    NSString *painLevel = [self.selectedData objectForKey:@"painlevel"];
    [self.labelPainLevel setText:[NSString stringWithFormat:NSLocalizedString(@"Pain level: %@", nil),painLevel]];
    NSString *painType = [self.selectedData objectForKey:@"paintype"];
    [self.labelPainType setText:[NSString stringWithFormat:NSLocalizedString(@"Pain type: %@", nil),painType]];
    
    NSString *morphine = [self.selectedData objectForKey:@"morphinelevel"];
    if ([morphine isEqualToString:@""])
        [self.labelMorphine setText: NSLocalizedString(@"Morphine: -", nil)];
    else
        [self.labelMorphine setText:[NSString stringWithFormat:NSLocalizedString(@"Morphine: %@ mg", nil),morphine]];
    
    NSString *paracetamol = [self.selectedData objectForKey:@"paracetamol"];
    if ([paracetamol intValue] == 1)
    {
        [self.labelParacetamol setText: NSLocalizedString( @"Paracetamol: Yes", nil)];
    } else
        [self.labelParacetamol setText:NSLocalizedString(@"Paracetamol: No", nil)];
    
    NSString *drawingImagePath = [self.selectedData objectForKey:@"drawingpath"];
    if (![drawingImagePath isEqualToString:@""])
    {
        UIImage *drawing;
        [self.service UIImageReadFromFile:&drawing :drawingImagePath];
        
        [self.imageDrawing setImage:drawing];
        self.labelNoDrawing.hidden = YES;
    }
    
    NSString *cameraPhotoPath = [self.selectedData objectForKey:@"photopath"];
    if (![cameraPhotoPath isEqualToString:@""])
    {
        UIImage *photo;
        [self.service UIImageReadFromFile:&photo :cameraPhotoPath];
        UIImage *imageToBeShown = [UIImage imageWithCGImage:[photo CGImage]
                                                      scale:1.0
                                                orientation: UIImageOrientationRight];
        
        [self.imagePhoto setImage:imageToBeShown];
        self.labelNoPhoto.hidden = YES;
//        self.imagePhoto.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        self.imagePhoto.contentMode = UIViewContentModeScaleAspectFit;
    }
    
}

@end
