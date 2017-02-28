//
//  DayViewCalendarViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "DayViewCalendarViewController.h"
#import "CalendarCollectionViewCell.h"
#import "ORGContainerCell.h"
#import "ORGContainerCellView.h"
#import "CustomAnimationAndTransiotion.h"
#import "UpdatePlanViewController.h"
#import "SalesTracker_AppURL.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface DayViewCalendarViewController () <UpdateViewControllerDelegate>
{
    MBProgressHUD *hud;
    NSArray *timeArr, *wsTimeArr;
    NSDateFormatter *dateFormatter, *wsDateFormatter, *dayFormatter, *monthFormatter;
    NSCalendar* calendar;
    NSDate *date ;
    NSArray *planArr, *todayPlanArr;
    NSMutableArray *timePlanArr;
    NSString *currentMonth, *strDate, *dayName;
    NSString *strRemark;
}

@property (strong, nonatomic) NSArray *sampleData;
@property(strong, nonatomic)CustomAnimationAndTransiotion  *customTransitionController;
@end

@implementation DayViewCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    timeArr = [[NSArray alloc] initWithObjects:@"All day",@"08:00 AM", @"08:30 AM",@"09:00 AM", @"09:30 AM",@"10:00 AM", @"10:30 AM",@"11:00 AM", @"11:30 AM",@"12:00 PM", @"12:30 PM",@"01:00 PM", @"01:30 PM",@"02:00 PM", @"02:30 PM",@"03:00 PM", @"03:30 PM",@"04:00 PM", @"04:30 PM",@"05:00 PM", @"05:30 PM",@"06:00 PM", @"06:30 PM",@"07:00 PM", @"07:30 PM",@"08:00 PM",  nil];
    wsTimeArr = [[NSArray alloc] initWithObjects:@"00:00:00",@"08:00:00", @"08:30:00",@"09:00:00", @"09:30:00",@"10:00:00", @"10:30:00",@"11:00:00", @"11:30:00",@"12:00:00", @"12:30:00",@"13:00:00", @"13:30:00",@"14:00:00", @"14:30:00",@"15:00:00", @"15:30:00",@"16:00:00", @"16:30:00",@"17:00:00", @"17:30:00",@"18:00:00", @"18:30:00",@"19:00:00", @"19:30:00",@"20:00:00",  nil];
    
    calendar = [NSCalendar currentCalendar];
    
    date =[[NSDate alloc] init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE, dd-MMM-yyyy"];
    
    wsDateFormatter = [[NSDateFormatter alloc] init];
    wsDateFormatter.dateFormat = @"yyyy-MM-dd";
    
    monthFormatter = [[NSDateFormatter alloc]init];
    monthFormatter.dateFormat = @"EEE , dd-MMM-yyyy";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] ==[NSNull null] || [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] == nil) {
       
        date = [NSDate date];
        self.strSelectedDate = [dateFormatter stringFromDate:date];
        
    }
    else {
        
        self.strSelectedDate  = [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"];
        date = [dateFormatter dateFromString:self.strSelectedDate];
    }
    
    self.lblDate.text = [dayFormatter stringFromDate:date];
    
    currentMonth = [[self.strSelectedDate componentsSeparatedByString:@"-"] objectAtIndex:1];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"PLANS"];
  
    planArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self getTodayPlan];
    
    // Register the table cell
    [self.tableView registerClass:[ORGContainerCell class] forCellReuseIdentifier:@"ORGContainerCell"];
    
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    
    [self fetchRemarkForDay:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTodayPlan {
    
    for (NSDictionary *dict in planArr) {
        
        NSDate *changedDate= [dateFormatter dateFromString:_strSelectedDate];
        NSString *strChangedDate = [wsDateFormatter stringFromDate:changedDate];
        
        if ([strChangedDate isEqualToString:[dict objectForKey:@"Date"]]) {
            
            todayPlanArr = [dict objectForKey:@"Plan"];
            break;
        }
        else {
            todayPlanArr = nil;
            
        }
        //Check condition for current date have any plans or not
    }
    
    [self.tableView reloadData];
}

#pragma mark - CALENDAR View Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.lblDayTime.text = [timeArr objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
 
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1;
    CGSize collectionviewSize=self.collectionView.frame.size;
    
    side1=collectionviewSize.width;
    
    return CGSizeMake(side1, 130);
}

#pragma mark - IBAction methods


- (IBAction)btnNext:(id)sender {
   
    date = [date dateByAddingTimeInterval: 86400.0];
    
    [self fetchRemarkForDay:date];
    
    self.strSelectedDate = [dateFormatter stringFromDate:date];
   
    self.lblDate.text = [dayFormatter stringFromDate:date];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.strSelectedDate forKey:@"strDate"];
    
    for (NSDictionary *dict in planArr) {
        NSDate *changedDate= [wsDateFormatter dateFromString:_strSelectedDate];
        NSString *strChangedDate = [wsDateFormatter stringFromDate:changedDate];
        if ([strChangedDate isEqualToString:[dict objectForKey:@"Date"]]) {
            
//            NSLog(@"HAS EVENT---->> %@", strChangedDate);
        }
        //Check condition for current date have any plans or not
    }
    [self getTodayPlan];
    
    if ([currentMonth integerValue] < [[[self.strSelectedDate componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue]) {
        if ([_delegate respondsToSelector:@selector(updateCalenderView)]) {
            
            [_delegate updateCalenderView];
        }
    }
    else {
    //    NSLog(@"***---IN SAME MONTH --------");
    }
}

- (IBAction)btnPrevious:(id)sender {
    
    date = [date dateByAddingTimeInterval: -86400.0];
    
    [self fetchRemarkForDay:date];
    
    self.strSelectedDate = [dateFormatter stringFromDate:date];
    
    self.lblDate.text = [dayFormatter stringFromDate:date];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.strSelectedDate forKey:@"strDate"];
   
    for (NSDictionary *dict in planArr) {
        
        NSDate *changedDate= [wsDateFormatter dateFromString:_strSelectedDate];
        NSString *strChangedDate = [wsDateFormatter stringFromDate:changedDate];
        
        if ([strChangedDate isEqualToString:[dict objectForKey:@"Date"]]) {
            
//            NSLog(@"HAS EVENT---->> %@", strChangedDate);
        }
        //Check condition for current date have any plans or not
    }
    
    [self getTodayPlan];
    
    if ([currentMonth integerValue] > [[[self.strSelectedDate componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue]) {
        if ([_delegate respondsToSelector:@selector(updateCalenderView)]) {
            
            [_delegate updateCalenderView];
        }
    }
    else {
//        NSLog(@"***---IN SAME MONTH --------");
    }

}


#pragma mark - Film Strip

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [timeArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ORGContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORGContainerCell"];
    
    timePlanArr = [[NSMutableArray alloc]init];
    
        for (int i = 0; i < [todayPlanArr count]; i++) {
            
            if ([[wsTimeArr objectAtIndex:indexPath.section] isEqualToString:[[todayPlanArr objectAtIndex:i] objectForKey:@"StartTime"]]) {
               
                    [timePlanArr addObject:[todayPlanArr objectAtIndex:i] ];
                NSLog(@"-?>---->>%@",[todayPlanArr objectAtIndex:i]);
                if ([[[[todayPlanArr objectAtIndex:i] objectForKey:@"Status"] lowercaseString] isEqualToString:@"b"]) {
                    [cell setUserInteractionEnabled:NO];
                }
                else {
                    [cell setUserInteractionEnabled:YES];
                }
            }
            
        }
   
       [cell setCollectionData:timePlanArr :indexPath.section];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSDictionary *sectionData = [self.sampleData objectAtIndex:section];
    NSString *header = [sectionData objectForKey:@"description"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    
    if ([self checkPastDate:date]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"You can not add/manage visit plan for past dates" delegate:(id)self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 0;
        [alertView show];
    }
    else {
        NSDictionary *cellData = [notification object];
        
        NSLog(@"Selected Cell :: >> %@ ", [notification object]);
        
        UpdatePlanViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"UPDATE_PLAN"];
        popover.planDict = cellData;
        popover.delegate = (id)self;
        popover.modalPresentationStyle = UIModalPresentationCustom;
        [popover setTransitioningDelegate:_customTransitionController];
        [self presentViewController:popover animated:YES completion:nil];
    }
}

- (IBAction)btnMapping:(id)sender {
    
    UIViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"MAPPING"];
    //popover.delegate = (id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];

}

- (IBAction)btnDeleteAll:(id)sender {
    
    if ([self checkFutureDate:date]) {
        
        NSString *strMessage = [NSString stringWithFormat:@"You can not delete visit plan for %@",[dayFormatter stringFromDate:date]];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:strMessage delegate:(id)self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 0;
        [alertView show];
    }
    else {
        NSString *strMessage = [NSString stringWithFormat:@"Are you sure want to delete plan of %@?",[dayFormatter stringFromDate:date]];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Delete All Plan" message:strMessage delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = 1;
        [alertView show];
    }
    
}

- (IBAction)btnRecruitment:(id)sender {
    
    
    UIViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"RECRUITMENT"];
    //popover.delegate = (id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}

#pragma mark -  UIAlertView method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            /*
             
             {
             "PlanId":113,
             "Date":"2016-09-28"
             }
             
             */
            
            NSDate *date1 = [dateFormatter dateFromString:self.strSelectedDate];
            strDate = [wsDateFormatter stringFromDate:date1];
            
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"0",@"PlanId",
                                    strDate,@"Date",
                                    nil];
            
            NSLog(@"---->>%@",params);
            
            [self deletePlanForTheDate:strDate forParams:params];
            
        }

    }
    if (alertView.tag == 3) {
        if (buttonIndex == 1) {
        
            [self addRemarkForDayWithRemark:[alertView textFieldAtIndex:0].text];
            
        }
        
    }

}


#pragma mark - consume Webservice

-(void)deletePlanForTheDate:(NSString *)date forParams:(NSDictionary *)params{
    
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@"----->>%@",[NSString stringWithFormat:@"%@%@",BASE_URL, DELETE_PLAN]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL, DELETE_PLAN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseUpdateObject:responseObject];
                    
                });
        }
        
        NSLog(@"------->> %@",responseObject);
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR ----->> %@",error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"Please check Internet connectivity."];
    }];
    
    
}

-(void)parseDataResponseUpdateObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self updateSelectedPlan:nil ForDay:@"nil" withAction:@"deleteAll"];
            
            [self hideHud];
            
        }
        
    }
    else {
        [self hideHud];
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
        }
    }
    
    
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

#pragma mark - Custom Delegate UIViewController Methods

-(void)updateSelectedPlan:(NSMutableDictionary *)planDict ForDay:(NSString *)strPlanDate withAction:(NSString *)actionType {
    
    if ([_delegate respondsToSelector:@selector(updateCalenderView)]) {
        
        [_delegate updateCalenderView];
    }
    
}

-(BOOL)checkPastDate:(NSDate *)changedDate {
    
    BOOL isTrue;
    
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:(-86400.0*2)];
    
    if ([currentDate timeIntervalSince1970] >= [changedDate timeIntervalSince1970]) {
       
        isTrue = YES;
    }
    else {
        
        isTrue = NO;
    }
    return isTrue;
}
-(BOOL)checkFutureDate:(NSDate *)changedDate {
    
    BOOL isTrue;
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate timeIntervalSince1970] >= [changedDate timeIntervalSince1970]) {
        
        isTrue = YES;
    }
    else {
        
        isTrue = NO;
    }
    return isTrue;
}


#pragma mark - Day remark methods


-(void)fetchRemarkForDay:(NSDate *)rDate {
  
    NSString *strUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"salesVisitID"];
    
    NSLog(@"FETCH REMARK FOR :: >> %@",  [wsDateFormatter stringFromDate:rDate]);
    NSString *strRemarkDate = [wsDateFormatter stringFromDate:rDate];
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:GET_DAY_REMARK,BASE_URL,strUserID,strRemarkDate]);
    
    [manager GET:[NSString stringWithFormat:GET_DAY_REMARK,BASE_URL,strUserID,strRemarkDate] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responseArr != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responseArr];
            });
        }
        
        else {
            [self hideHud];
            [self.view makeToast:@"Login Incorrect!!"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR------>> %@",error);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}
-(void)parseDataResponseObject:(NSDictionary *)dictionary {
   
//    NSLog(@"Remark Response>> %@",dictionary);
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            
            if ([[dictionary objectForKey:@"data"] objectForKey:@"Remark"] != [NSNull null]) {
                
                [self.btnRemark setTitle:[NSString stringWithFormat:@"Remark: %@",[[dictionary objectForKey:@"data"] objectForKey:@"Remark"]] forState:UIControlStateNormal];
                strRemark = [[dictionary objectForKey:@"data"] objectForKey:@"Remark"];
            }
            else {
                [self.btnRemark setTitle:@"Remark : No remark" forState:UIControlStateNormal];
                strRemark = @"";
            }
            
        }

    }
    else {
       
        [self.btnRemark setTitle:@"Remark : No remark" forState:UIControlStateNormal];
        strRemark = @"";
    }
    [self hideHud];
}




- (IBAction)btnRemark:(id)sender {
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Remark if No Plan" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"SUBMIT", nil];
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [myAlertView textFieldAtIndex:0].delegate = (id)self;
    [[myAlertView textFieldAtIndex:0] setFont:[UIFont fontWithName:@"Ubuntu" size:12.0f]];
    [myAlertView textFieldAtIndex:0].placeholder = @"Type your remark";
    if (strRemark != nil) {
        [myAlertView textFieldAtIndex:0].text = strRemark;
    }
    myAlertView.tag = 3;
    [myAlertView show];
    
    
}
-(void)addRemarkForDayWithRemark:(NSString *)remark {
    
    NSString *strUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"salesVisitID"];
    
    NSLog(@"FETCH REMARK FOR :: >> %@",  [wsDateFormatter stringFromDate:date]);
    NSString *strRemarkDate = [wsDateFormatter stringFromDate:date];
    
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@"----->>%@",[NSString stringWithFormat:@"%@%@",BASE_URL, ADD_DAY_REMARK]);
        /*
         {
         "UserId":697,
         "Date":"2016-10-24",
         "Remark":"hello"
         }
        */
    
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                strUserID,@"UserId",
                                strRemarkDate,@"Date",
                                remark,@"Remark", nil];
    
    
    
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL, ADD_DAY_REMARK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseAddRemarkDataResponseObject:responseObject For:remark];
                    
                });
            }
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ERROR ----->> %@",error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:@"Please check Internet connectivity."];
        }];
        
    
}
-(void)parseAddRemarkDataResponseObject:(NSDictionary *)dictionary For:(NSString *)remark {
    
    NSLog(@"Add Remark Response>> %@",dictionary);
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        [self.view makeToast:@"Remark successfully added."];
        
        [self.btnRemark setTitle:[NSString stringWithFormat:@"Remark: %@",remark] forState:UIControlStateNormal];
        strRemark = remark;
    }
    else {
        
        [self.view makeToast:@"Failed to add remark."];
    }
    [self hideHud];
}


@end
