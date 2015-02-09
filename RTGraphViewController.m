//
//  RTGraphViewController.m
//  Leukemia App
//
//  Created by dmu-23 on 25/08/14.
//  Copyright (c) 2014 dmu-23. All rights reserved.
//

#import "RTGraphViewController.h"

static NSString *MouthPain = @"Mouth";
static NSString *StomachPain = @"Stomach";
static NSString *OtherPain = @"Other";

@interface RTGraphViewController ()

@property RTDataManagement* dataManagement;

@property SHLineGraphView *upperGraph;
@property SHLineGraphView *lowerGraph;

@property (strong, nonatomic) NSMutableArray* upperGraphValues;
@property (strong, nonatomic) NSMutableArray* upperGraphTimestamps;
@property (strong, nonatomic) NSMutableArray* weightTimestamps;
@property (strong, nonatomic) NSMutableArray* weightValues;

@property UIColor *colorStomachPain;
@property UIColor *colorMouthPain;
@property UIColor *colorOtherPain;

@property UIPopoverController* popover;

-(void) showError:(BOOL) isHidden withText:(NSString*) errorText;

@end

@implementation RTGraphViewController

-(NSMutableArray *)upperGraphValues{
    if(!_upperGraphValues){
        _upperGraphValues = [[NSMutableArray alloc]init];
    }
    return _upperGraphValues;
}

-(NSMutableArray *)upperGraphTimestamps{
    if(!_upperGraphTimestamps){
        _upperGraphTimestamps = [[NSMutableArray alloc]init];
    }
    return _upperGraphTimestamps;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblPainType.text = NSLocalizedString(@"Pain types:", nil);
    //    self.colorMouthPain = [UIColor gk_pomegranateColor];
    //    self.colorStomachPain = [UIColor gk_greenSeaColor];
    //    self.colorOtherPain = [UIColor gk_belizeHoleColor];
    
//    self.weightTimestamps = [[NSMutableArray alloc] init];
//    self.weightValues = [[NSMutableArray alloc]init];
//    self.upperGraphValues = [[NSMutableArray alloc] init];
//    self.upperGraphTimestamps = [[NSMutableArray alloc]init];

    self.dataManagement = [RTDataManagement singleton];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:currentDate];
    [self.datePicker setTitle:today forState:UIControlStateNormal];
    self.currentDate = currentDate;
    
    self.datePicker.hidden = YES;
   
    //    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initGraph];
    [super viewDidAppear:animated];
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if ([self isRetinaDisplay])
//        [self refreshGraph];
//}

-(void)initGraph
{
    self.upperGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(16, 109, 520, 380)];
    
    self.upperGraph.yAxisRange = @(98);
    self.upperGraph.xAxisValues = @[
                               @{ @1 : @"JAN" },
                               @{ @2 : @"FEB" },
                               @{ @3 : @"MAR" },
                               @{ @4 : @"APR" },
                               @{ @5 : @"MAY" },
                               @{ @6 : @"JUN" },
                               @{ @7 : @"JUL" },
                               @{ @8 : @"AUG" },
                               @{ @9 : @"SEP" },
                               @{ @10 : @"OCT" },
                               @{ @11 : @"NOV" },
                               @{ @12 : @"DEC" }
                               ];
    
    SHPlot *_plot1 = [[SHPlot alloc] init];
    //values for date
    _plot1.plottingValues = @[
                              @{ @1 : @65.8 },
                              @{ @2 : @20 },
                              @{ @3 : @23 },
                              @{ @4 : @22 },
                              @{ @5 : @12.3 },
                              @{ @6 : @45.8 },
                              @{ @7 : @56 },
                              @{ @8 : @90 },
                              @{ @9 : @65 },
                              @{ @10 : @10 },
                              @{ @11 : @67 },
                              @{ @12 : @23 }
                              ];
    [self.upperGraph addPlot:_plot1];
    [self.upperGraph setupTheView];
    
    [self.view addSubview:self.upperGraph];
    
    self.lowerGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(16, 546, 520, 380)];
    
    self.lowerGraph.yAxisRange = @(98);
    self.lowerGraph.xAxisValues = @[
                               @{ @1 : @"JAN" },
                               @{ @2 : @"FEB" },
                               @{ @3 : @"MAR" },
                               @{ @4 : @"APR" },
                               @{ @5 : @"MAY" },
                               @{ @6 : @"JUN" },
                               @{ @7 : @"JUL" },
                               @{ @8 : @"AUG" },
                               @{ @9 : @"SEP" },
                               @{ @10 : @"OCT" },
                               @{ @11 : @"NOV" },
                               @{ @12 : @"DEC" }
                               ];
    
    SHPlot *_plot2 = [[SHPlot alloc] init];
    _plot2.plottingValues = @[
                              @{ @1 : @65.8 },
                              @{ @2 : @20 },
                              @{ @3 : @23 },
                              @{ @4 : @22 },
                              @{ @5 : @12.3 },
                              @{ @6 : @45.8 },
                              @{ @7 : @56 },
                              @{ @8 : @97 },
                              @{ @9 : @65 },
                              @{ @10 : @10 },
                              @{ @11 : @67 },
                              @{ @12 : @23 }
                              ];
    [self.lowerGraph addPlot:_plot2];
    [self.lowerGraph setupTheView];
    
    [self.view addSubview:self.lowerGraph];
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
//    self.graph.hidden = isHidden;
    self.lblError.text = errorText;
    [self.lblError setCenter:self.view.center];
}

-(void) getWeightFromDateArray: (NSArray*) datesInWeek
{
    [self.weightTimestamps removeAllObjects];
    [self.weightValues removeAllObjects];
    
    for (NSDate *dayInWeek in datesInWeek)
    {
        NSMutableDictionary *diaryReg = [self.dataManagement diaryDataAtDate:dayInWeek];
        
        if (diaryReg!=nil)
        {
            NSNumber *weight = [NSNumber numberWithFloat:[[diaryReg objectForKey:@"weight"] floatValue]];
            if ([weight intValue]>0)
            {
                [self.weightValues addObject:weight];
                
                NSString *monthDayTimestamp = [NSString stringWithFormat:@"%d/%d",[dayInWeek day],[dayInWeek month]];
                
                [self.weightTimestamps addObject:monthDayTimestamp];
            }
        }
    }
    
}

#pragma mark - Graph Data Display methods

-(void)refreshGraph {
    [self.upperGraph removeFromSuperview];
    self.upperGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(16, 109, 520, 380)];
    [self.upperGraphValues removeAllObjects];
    [self.upperGraphTimestamps removeAllObjects];
    
    [self.view endEditing:YES];
    if ([self isPainGraph])
    {
        NSString* selectedDay = [self.datePicker titleForState:UIControlStateNormal];
        
        if ([self isPainAllGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay])
            {
                [self showError:NO withText:nil];

            }
            else
            {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
        } else if ([self isPainMouthGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay forPainType:MouthPain])
            {
                long count = [[self.dataManagement timeStampsAtDay:selectedDay forPainType:MouthPain] count];
                for (int i = 1; i<=count; i++) {
                    [self.upperGraphValues addObject: @{ [NSNumber numberWithInt:i] : [[self.dataManagement painLevelsAtDay:selectedDay forPainType:MouthPain] objectAtIndex:i-1]} ];
                    [self.upperGraphTimestamps addObject: @{ [NSNumber numberWithInt:i] : [[self.dataManagement timeStampsAtDay:selectedDay forPainType:MouthPain] objectAtIndex:i-1]} ];
                }
                self.upperGraph.yAxisRange = @(10);
                self.upperGraph.xAxisValues = self.upperGraphTimestamps;
                SHPlot *plot = [[SHPlot alloc]init];
                plot.plottingValues = self.upperGraphValues;
                [self.upperGraph addPlot:plot];
                [self.upperGraph setupTheView];
                
                [self.view addSubview:self.upperGraph];
                
                NSLog(@"values: %@",self.upperGraphValues);
                NSLog(@"timestamps: %@",self.upperGraphTimestamps);

            } else {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
            
        } else if ([self isPainStomachGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay forPainType:StomachPain])
            {
                [self showError:NO withText:nil];
                self.upperGraphValues = @[
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:StomachPain],
                                    @[@1, @5, @10]
                                    ];
//                [self.graph draw];
            } else {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
        } else if ([self isPainOtherGraph])
        {
            if ([self.dataManagement isEnoughDataAtDay:selectedDay forPainType:OtherPain])
            {
                [self showError:NO withText:nil];
                self.upperGraphValues = @[
                                    [self.dataManagement painLevelsAtDay:selectedDay forPainType:OtherPain],
                                    @[@1, @5, @10]
                                    ];
//                [self.graph draw];
            } else {
                [self showError:YES withText:NSLocalizedString(@"Not enough data to show graph.", nil)];
            }
        }
    }
    if ([self isWeightGraph])
    {
        [self getWeightFromDateArray:[[RTService singleton] allDatesInWeek:[self.currentDate week] forYear:[self.currentDate year]]];
        if ([self.weightTimestamps count] > 1)
        {
            [self showError:NO withText:nil];
//            [self.graph draw];
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
        
//        self.graph.startFromZero = YES;
//        self.graph.valueLabelCount = 11;
        
        self.painType.hidden = NO;
        self.lblPainType.hidden = NO;
        [self.painType setSelectedSegmentIndex:3];
        [self refreshGraph];
    }
    if ([self isWeightGraph])
    {
        self.painType.hidden = YES;
        self.lblPainType.hidden = YES;
//        self.graph.startFromZero = NO;
        [self weekSelected:[[RTService singleton] allDatesInWeek:[self.currentDate week] forYear:[self.currentDate year]]];
        //        [self refreshGraph];
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
        controller.markedDates = [self.dataManagement datesWithGraphFromDate:self.currentDate];
        
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

//- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
//    if ([self isPainGraph])
//        return [self.painValues objectAtIndex:index];
//    if ([self isWeightGraph])
//        return self.weightValues;
//    return nil;
//}
//
//- (NSInteger)numberOfLines {
//    if ([self isPainGraph])
//        return [self.painValues count];
//    if ([self isWeightGraph])
//        return 1;
//    return 0;
//}
//
//- (UIColor *)colorForLineAtIndex:(NSInteger)index {
//    if ([self isPainGraph])
//    {
//        if ([self isPainAllGraph])
//        {
//            id colors = @[ _colorMouthPain,
//                           _colorStomachPain,
//                           _colorOtherPain,
//                           [UIColor clearColor]];
//            return [colors objectAtIndex:index];
//        } else if ([self isPainMouthGraph])
//        {
//            id colors = @[ _colorMouthPain,
//                           [UIColor clearColor]];
//            return [colors objectAtIndex:index];
//        } else if ([self isPainStomachGraph])
//        {
//            id colors = @[ _colorStomachPain,
//                           [UIColor clearColor]];
//            return [colors objectAtIndex:index];
//        } else if ([self isPainOtherGraph])
//        {
//            id colors = @[ _colorOtherPain,
//                           [UIColor clearColor]];
//            return [colors objectAtIndex:index];
//        }
//    }
//    if ([self isWeightGraph])
//    {
//        return [UIColor gk_concreteColor];
//    }
//    return [UIColor clearColor];
//}
//
//- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
//    return 1.0;
//}
//
//- (NSString *)titleForLineAtIndex:(NSInteger)index {
//    if ([self isPainGraph])
//    {
//        NSString* selectedDay = [self.datePicker titleForState:UIControlStateNormal];
//        if ([self isPainAllGraph])
//            return @"";
//        if ([self isPainMouthGraph])
//            return [[self.dataManagement timeStampsAtDay:selectedDay forPainType:MouthPain] objectAtIndex:index];
//        if ([self isPainStomachGraph])
//            return [[self.dataManagement timeStampsAtDay:selectedDay forPainType:StomachPain] objectAtIndex:index];
//        if ([self isPainOtherGraph])
//            return [[self.dataManagement timeStampsAtDay:selectedDay forPainType:OtherPain] objectAtIndex:index];
//    }
//    if ([self isWeightGraph])
//    {
//        return [self.weightTimestamps objectAtIndex:index];
//    }
//    return @"";
//}



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

-(NSArray*)monthChanged:(NSInteger)month
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthString = [@(month) stringValue];
    NSDate *newDate = [dateFormatter dateFromString:monthString];
    
    return [self.dataManagement datesWithGraphFromDate:newDate];
}

#pragma mark - WeekPicker delegate

-(void)weekSelected:(NSArray *)datesInWeek
{
    [self.popover dismissPopoverAnimated:YES];
    self.currentDate = datesInWeek[0];
    
    NSString *pickedWeek = [NSString stringWithFormat:NSLocalizedString(@"%d - Week %d", nil),[self.currentDate year],[self.currentDate week]];
    [self.datePicker setTitle:pickedWeek forState:UIControlStateNormal];
    
    [self getWeightFromDateArray:datesInWeek];
    
//    self.graph.valueLabelCount = 11;
    [self refreshGraph];
    
}

@end
