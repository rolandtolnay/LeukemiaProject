//
//  RTGraphViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 25/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphViewController.h"

@interface RTGraphViewController ()

@property RTDataManagement* dataManagement;

@property (strong, nonatomic) NSArray* painValues;
@property (strong, nonatomic) NSMutableArray* weightTimestamps;
@property (strong, nonatomic) NSMutableArray* weightValues;

@property UIColor *colorStomachPain;
@property UIColor *colorMouthPain;
@property UIColor *colorOtherPain;

@property UIPopoverController* popover;

-(void) showError:(BOOL) isHidden withText:(NSString*) errorText;

@end

@implementation RTGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblPainType.text = NSLocalizedString(@"Pain types:", nil);
    self.colorMouthPain = [UIColor gk_pomegranateColor];
    self.colorStomachPain = [UIColor gk_greenSeaColor];
    self.colorOtherPain = [UIColor gk_belizeHoleColor];
    
    self.weightTimestamps = [[NSMutableArray alloc] init];
    self.weightValues = [[NSMutableArray alloc]init];
    
    if ([self isRetinaDisplay])
    {
        self.dataManagement = [RTDataManagement singleton];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:currentDate];
        [self.datePicker setTitle:today forState:UIControlStateNormal];
        self.currentDate = currentDate;
        
        self.graph.dataSource = self;
        self.graph.lineWidth = 3.0;
        self.graph.valueLabelCount = 11;
        self.graph.startFromZero = YES;
        
        //        [self.lblMouthColor setTextColor:_colorMouthPain];
        //        [self.lblStomachColor setTextColor:_colorStomachPain];
        //        [self.lblOtherColor setTextColor:_colorOtherPain];
    }
    else
    {
        self.graph.hidden = YES;
        self.datePicker.hidden = YES;
        [self showError:YES withText:@"Graph feature only supported on devices with retina display."];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([self isRetinaDisplay])
        [self refreshGraph];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([self isRetinaDisplay])
        [self refreshGraph];
}

#pragma mark - BOOL's

-(BOOL)isRetinaDisplay{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return (screenScale == 2.0);
}

-(BOOL) isPainGraph{
    return (self.graphType.selectedSegmentIndex==0);
}

-(BOOL) isPainMouthGraph{
    return (self.painType.selectedSegmentIndex == 0);
}

-(BOOL) isPainStomachGraph {
    return (self.painType.selectedSegmentIndex == 1);
}

-(BOOL) isPainOtherGraph {
    return (self.painType.selectedSegmentIndex == 2);
}

-(BOOL) isPainAllGraph {
    return (self.painType.selectedSegmentIndex == 3);
}

-(BOOL) isWeightGraph{
    return (self.graphType.selectedSegmentIndex==1);
}

#pragma mark - Convenience methods

-(void)showError:(BOOL) isHidden withText:(NSString *)errorText {
    self.lblError.hidden = !isHidden;
    self.graph.hidden = isHidden;
    self.lblError.text = errorText;
    [self.lblError setCenter:self.view.center];
}

#pragma mark - Graph Data Display methods

-(void)refreshGraph {
    [self.graph reset];
    [self.view endEditing:YES];
    if ([self isPainGraph])
    {
        NSString* selectedDay = [self.datePicker titleForState:UIControlStateNormal];
        
        if ([self isPainAllGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay])
            {
                [self showError:NO withText:nil];
                self.painValues = @[
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:MouthPain],
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:StomachPain],
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:OtherPain],
                                    @[@1, @5, @10]
                                    ];
                [self.graph draw];
            }
            else
            {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
        } else if ([self isPainMouthGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay forPainType:MouthPain])
            {
                [self showError:NO withText:nil];
                self.painValues = @[
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:MouthPain],
                                    @[@1, @5, @10]
                                    ];
                [self.graph draw];
            } else {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
            
        } else if ([self isPainStomachGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay forPainType:StomachPain])
            {
                [self showError:NO withText:nil];
                self.painValues = @[
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:StomachPain],
                                    @[@1, @5, @10]
                                    ];
                [self.graph draw];
            } else {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
        } else if ([self isPainOtherGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay forPainType:OtherPain])
            {
                [self showError:NO withText:nil];
                self.painValues = @[
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:OtherPain],
                                    @[@1, @5, @10]
                                    ];
                [self.graph draw];
            } else {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
        }
    }
    if ([self isWeightGraph])
    {
        NSLog(@"Weight timestamps: %@",self.weightTimestamps);
        if ([self.weightTimestamps count] > 1)
        {
            [self showError:NO withText:nil];
            [self.graph draw];
        }
        else
        {
            [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
        }
    }
}

-(void)graphTypeChanged:(id)sender
{
    self.currentDate = [NSDate date];
    if ([self isPainGraph])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:self.currentDate];
        [self.datePicker setTitle:today forState:UIControlStateNormal];
        
        self.graph.startFromZero = YES;
        self.graph.valueLabelCount = 11;
        
        self.painType.hidden = NO;
        self.lblPainType.hidden = NO;
        [self.painType setSelectedSegmentIndex:3];
        [self refreshGraph];
    }
    if ([self isWeightGraph])
    {
        self.painType.hidden = YES;
        self.lblPainType.hidden = YES;
        self.graph.startFromZero = NO;
        [self weekSelected:[[RTDataManagement singleton] allDatesInWeek:[self.currentDate week] forYear:[self.currentDate year]]];
    }
}

-(void)painTypeChanged:(id)sender
{
    [self refreshGraph];
}

#pragma mark - Navigation

-(void)pickDate:(id)sender
{
    if ([self isPainGraph])
    {
        [self performSegueWithIdentifier:@"datePicker" sender:nil];
    } else if ([self isWeightGraph])
    {
        [self performSegueWithIdentifier:@"weekPicker" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"datePicker"]){
        RTGraphCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.pickedDate = self.currentDate;
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
    if([segue.identifier isEqualToString:@"weekPicker"]){
        RTGraphWeekPickerViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.pickedDate = self.currentDate;
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
    
}

#pragma mark - GKLineGraph DataSource

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    if ([self isPainGraph])
        return [self.painValues objectAtIndex:index];
    if ([self isWeightGraph])
        return self.weightValues;
    return nil;
}

- (NSInteger)numberOfLines {
    if ([self isPainGraph])
        return [self.painValues count];
    if ([self isWeightGraph])
        return 1;
    return 0;
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    if ([self isPainGraph])
    {
        if ([self isPainAllGraph])
        {
            id colors = @[ _colorMouthPain,
                           _colorStomachPain,
                           _colorOtherPain,
                           [UIColor clearColor]];
            return [colors objectAtIndex:index];
        } else if ([self isPainMouthGraph])
        {
            id colors = @[ _colorMouthPain,
                           [UIColor clearColor]];
            return [colors objectAtIndex:index];
        } else if ([self isPainStomachGraph])
        {
            id colors = @[ _colorStomachPain,
                           [UIColor clearColor]];
            return [colors objectAtIndex:index];
        } else if ([self isPainOtherGraph])
        {
            id colors = @[ _colorOtherPain,
                           [UIColor clearColor]];
            return [colors objectAtIndex:index];
        }
    }
    if ([self isWeightGraph])
    {
        return [UIColor gk_concreteColor];
    }
    return [UIColor clearColor];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return 1.0;
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    if ([self isPainGraph])
    {
        NSString* selectedDay = [self.datePicker titleForState:UIControlStateNormal];
        if ([self isPainAllGraph])
            return @"";
        if ([self isPainMouthGraph])
            return [[self.dataManagement timeStampsAtDay:selectedDay forPainType:MouthPain] objectAtIndex:index];
        if ([self isPainStomachGraph])
            return [[self.dataManagement timeStampsAtDay:selectedDay forPainType:StomachPain] objectAtIndex:index];
        if ([self isPainOtherGraph])
            return [[self.dataManagement timeStampsAtDay:selectedDay forPainType:OtherPain] objectAtIndex:index];
    }
    if ([self isWeightGraph])
    {
        return [self.weightTimestamps objectAtIndex:index];
    }
    return @"";
}

#pragma mark - CalendarPicker delegate

- (void)dateSelected:(NSDate *)date
{
    self.currentDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pickedDate = [dateFormatter stringFromDate:date];
    
    [self.datePicker setTitle:pickedDate forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    [self refreshGraph];
}

#pragma mark - WeekPicker delegate

-(void)weekSelected:(NSArray *)datesInWeek
{
    [self.popover dismissPopoverAnimated:YES];
    self.currentDate = datesInWeek[0];
    
    NSString *pickedWeek = [NSString stringWithFormat:NSLocalizedString(@"%d - Week %d", nil),[self.currentDate year],[self.currentDate week]];
    [self.datePicker setTitle:pickedWeek forState:UIControlStateNormal];
    
    [self.weightTimestamps removeAllObjects];
    [self.weightValues removeAllObjects];
    
    for (NSDate *dayInWeek in datesInWeek)
    {
        NSMutableDictionary *diaryReg = [self.dataManagement diaryDataAtDate:dayInWeek];
        
        if (diaryReg!=nil)
        {
            NSNumber *weight = [NSNumber numberWithFloat:[[diaryReg objectForKey:@"weight"] floatValue]];
            NSLog(@"Date: %@, diary registration: %@, weight: %@",dayInWeek,diaryReg,weight);
            if (![[diaryReg objectForKey:@"weight"] isEqualToString:@""] && [weight intValue]>0)
            {
                [self.weightValues addObject:weight];
                
                NSString *monthDayTimestamp = [NSString stringWithFormat:@"%d/%d",[dayInWeek day],[dayInWeek month]];
                NSLog(@"weightTimestamp: %@",monthDayTimestamp);
                
                [self.weightTimestamps addObject:monthDayTimestamp];
            }
        }
    }
    
    self.graph.valueLabelCount = 11;
    [self refreshGraph];
    
}

@end
