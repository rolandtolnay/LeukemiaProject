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

-(NSArray*) painLevelsAtDay:(NSString*) day forPainType:(NSString *) painType;
-(NSArray*) timeStampsAtDay:(NSString*) day;
-(BOOL) isEnoughDataAtDay:(NSString *) day;

-(void) showError:(BOOL) isHidden withText:(NSString*) errorText;

@property (strong, nonatomic) NSArray* lineValues;

@property UIColor *colorStomachPain;
@property UIColor *colorMouthPain;
@property UIColor *colorOtherPain;

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
        self.dateTextField.text = today;
        
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
        self.dateTextField.hidden = YES;
        self.dateLabel.hidden = YES;
        self.refreshButton.hidden = YES;
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
    NSString* selectedDay = self.dateTextField.text;
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
            NSLog(@"%@",painTypeReg);
            NSNumber *painLevel = [NSNumber numberWithInt:[[painRegistration objectForKey:@"painlevel"] intValue]];
            NSString *timeStamp = [painRegistration objectForKey:@"time"];
            if ([timeStamp rangeOfString:day].location != NSNotFound)
            {
                [painLevels addObject:painLevel];
            }
        }
    }
    NSLog(@"%@",painLevels);
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
    return [[self timeStampsAtDay:self.dateTextField.text] objectAtIndex:index];
}

#pragma mark - CalendarPicker

- (void)dateSelected:(NSDate *)date
{
    NSLog(@"Delegate date selected: %@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pickedDate = [dateFormatter stringFromDate:date];
    self.dateTextField.text = pickedDate;
}

-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    NSLog(@"Prepare for segue before ifcheck");
    if([segue.identifier isEqualToString:@"datePicker"]){
        NSLog(@"Prepare for segue");
        RTGraphCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        
        UIPopoverController* popover = [(UIStoryboardPopoverSegue*)segue popoverController];
        popover.delegate = self;
    }
}

@end
