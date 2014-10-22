//
//  RTPainInfoViewController.h
//  Leukemia App
//
//  Created by DMU-24 on 22/10/14.
//  Copyright (c) 2014 DMU-24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTDataManagement.h"

@interface RTPainInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *painInformation;
@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;
@property (strong,nonatomic) RTDataManagement *dataMangement;
@end
