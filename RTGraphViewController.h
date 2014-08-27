//
//  RTGraphViewController.h
//  Leukemia App
//
//  Created by dmu-23 on 25/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTDataManagement.h"
#import "GraphKit.h"

@interface RTGraphViewController : UIViewController <GKLineGraphDataSource>


@property (weak, nonatomic) IBOutlet GKLineGraph *graph;



@end
