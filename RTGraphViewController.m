//
//  RTGraphViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 25/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphViewController.h"

@interface RTGraphViewController ()

@property RTDataManagement* data;

-(NSArray*) painLevels;
-(NSArray*) timeStamps;

@end

@implementation RTGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [RTDataManagement singleton];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    self.graph.valueLabelCount = 6;
    self.graph.startFromZero = YES;
    
    [self.graph draw];
    
}

#pragma mark - Graph Data Init

- (NSArray*) painLevels {
    NSMutableArray *painLevels = [[NSMutableArray alloc] init];
    for (NSDictionary *painRegistration in self.data.painData)
    {
        NSNumber *painLevel = [NSNumber numberWithInt:[[painRegistration objectForKey:@"painlevel"] intValue]];
        [painLevels addObject:painLevel];
    }
    return [painLevels copy];
}

-(NSArray *)timeStampsAtDay {
    NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
    for (NSDictionary *painRegistration in self.data.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        NSString *hour = [timeStamp componentsSeparatedByString:@" "][1];
        [timeStamps addObject:hour];
    }
    return [timeStamps copy];
}

#pragma mark - GKLineGraphDataSource


- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self painLevels];
}

- (NSInteger)numberOfLines {
    return 1;
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    return [UIColor gk_turquoiseColor];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return 1.0;
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [[self timeStamps] objectAtIndex:index];
}


@end
