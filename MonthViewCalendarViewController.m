//
//  MonthViewCalendarViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "MonthViewCalendarViewController.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "App_Constant.h"


@interface MonthViewCalendarViewController ()
{
    CalendarCollectionViewCell *cell;
    MBProgressHUD *hud;
    NSDateFormatter *dateFormatter, *wsDateFormatter;
    NSCalendar* calendar;
    
    NSArray *dayCountInMonthArr;
    NSDate *date ;
    NSMutableArray *dateArr, *eventArr, *planArr;
    NSString *firstDate, *currentMonth, *today;
    UIColor *cellColor;
    
    NSString *userID;
}
@end

@implementation MonthViewCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //--------TIME ZONE
    
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"Z";
    NSString *localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    NSString *timeZone = [NSString stringWithFormat:@"%@:%@",[localTimeZoneOffset substringWithRange:NSMakeRange(0, 3)],[localTimeZoneOffset substringFromIndex:3]];
    
    [[NSUserDefaults standardUserDefaults] setObject:timeZone forKey:@"timeZone"];
    [[NSUserDefaults standardUserDefaults] setObject:@"+05.30" forKey:@"timeZone"];

    userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"salesVisitID"] ;
   
    
    cellColor = [UIColor whiteColor];
    calendar = [NSCalendar currentCalendar];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    wsDateFormatter = [[NSDateFormatter alloc] init];
    wsDateFormatter.dateFormat = @"yyyy-MM-dd";

    
    date =[[NSDate alloc] init];
    
    today = [dateFormatter stringFromDate:date];
    NSString *strDate;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] == [NSNull null] || [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] == nil) {
        
        date = [NSDate date];
        strDate = [dateFormatter stringFromDate:date];
        
    }
    else {
        strDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"strDate"];
        date = [dateFormatter dateFromString:strDate];
    }
   
    [self firstDayOfMonth:strDate];
    
    [self setDateForCalendar];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)firstDayOfMonth:(NSString *)dateString {
    
    date = [dateFormatter dateFromString:dateString];
    
    currentMonth = [[dateString componentsSeparatedByString:@"-"] objectAtIndex:1];
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    components.day = 1;
    date = [calendar dateFromComponents:components];
    
    NSLog(@"first DATE--- %@",[dateFormatter stringFromDate:date]);
    
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    NSString *dayName = [[[firstDayOfMonthDate descriptionWithLocale:[NSLocale currentLocale]] componentsSeparatedByString:@","] objectAtIndex:0];
    
    NSLog(@"First day of month: %@", dayName);
    
    firstDate = [dateFormatter stringFromDate:date];
    
    self.lblHeader.text = [NSString stringWithFormat:@"%@, %@",[self getCurrentMonthName:firstDate],[[firstDate componentsSeparatedByString:@"-"] objectAtIndex:2]];
    
    NSInteger minusDaysCount = [self MinusDates:dayName] + 1;
    
    date = [date dateByAddingTimeInterval: -86400.0*minusDaysCount];

    dateArr = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 42; i++) {
        
        date = [date dateByAddingTimeInterval: 86400.0];
        [dateArr addObject:[dateFormatter stringFromDate:date]];
    }
    
    
}

- (IBAction)btnPrevious:(id)sender {
    
    date = [dateFormatter dateFromString:firstDate];
    
    NSDateComponents * components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    [components setMonth:components.month - 1];
    
    [self firstDayOfMonth:[dateFormatter stringFromDate:[calendar dateFromComponents:components]]];
    
    NSString *changeDate = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    
    [[NSUserDefaults standardUserDefaults] setObject:changeDate forKey:@"strDate"];
    if([_delegate respondsToSelector:@selector(updateCalendar:)]) {
        
        [_delegate updateCalendar:0];
        
    }
}
- (IBAction)btnNext:(id)sender {
    
    date = [dateFormatter dateFromString:firstDate];
    
    NSDateComponents * components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    [components setMonth:components.month + 1];
    
    [self firstDayOfMonth:[dateFormatter stringFromDate:[calendar dateFromComponents:components]]];
    
    NSString *changeDate = [dateFormatter stringFromDate:[calendar dateFromComponents:components]];
    [[NSUserDefaults standardUserDefaults] setObject:changeDate forKey:@"strDate"];
    if([_delegate respondsToSelector:@selector(updateCalendar:)]) {
        
        [_delegate updateCalendar:0];
        
    }
    
}

-(NSString *)getCurrentMonthName :(NSString *)mydate
{
    int monthNumber = [[[mydate componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
    NSString * dateString = [NSString stringWithFormat: @"%d", monthNumber];
    
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM"];
    NSDate* myDate = [dateFormatter1 dateFromString:dateString];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    
    return stringFromDate;
}


-(NSInteger)MinusDates:(NSString *)dayName {
    
    if ([dayName isEqualToString:@"Monday"]) {
        
        return 1;
    }
    else if ([dayName isEqualToString:@"Tuesday"]) {
        
        return 2;
    }
    else if ([dayName isEqualToString:@"Wednesday"]) {
        
        return 3;
    }
    else if ([dayName isEqualToString:@"Thursday"]) {
        
        return 4;
    }
    else if ([dayName isEqualToString:@"Friday"]) {
        
        return 5;
    }
    else if ([dayName isEqualToString:@"Saturday"]) {
        
        return 6;
    }
    else {
        
        return 0;
    }
    
}

#pragma mark - CALENDAR View Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.eventView setHidden:YES];

    cell.lblDate.text = [[[dateArr objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"] objectAtIndex:0];
    
    if ([eventArr count] != 0) {
        
        for (NSString *strEventDate in eventArr) {

            if ([[dateArr objectAtIndex:indexPath.row] isEqualToString:strEventDate]) {

                [cell.eventView setHidden:NO];
            }
        }
    }
    else {
        [cell.eventView setHidden:YES];
    }
    cell.eventView.layer.cornerRadius = 4.0f;
    
    if (! [[[[dateArr objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"] objectAtIndex:1] isEqualToString:currentMonth]) {
        
        [cell.lblDate setTextColor:[UIColor grayColor]];
    }
    
    else {
        
        if ([[dateArr objectAtIndex:indexPath.row]  isEqualToString:today]) {
            
            [cell.lblDate setTextColor:[UIColor blueColor]];
        }
        else {
            
            [cell.lblDate setTextColor:[UIColor blackColor]];
        }
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSUserDefaults standardUserDefaults] setObject:[dateArr objectAtIndex:indexPath.row] forKey:@"strDate"];
    if([_delegate respondsToSelector:@selector(updateCalendar:)]) {
        
        [_delegate updateCalendar:1];
        
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    
    
    if (collectionviewSize.width == 320) {
         side1=collectionviewSize.width/6-10;
    }
    else {
         side1=collectionviewSize.width/6-15;
    }
//    side1=collectionviewSize.width/6-15;
    side2=collectionviewSize.width/6-10;
    
    
    return CGSizeMake(side1, side2);
}


-(void)setDateForCalendar {

    planArr = [[NSMutableArray alloc]init];
    eventArr = [[NSMutableArray alloc] init];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"PLANS"];
    
    planArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for (NSDictionary *dict in planArr) {
        
        NSDate *changeDate = [wsDateFormatter dateFromString:[dict objectForKey:@"Date"]];
        NSString *strChangedDate = [dateFormatter stringFromDate:changeDate];
        [eventArr addObject:strChangedDate];
    }
    

    [self.collectionView reloadData];
    
}
#pragma mark -MBProgressHUD methods

-(void)showHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.delegate = (id)self;
                       
                   });
}

-(void)hideHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       [hud hide:YES];
                       //[hud removeFromSuperview];
                       
                   });
}

@end
