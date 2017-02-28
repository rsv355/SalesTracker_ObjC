//
//  UpdatePlanViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "UpdatePlanViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SalesTracker_AppURL.h"
#import "UIButton+tintImage.h"

@interface UpdatePlanViewController ()
{
    MBProgressHUD *hud;
    
    NSArray *fromTimeArr, *toTimeArr;
    NSMutableArray *ary;
    NSDateFormatter *dateFormatter;

    NSString *strDate, *strTimeZone, *strPlanId;
    NSMutableDictionary *planMutableDict;
    UIColor *selectedColor, *deselectedColor, *selectedTintColor, *deselectedTintColor;
    NSString *strStatus, *strFromTime, *strToTime;
    NSInteger fromIndex;
    UIPickerView *picker;
}

@end

@implementation UpdatePlanViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    strDate = [dateFormatter stringFromDate:date];
    
    strTimeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeZone"];
    
    strPlanId = [self.planDict objectForKey:@"PlanId"];
    
    
    fromTimeArr = [[NSArray alloc] initWithObjects:@"08:00 AM", @"08:30 AM",@"09:00 AM", @"09:30 AM",@"10:00 AM", @"10:30 AM",@"11:00 AM", @"11:30 AM",@"12:00 PM", @"12:30 PM",@"01:00 PM", @"01:30 PM",@"02:00 PM", @"02:30 PM",@"03:00 PM", @"03:30 PM",@"04:00 PM", @"04:30 PM",@"05:00 PM", @"05:30 PM",@"06:00 PM", @"06:30 PM",@"07:00 PM", @"07:30 PM",  nil];
    toTimeArr = [[NSArray alloc] initWithObjects:@"08:30 AM",@"09:00 AM", @"09:30 AM",@"10:00 AM", @"10:30 AM",@"11:00 AM", @"11:30 AM",@"12:00 PM", @"12:30 PM",@"01:00 PM", @"01:30 PM",@"02:00 PM", @"02:30 PM",@"03:00 PM", @"03:30 PM",@"04:00 PM", @"04:30 PM",@"05:00 PM", @"05:30 PM",@"06:00 PM", @"06:30 PM",@"07:00 PM", @"07:30 PM",@"08:00 PM",@"08:30 PM",  nil];

    if ([self checkPastDate]) {
        
        self.viewStatusHeightConstraint.constant = 0.0f;
        self.viewDialogueHeightConstraint.constant = 360.0 - 86.0;
        [self.viewStatus setHidden:YES];
    }
    else {
       NSLog(@"NO FUTURE _____");
    }
    
    fromIndex = 0;
    strFromTime = @"";
   
   
    if (_planDict != nil) {
        
        if (![[self.planDict objectForKey:@"Remark"] isEqualToString:@"0"]) {
            
            [self.txtRemark setText:[self.planDict objectForKey:@"Remark"]];
        }
        
        if ([self.planDict objectForKey:@"StartTime"] != [NSNull null]) {
            
            NSString *strTime = [self.planDict objectForKey:@"StartTime"];
            
            [self.txtFrom setText:[self convertDateTo12Hrs:strTime]];
            strFromTime = [self convertDateTo12Hrs:strTime];
            
            for (int i = 0; i< [fromTimeArr count]; i++) {
                
                if ([strFromTime isEqualToString:[fromTimeArr objectAtIndex:i]]) {
                    fromIndex = i;
                }
            }
        }
        
        if ([self.planDict objectForKey:@"EndTime"] != [NSNull null]) {
            
            NSString *strTime = [self.planDict objectForKey:@"EndTime"];
            [self.txtTo setText:[self convertDateTo12Hrs:strTime]];
             strToTime = [self convertDateTo12Hrs:strTime];
        }

    }
    
    [self statusButtonLayoutColour];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIKeyboard methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
   
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSLog(@"--->>%f",self.view.frame.size.height);
    if (self.view.frame.size.height < 570.0) {
         self.centerVerticalViewConstraint.constant = -95.0;
    }
    else {
        self.centerVerticalViewConstraint.constant = -75.0;
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    self.centerVerticalViewConstraint.constant = 0.0;
}

-(void)statusButtonLayoutColour {
    //status button
    
    deselectedColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    selectedColor = [UIColor colorWithRed:187.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    
    selectedTintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    deselectedTintColor = [UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];

    strStatus =  [_planDict objectForKey:@"Status"];
    
    [self setStatusButton:[self.planDict objectForKey:@"Status"]];
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
    alert.tag = 1;
    [alert show];
    
}

- (IBAction)txtTo:(id)sender {
    
    
    ary= [[NSMutableArray alloc] init];
    
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
    alert.tag = 2;
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
}


#pragma mark - UIButton IBAction methods

- (IBAction)btnCancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)btnStatus:(id)sender {
    
    if ([sender tag] == 1) {
        
        strStatus = @"B";
        self.btnupdate.tag = 1;
        [self.txtRemark becomeFirstResponder];
    }
    else
    {
        if ([sender tag] == 2) {
            
            strStatus = @"O";
        }
        else if ([sender tag] == 3) {
            
            strStatus = @"X";
        }
        
        /*
         
         {
         "PlanId":142,
         "Status":"O"
         }
         
         */
        
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strPlanId,@"PlanId",
                                strStatus,@"Status",
                                nil];
        
        NSLog(@"---->>%@",params);
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL, UPDATE_PLAN_STATUS];
        
        [self changePlanDetails:strURL withParamaters:params forAction:@"status"];
    }
    
    [self setStatusButton:strStatus];
    
    

}

- (IBAction)btnDelete:(id)sender {
    
    if ([self checkFutureDate]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"You can not delete this visit plan" delegate:(id)self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 0;
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Are you sure want to delete plan?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.tag = 3;
        [alertView show];
    }
    
}

- (IBAction)btnUpdate:(id)sender {
    
    [self.view endEditing:YES];
  
    if ([sender tag] == 0) {
       
        if ([strFromTime length] == 0) {
            
            [self.view makeToast:@"Please select plan start time."];
        }
        else if ([strToTime length] == 0) {
            
            [self.view makeToast:@"Please select plan end time."];
        }
        else if ([strStatus isEqualToString:@"B"] && [self.txtRemark.text length] == 0) {
            
            [self.view makeToast:@"Please Enter Remark."];
        }
        
        else {
            
            [self updatePlanService];
        }

    }
    else if([sender tag] == 1) {
       
        if ([strStatus isEqualToString:@"B"] && [self.txtRemark.text length] == 0) {
            
            [self.view makeToast:@"Please Enter Remark."];
        }
        
        else {
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    strPlanId,@"PlanId",
                                    strStatus,@"Status",
                                    nil];
            
            NSLog(@"---->>%@",params);
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL, UPDATE_PLAN_STATUS];
            
            [self changePlanDetails:strURL withParamaters:params forAction:@"status"];
            
            [self updatePlanService];
        }

    }
    
}

-(void)updatePlanService {
  
    /*
     
     {
     "PlanId":141,
     "Remark":"update by sagar",
     "StartTime":"2017-01-01T09:00:00+05:30",
     "EndTime":"2017-01-01T10:00:00+05:30"
     }
     
     */
    
    NSString *strFrom = [self convertDateTo24Hrs:[self.txtFrom text]];
    NSString *strTo =  [self convertDateTo24Hrs:[self.txtTo text]];
    
    NSString *strStartTime = [NSString stringWithFormat:@"%@T%@%@",strDate,strFrom,strTimeZone];
    NSString *strEndTime = [NSString stringWithFormat:@"%@T%@%@",strDate,strTo,strTimeZone];
    
    NSString *strRemark = [self.txtRemark text];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            strPlanId,@"PlanId",
                            strRemark,@"Remark",
                            strStartTime,@"StartTime",
                            strEndTime,@"EndTime",
                            nil];
    
    NSLog(@"---->>%@",params);
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL, UPDATE_PLAN];
    
    [self changePlanDetails:strURL withParamaters:params forAction:@"update"];
    

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 1) {
            
            [self.txtFrom setText:[ary objectAtIndex:[picker selectedRowInComponent:0]]];
            [self.txtTo setText:[toTimeArr objectAtIndex:[picker selectedRowInComponent:0]+1]];
            strFromTime = [self.txtFrom text];
            strToTime = [self.txtTo text];
        }
    }
    else if (alertView.tag == 2) {
        
        if (buttonIndex == 1) {
            
            [self.txtTo setText:[ary objectAtIndex:[picker selectedRowInComponent:0]]];
            strFromTime = [self.txtFrom text];
            strToTime = [self.txtTo text];
        }
    }

    else if (alertView.tag == 3) {
        
        if (buttonIndex == 1) {
            
            /*
             
             {
             "PlanId":113,
             "Date":"2016-09-28"
             }
             
             */
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    strPlanId,@"PlanId",
                                    strDate,@"Date",
                                    nil];
            
            NSLog(@"---->>%@",params);
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL, DELETE_PLAN];
            
            [self changePlanDetails:strURL withParamaters:params forAction:@"delete"];
            
        }
    }
}


#pragma mark - consume Webservice

-(void)changePlanDetails :(NSString *)strURL withParamaters:(NSDictionary *)params forAction:(NSString *)actionType {
   
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:strURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            
            if([actionType isEqualToString:@"update"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self parseDataResponseUpdateObject:responseObject];
                
                });
            }
            else if([actionType isEqualToString:@"delete"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseDeleteObject:responseObject];
                    
                });
            }
            else if([actionType isEqualToString:@"status"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseStatusObject:responseObject];
                    
                });
            }

            NSLog(@"------->> %@",responseObject);
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

-(void)parseDataResponseUpdateObject:(NSDictionary *)dictionary {

    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            planMutableDict = [[NSMutableDictionary alloc]init];
            
            [planMutableDict setObject:[self.planDict objectForKey:@"AgentId"] forKey:@"AgentId"];
            [planMutableDict setObject:[self.planDict objectForKey:@"AgentName"] forKey:@"AgentName"];
            [planMutableDict setObject:[self convertDateTo24Hrs:[self.txtTo text]] forKey:@"EndTime"];
            [planMutableDict setObject:[self.planDict objectForKey:@"PlanId"] forKey:@"PlanId"];
            [planMutableDict setObject:[self.txtRemark text] forKey:@"Remark"];
            [planMutableDict setObject:[self convertDateTo24Hrs:[self.txtFrom text]] forKey:@"StartTime"];
            [planMutableDict setObject:[self.planDict objectForKey:@"Status"] forKey:@"Status"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if([_delegate respondsToSelector:@selector(updateSelectedPlan: ForDay: withAction:)]) {
                
                [_delegate updateSelectedPlan:planMutableDict ForDay:strDate withAction:@"update"];
                
            }

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


-(void)parseDataResponseDeleteObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            planMutableDict = [[NSMutableDictionary alloc]init];
            [planMutableDict setObject:[self.planDict objectForKey:@"PlanId"] forKey:@"PlanId"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if([_delegate respondsToSelector:@selector(updateSelectedPlan: ForDay: withAction:)]) {
                
                [_delegate updateSelectedPlan:planMutableDict ForDay:strDate withAction:@"delete"];
                
            }
            
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

-(void)parseDataResponseStatusObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            planMutableDict = [[NSMutableDictionary alloc]init];
            
            [planMutableDict setObject:[self.planDict objectForKey:@"AgentId"] forKey:@"AgentId"];
            [planMutableDict setObject:[self.planDict objectForKey:@"AgentName"] forKey:@"AgentName"];
            [planMutableDict setObject:[self.planDict objectForKey:@"EndTime"] forKey:@"EndTime"];
            [planMutableDict setObject:[self.planDict objectForKey:@"StartTime"] forKey:@"StartTime"];
            [planMutableDict setObject:[self convertDateTo24Hrs:[self.txtTo text]] forKey:@"EndTime"]; //EndTime
            [planMutableDict setObject:[self.planDict objectForKey:@"PlanId"] forKey:@"PlanId"];
            [planMutableDict setObject:[self.txtRemark text] forKey:@"Remark"];
            [planMutableDict setObject:strStatus forKey:@"Status"];
            
            if([_delegate respondsToSelector:@selector(updateSelectedPlan: ForDay: withAction:)]) {
                
                [_delegate updateSelectedPlan:planMutableDict ForDay:strDate withAction:@"status"];
                
            }
            
            [self hideHud];
            
        }
        
    }
    else {
        [self hideHud];
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            strStatus = [self.planDict objectForKey:@"Status"];
            [self setStatusButton:strStatus];
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

-(NSString *) convertDateTo12Hrs :(NSString *)strDate1 {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:strDate1];
    
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    
    //NSLog(@"----->>%@", pmamDateString);
    return pmamDateString;
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



-(void)setStatusButton :(NSString *)status {
    
    if ([status isEqualToString:@"B"]) {
        
        [self.btnB setBackgroundColor:selectedColor];
        [self.btnO setBackgroundColor:deselectedColor];
        [self.btnX setBackgroundColor:deselectedColor];
        
        [self.btnO setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        [self.btnX setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        
    }
    else if ([status isEqualToString:@"O"]) {
        
        [self.btnB setBackgroundColor:deselectedColor];
        [self.btnO setBackgroundColor:selectedColor];
        [self.btnX setBackgroundColor:deselectedColor];
        
        [self.btnO setImageTintColor:selectedTintColor forState:UIControlStateNormal];
        [self.btnX setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        
    }
    else if ([status isEqualToString:@"X"]) {
        
        [self.btnB setBackgroundColor:deselectedColor];
        [self.btnO setBackgroundColor:deselectedColor];
        [self.btnX setBackgroundColor:selectedColor];
        
        [self.btnO setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        [self.btnX setImageTintColor:selectedTintColor forState:UIControlStateNormal];
        
    }
    else {
        [self.btnB setBackgroundColor:deselectedColor];
        [self.btnO setBackgroundColor:deselectedColor];
        [self.btnX setBackgroundColor:deselectedColor];
        
        [self.btnO setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        [self.btnX setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
    }
    

}

-(BOOL)checkFutureDate {
    
    BOOL isTrue;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDate* enteredDate = [df dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"strDate"]];

    NSDate *currentDate = [NSDate date];
    
    if ([currentDate timeIntervalSince1970] >= [enteredDate timeIntervalSince1970]) {
        
        isTrue = YES;
    }
    else {
        
        isTrue = NO;
    }
    return isTrue;
}


-(BOOL)checkPastDate {
    
    BOOL isTrue = NO;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDate* enteredDate = [df dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"strDate"]];
    NSDate * today = [NSDate date];
    
    NSComparisonResult result = [today compare:enteredDate];
    
    switch (result)
    {
        case NSOrderedAscending:
            NSLog(@"Future Date");
            isTrue = YES;
            break;
        case NSOrderedDescending:
            NSLog(@"Earlier Date");
            isTrue = NO;
            break;
        case NSOrderedSame:
            NSLog(@"Today/Null Date Passed"); //Not sure why This is case when null/wrong date is passed
            isTrue = NO;
            break;
    }
    return isTrue;
}


@end
