//
//  AddPlanViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 17/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AddPlanViewController.h"
#import "AddPlanTableViewCell.h" 
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "AFNetworking.h"

@interface AddPlanViewController ()
{
    AddPlanTableViewCell *cell;
    MBProgressHUD *hud;
    NSArray *fromTimeArr, *toTimeArr;
    NSMutableArray *ary;
    NSString *userID, *strAgentID, *strPosition, *strTimeZone, *strDate;
    NSArray *agentArr;
    NSInteger fromIndex;
    NSDateFormatter *dateFormatter;
    UIPickerView *picker ;
}
@end

@implementation AddPlanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fromTimeArr = [[NSArray alloc] initWithObjects:@"08:00 AM", @"08:30 AM",@"09:00 AM", @"09:30 AM",@"10:00 AM", @"10:30 AM",@"11:00 AM", @"11:30 AM",@"12:00 PM", @"12:30 PM",@"01:00 PM", @"01:30 PM",@"02:00 PM", @"02:30 PM",@"03:00 PM", @"03:30 PM",@"04:00 PM", @"04:30 PM",@"05:00 PM", @"05:30 PM",@"06:00 PM", @"06:30 PM",@"07:00 PM", @"07:30 PM",  nil];
    toTimeArr = [[NSArray alloc] initWithObjects:@"08:30 AM",@"09:00 AM", @"09:30 AM",@"10:00 AM", @"10:30 AM",@"11:00 AM", @"11:30 AM",@"12:00 PM", @"12:30 PM",@"01:00 PM", @"01:30 PM",@"02:00 PM", @"02:30 PM",@"03:00 PM", @"03:30 PM",@"04:00 PM", @"04:30 PM",@"05:00 PM", @"05:30 PM",@"06:00 PM", @"06:30 PM",@"07:00 PM", @"07:30 PM",@"08:00 PM",@"08:30 PM",  nil];

    userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"salesVisitID"] ;
    
    strPosition = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Pos_name"];
    strTimeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZone"];
   
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    strDate = [dateFormatter stringFromDate:date];
    
    fromIndex = 0;
   
    NSLog(@"DATE---->> %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"]);
    
    [self fetchAgentListForUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)txtFrom:(id)sender {
   
    ary= [[NSMutableArray alloc] init];
    
    ary = [NSMutableArray arrayWithArray:fromTimeArr];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Select Time :" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
    picker.delegate = (id)self;
    picker.dataSource = (id)self;
    [alert addSubview:picker];
    picker.tag = 1;
    alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
    [alert setValue:picker forKey:@"accessoryView"];
    [alert setTag:1];
    [alert show];

}

- (IBAction)txtTo:(id)sender {
    
    ary= [[NSMutableArray alloc] init];
    NSString *strFromTime = [self.txtFrom text];

    NSLog(@"--->>%@--%ld",strFromTime,[strFromTime length]);
    if ([strFromTime length]!=0) {
        
        for (int i=0; i<[toTimeArr count]; i++) {
            
            if (i>fromIndex-1) {
                
                [ary addObject:[toTimeArr objectAtIndex:i]];
            }
        }
        
    }
    else {
        ary = [NSMutableArray arrayWithArray:toTimeArr];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Select Time :" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
    picker.delegate = (id)self;
    picker.dataSource = (id)self;
    [alert addSubview:picker];
    picker.tag = 2;
    alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
    [alert setValue:picker forKey:@"accessoryView"];
    [alert setTag:2];
    [alert show];
}

#pragma mark - UIPickerView Delegate and Datasource methods

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ary count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ary[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"SELECTED >> %@", [ary objectAtIndex:row]);
//    if (pickerView.tag == 1) {
//        
//        fromIndex = row;
//        strFromTime = [ary objectAtIndex:row];
//        
//    }
//    else if (pickerView.tag == 2) {
//        
//        strToTime = [ary objectAtIndex:row];
//    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
       
        if (buttonIndex == 1) {
            
            [self.txtFrom setText:[ary objectAtIndex:[picker selectedRowInComponent:0]]];
            [self.txtTo setText:[toTimeArr objectAtIndex:[picker selectedRowInComponent:0]+1]];
        }
    }
    else if (alertView.tag == 2) {
        
        if (buttonIndex == 1) {
            
            [self.txtTo setText:[ary objectAtIndex:[picker selectedRowInComponent:0]]];
        }
    }
}


#pragma  mark - UIButton IBAction methods

- (IBAction)btnCancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddPlan:(id)sender {
    
    if ([[self.txtFrom text] length] == 0) {
        
        [self.view makeToast:@"Please select plan start time."];
    }
    else if ([[self.txtTo text] length] == 0) {
        
        [self.view makeToast:@"Please select plan end time."];
    }
    else if ([strAgentID length] == 0) {
        
        [self.view makeToast:@"Please select agent."];
    }
    else {
        
        //Call service to add plan
        [self webServiceToAddPlan];
    }
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [agentArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(AddPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ([[agentArr objectAtIndex:indexPath.row] objectForKey:@"AgentName"] != [NSNull null]) {
        
        [cell.lblAgentName setText:[[agentArr objectAtIndex:indexPath.row] objectForKey:@"AgentName"]];
        
    }
    if ([[agentArr objectAtIndex:indexPath.row] objectForKey:@"AgentTier"] != [NSNull null]) {
        
        [cell.lblAgentTier setText:[[agentArr objectAtIndex:indexPath.row] objectForKey:@"AgentTier"]];
        
    }
    if ([[agentArr objectAtIndex:indexPath.row] objectForKey:@"TotalPlan"] != [NSNull null]) {
        
        [cell.lblTotalPlan setText:[[agentArr objectAtIndex:indexPath.row] objectForKey:@"TotalPlan"]];
        
    }
    if ([[agentArr objectAtIndex:indexPath.row] objectForKey:@"ActualPlan"] != [NSNull null]) {
        
        [cell.lblActualPlan setText:[[agentArr objectAtIndex:indexPath.row] objectForKey:@"ActualPlan"]];
        
    }
    if ([[agentArr objectAtIndex:indexPath.row] objectForKey:@"AdditionPlan"] != [NSNull null]) {
        
        [cell.lblAditionalPlan setText:[[agentArr objectAtIndex:indexPath.row] objectForKey:@"AdditionPlan"]];
        
    }

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[agentArr objectAtIndex:indexPath.row] objectForKey:@"AgentId"] != [NSNull null]) {
        
        strAgentID = [[agentArr objectAtIndex:indexPath.row] objectForKey:@"AgentId"];
        
    }
    
}


#pragma mark - Consume Webservices 

-(void)fetchAgentListForUser{

    
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@user_id=%@",BASE_URL,FETCH_AGENTLIST_PLAN,userID]);
        
        [manager GET:[NSString stringWithFormat:@"%@%@user_id=%@",BASE_URL,FETCH_AGENTLIST_PLAN,userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if (responsDict != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObject:responsDict];
                });
            }
            
            else {
                [self hideHud];
                [self.view makeToast:@"Failed!!"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ERROR------>> %@",error);
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlert show];
        }];
    
    

}


 -(void)parseDataResponseObject:(NSDictionary *)dictionary {
 
     if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
         
         if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
             
             if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                
                 agentArr = [dictionary objectForKey:@"data"];
                    
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [self.tableView reloadData];
                    
                 });
                 
                 [self hideHud];
                 
             }
         }
         
     }
     else {
         if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
             != [NSNull null]) {
             [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
             
         }
         else {
             [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
         }
         [self hideHud];
     }

 }

-(void)webServiceToAddPlan {
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /*
     
     {
     "UserId":699,
     "AgentId":150,
     "StartTime":"2017-01-01T09:00:00+05:30",
     "EndTime":"2017-01-01T10:00:00+05:30",
     "Position":"Marketer"
     }

     */
    
    
    NSString *strFrom = [self convertDateTo24Hrs:[self.txtFrom text]];
    NSString *strTo =  [self convertDateTo24Hrs:[self.txtTo text]];
    
    NSString *strStartTime = [NSString stringWithFormat:@"%@T%@%@",strDate,strFrom,strTimeZone];
    NSString *strEndTime = [NSString stringWithFormat:@"%@T%@%@",strDate,strTo,strTimeZone];
    
//    NSLog(@"----->> %@",strTimeZone);
//    NSLog(@"Start Time----->> %@ , End Time----->> %@", strStartTime, strEndTime);
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            userID,@"UserId",
                            strAgentID,@"AgentId",
                            strStartTime,@"StartTime",
                            strEndTime,@"EndTime",
                            strPosition,@"Position",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_PLAN]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_PLAN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForAddPlan:responseObject];
            });
            NSLog(@"----->> %@",responseObject);
        }
        else {
            
            [self hideHud];
            [self.view makeToast:@"No response from server."];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR ----->> %@",error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"Please check Internet connectivity."];
    }];
    
}

-(void)parseDataResponseObjectForAddPlan:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self hideHud];
                
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if([_delegate respondsToSelector:@selector(backFromAddPlanViewController)]) {
                
                [_delegate backFromAddPlanViewController];
                
            }
        }
        
    }
    else {
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            
        }
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
        }
        [self hideHud];
    }
    
}
-(NSString *) convertDateTo24Hrs :(NSString *)strDate1 {
    
   dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *date = [dateFormatter dateFromString:strDate1];
    
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    
    // NSLog(@"----->>%@", pmamDateString);
    return pmamDateString;
}


#pragma mark - MBProgressHUD methods

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
