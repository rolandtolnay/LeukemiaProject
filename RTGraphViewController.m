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

@property (strong, nonatomic) NSArray* lineValues;


@property UIColor *colorStomachPain;
@property UIColor *colorMouthPain;
@property UIColor *colorOtherPain;

@property UIPopoverController* popover;

-(NSArray*) painLevelsAtDay:(NSString*) day forPainType:(NSString *) painType;
-(NSArray*) timeStampsAtDay:(NSString*) day;
-(BOOL) isEnoughDataAtDay:(NSString *) day;

-(void) showError:(BOOL) isHidden withText:(NSString*) errorText;

@end

@implementation RTGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.colorMouthPain = [UIColor gk_pomegranateColor];
    self.colorStomachPain = [UIColor gk_greenSeaColor];
    self.colorOtherPain = [UIColor gk_belizeHoleColor];
    
    if ([self isRetinaDisplay])
    {
        self.data = [RTDataManagement singleton];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:currentDate];
        [self.datePicker setTitle:today forState:UIControlStateNormal];
        
        self.graph.dataSource = self;
        self.graph.lineWidth = 3.0;
        self.graph.valueLabelCount = 11;
        self.graph.startFromZero = YES;
        
        [self.lblMouthColor setTextColor:_colorMouthPain];
        [self.lblStomachColor setTextColor:_colorStomachPain];
        [self.lblOtherColor setTextColor:_colorOtherPain];
    }
    else
    {
        self.graph.hidden = YES;
        self.datePicker.hidden = YES;
        [self showError:YES withText:@"Graph feature only supported on devices with retina display."];
    }
}

-(BOOL)isRetinaDisplay{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return (screenScale == 2.0);
}


-(void)viewDidLayoutSubviews {
    if ([self isRetinaDisplay])
        [self refreshGraph:self];
}

-(void)showError:(BOOL) isHidden withText:(NSString *)errorText {
    self.lblError.hidden = !isHidden;
    self.graph.hidden = isHidden;
    self.lblError.text = errorText;
    [self.lblError setCenter:self.view.center];
}

-(void)refreshGraph:(id)sender {
    [self.graph reset];
    [self.view endEditing:YES];
    NSString* selectedDay = [self.datePicker titleForState:UIControlStateNormal];
    if ([self isEnoughDataAtDay:selectedDay])
    {
        [self showError:NO withText:nil];
        self.lineValues = @[
                            [self painLevelsAtDay:selectedDay forPainType:MouthPain],
                            [self painLevelsAtDay:selectedDay forPainType:StomachPain],
                            [self painLevelsAtDay:selectedDay forPainType:OtherPain],
                            @[@1, @5, @10]
                            ];
        [self.graph draw];
    }
    else
    {
        [self showError:YES withText:@"Not enough data to show graph."];
    }
}

#pragma mark - Graph Data Init

- (NSArray*) painLevelsAtDay:(NSString *) day forPainType:(NSString*) painType{
    NSMutableArray *painLevels = [[NSMutableArray alloc] init];
    for (NSDictionary *painRegistration in self.data.painData)
    {
        NSString *painTypeReg = [painRegistration objectForKey:@"paintype"];
        if ([painTypeReg isEqualToString:painType])
        {
            NSNumber *painLevel = [NSNumber numberWithInt:[[painRegistration objectForKey:@"painlevel"] intValue]];
            NSString *timeStamp = [painRegistration objectForKey:@"time"];
            if ([timeStamp rangeOfString:day].location != NSNotFound)
            {
                [painLevels addObject:painLevel];
            }
        }
    }
    return [painLevels copy];
}

-(NSArray *)timeStampsAtDay:(NSString *) day {
    NSMutableArray *timeStamps = [[NSMutableArray alloc] init];
    
    for (NSDictionary *painRegistration in self.data.painData)
    {
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        NSString *hour = [NSString alloc];
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
            hour = [timeStamp componentsSeparatedByString:@" "][1];
            [timeStamps addObject:hour];
        }
    }
    NSLog(@"%@",timeStamps);
    return [timeStamps copy];
}

-(BOOL) isEnoughDataAtDay:(NSString *) day {
    if ([[self painLevelsAtDay:day forPainType:MouthPain] count] > 1)  return YES;
    if ([[self painLevelsAtDay:day forPainType:StomachPain] count] >1) return YES;
    if ([[self painLevelsAtDay:day forPainType:OtherPain] count] >1) return YES;
    
    return NO;
}

#pragma mark - GKLineGraphDataSource


- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.lineValues objectAtIndex:index];
}

- (NSInteger)numberOfLines {
    return [self.lineValues count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[ _colorMouthPain,
                   _colorStomachPain,
                   _colorOtherPain,
                   [UIColor clearColor]];
    return [colors objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return 1.0;
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    NSString* selectedDay = [self.datePicker titleForState:UIControlStateNormal];
    return [[self timeStampsAtDay:selectedDay] objectAtIndex:index];
}

#pragma mark - CalendarPicker

- (void)dateSelected:(NSDate *)date
{
    self.currentDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pickedDate = [dateFormatter stringFromDate:date];
    
    [self.datePicker setTitle:pickedDate forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    [self refreshGraph:nil];
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"datePicker"]){
        RTGraphCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        
        self.popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        self.popover.delegate = self;
    }
}

@end
