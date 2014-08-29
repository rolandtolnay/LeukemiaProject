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

-(NSArray*) painLevelsAtDay:(NSString*) day;
-(NSArray*) timeStampsAtDay:(NSString*) day;

-(void) showError:(BOOL) isHidden withText:(NSString*) errorText;
@end

@implementation RTGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    if (screenScale == 2.0) //is retina display
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
        
        [self refreshGraph:nil];
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

-(void)showError:(BOOL) isHidden withText:(NSString *)errorText {
    self.lblError.hidden = !isHidden;
    self.graph.hidden = isHidden;
    self.lblError.text = errorText;
    [self.lblError setCenter:self.view.center];
}

-(void)refreshGraph:(id)sender {
    [self.graph reset];
    if ([[self painLevelsAtDay:self.dateTextField.text] count] < 2)
    {
        [self showError:YES withText:@"Not enough data to show graph."];
    }
    else
    {
        [self showError:NO withText:nil];
        [self.graph draw];
    }
}

#pragma mark - Graph Data Init

- (NSArray*) painLevelsAtDay:(NSString *) day {
    NSMutableArray *painLevels = [[NSMutableArray alloc] init];
    for (NSDictionary *painRegistration in self.data.painData)
    {
        NSNumber *painLevel = [NSNumber numberWithInt:[[painRegistration objectForKey:@"painlevel"] intValue]];
        NSString *timeStamp = [painRegistration objectForKey:@"time"];
        if ([timeStamp rangeOfString:day].location != NSNotFound)
        {
             [painLevels addObject:painLevel];
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

#pragma mark - GKLineGraphDataSource


- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    NSArray *lines = @[
                       [self painLevelsAtDay:self.dateTextField.text],
                       @[@1, @5, @10]
                       ];
    return [lines objectAtIndex:index];
}

- (NSInteger)numberOfLines {
    return 2;
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
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
