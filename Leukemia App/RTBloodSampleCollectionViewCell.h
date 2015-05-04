//
//  RTBloodSampleCollectionViewCell.h
//  Leukemia App
//
//  Created by dmu-23 on 06/02/15.
//  Copyright (c) 2015 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTBloodSampleCollectionViewCell : UICollectionViewCell

//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bloodSampleLabels;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMTX;
@property (weak, nonatomic) IBOutlet UILabel *lbl6MP;
@property (weak, nonatomic) IBOutlet UILabel *lblHemoglobin;
@property (weak, nonatomic) IBOutlet UILabel *lblThromboCyt;
@property (weak, nonatomic) IBOutlet UILabel *lblLeukocyt;
@property (weak, nonatomic) IBOutlet UILabel *lblNeutrofile;
@property (weak, nonatomic) IBOutlet UILabel *lblCrp;
@property (weak, nonatomic) IBOutlet UILabel *lblAlat;

@end
