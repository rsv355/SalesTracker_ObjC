//
//  AddEmployeeViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 17/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AddEmployeeViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "SalesTracker_AppURL.h"
#import "App_Constant.h"


@interface AddEmployeeViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *hud;
    NSDictionary *userDetails;

    NSString *strEmployeeID, *strEmployeeName, *strPositionID, *strPhoneNo, *strEmailID,*strRegionID;

    NSString * selected_position,*selected_Region;
    NSMutableArray * picker_array;
    NSInteger Btn_Delete_State;
    
    NSMutableArray * AllRegion;
}
@end

@implementation AddEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Btn_Delete_State=-1;
    
    [_txt_EmployeeId setDelegate:self];
    [_txt_EmployeeName setDelegate:self];
    [_txt_PhoneNumber setDelegate:self];
    [_txt_EmailAdress setDelegate:self];

  //  selected_position=[_employeeInfoDict objectForKey:@"Position"];
  //  selected_Region=[_employeeInfoDict objectForKey:@"Region"];

    
    userDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"];
    
    NSLog(@"user data...:%@",userDetails);
    
    NSLog(@"employee info dic....%@",_employeeInfoDict);
    
    
    
    if (_strAddEmployeeMode == 1)
    {
        AllRegion=[[NSMutableArray alloc]init];
        
        AllRegion=[userDetails objectForKey:@"AllRegion"];

        
        [self.Btn_Delete setHidden:YES];
        [self.Btn_Edit setTitle:@"ADD" forState:UIControlStateNormal];
        self.lbl_EmployeeProfile.text=@"Add Employee";
        
        
        //-------------show and hide select region-----------------------
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]) {
            
            self.SelectRegionHeightConstraint.constant=41.0f;
            self.SelectRegionView.hidden=NO;
            
        }
        else{
            
            self.SelectRegionHeightConstraint.constant=0.0f;
            self.SelectRegionView.hidden=YES;
            
        }
        
        
    }
    
    else
    {
        
        
     //-------------show and hide select region-----------------------
//        
//        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]) {
//            
//            self.SelectRegionHeightConstraint.constant=41.0f;
//            self.SelectRegionView.hidden=NO;
//            
//        }
//        else{
        
            self.SelectRegionHeightConstraint.constant=0.0f;
            self.SelectRegionView.hidden=YES;
            
 //       }

        
        
        
        [self.Btn_SelectPosition setUserInteractionEnabled:NO];
        [self.BtnSelectRegion setUserInteractionEnabled:NO];

        
        [self.Btn_Edit setTitle:@"EDIT" forState:UIControlStateNormal];
        [self.Btn_Delete setHidden:YES];
        [self setUserInteraction:NO];
        NSLog(@"employee dics:%@",_employeeInfoDict);
        
        if ([_employeeInfoDict objectForKey:@"EmpId"] !=nil) {
            [self.txt_EmployeeId setText:[_employeeInfoDict objectForKey:@"EmpId"]];
        }
        if ([_employeeInfoDict objectForKey:@"Name"] !=nil) {
            [self.txt_EmployeeName setText:[_employeeInfoDict objectForKey:@"Name"]];
        }
        //--------------------------set position----------------------
        if ([[_employeeInfoDict objectForKey:@"Position"] isEqualToString:MARKETER_ROLE_ID])
        {
            [self.txt_SelectPosition setText:MARKETER_POSITION_NAME];
        }
        if ([[_employeeInfoDict objectForKey:@"Position"] isEqualToString:AAS_ROLE_ID])
        {
            [self.txt_SelectPosition setText:AAS_POSITION_NAME];

        }

        if ([[_employeeInfoDict objectForKey:@"Position"] isEqualToString:HOS_ROLE_ID])
        {
            [self.txt_SelectPosition setText:HOS_POSITION_NAME];

        }
        if ([[_employeeInfoDict objectForKey:@"Position"] isEqualToString:BM_ROLE_ID])
        {
            [self.txt_SelectPosition setText:BM_POSITION_NAME];

        }
        if ([[_employeeInfoDict objectForKey:@"Position"] isEqualToString:RM_ROLE_ID])
        {
            [self.txt_SelectPosition setText:RM_POSITION_NAME];

        }
        
        
        //--------------------------set Region----------------------

        if ([_employeeInfoDict objectForKey:@"Region"] != nil)
        {
            [self.txtSelectRegion setText:[_employeeInfoDict objectForKey:@"Region"]];
            
            selected_Region=[_employeeInfoDict objectForKey:@"Region"];
            
        }
        
        //--------------------------set All region arr----------------------

        
        if ([_employeeInfoDict objectForKey:@"Region"] != nil)
        {
            AllRegion=[[NSMutableArray alloc]init];

            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setValue:[_employeeInfoDict objectForKey:@"Region"] forKey:@"Region"];
            
            [AllRegion addObject:dict];
        }
        


        
        if ([_employeeInfoDict objectForKey:@"Phone"] !=nil) {
            [self.txt_PhoneNumber setText:[_employeeInfoDict objectForKey:@"Phone"]];
        }
        if ([_employeeInfoDict objectForKey:@"EmailId"] !=nil) {
            [self.txt_EmailAdress setText:[_employeeInfoDict objectForKey:@"EmailId"]];
        }
        
    }
    // Do any additional setup after loading the view.
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

-(void)resignKeyboard {
    
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
    [self.ScrollView setContentSize:CGSizeMake (self.ScrollView.frame.size.width, self.ScrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
}


-(void) setUserInteraction : (BOOL)isTrue {
    
    [self.txt_EmployeeId setUserInteractionEnabled:isTrue];
    [self.txt_EmployeeName setUserInteractionEnabled:isTrue];
    [self.txt_SelectPosition setUserInteractionEnabled:isTrue];
    [self.txt_PhoneNumber setUserInteractionEnabled:isTrue];
    [self.txt_EmailAdress setUserInteractionEnabled:isTrue];
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Btn_SelectPosition:(id)sender

{
    picker_array=[[NSMutableArray alloc]init];
    if ([[userDetails objectForKey:@"Pos_name"]isEqualToString:HOS_POSITION_NAME])
    {
        [picker_array addObject:MARKETER_POSITION_NAME];
        [picker_array addObject:AAS_POSITION_NAME];

    }
    if ([[userDetails objectForKey:@"Pos_name"]isEqualToString:BM_POSITION_NAME])
    {
        [picker_array addObject:HOS_POSITION_NAME];
        [picker_array addObject:MARKETER_POSITION_NAME];
        [picker_array addObject:AAS_POSITION_NAME];

    }
    if ([[userDetails objectForKey:@"Pos_name"]isEqualToString:RM_POSITION_NAME])
    {
        [picker_array addObject:BM_POSITION_NAME];
        [picker_array addObject:HOS_POSITION_NAME];
        [picker_array addObject:AAS_POSITION_NAME];
        [picker_array addObject:MARKETER_POSITION_NAME];
    }

    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Select Position :" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alertView.tag=200;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alertView.bounds.size.height, 320, 216)];
    picker.delegate = (id)self;
    picker.dataSource = (id)self;
    [alertView addSubview:picker];
    picker.tag = 1;
    alertView.bounds = CGRectMake(0, 0, 320 + 20, alertView.bounds.size.height + 216 + 20);
    [alertView setValue:picker forKey:@"accessoryView"];
    [alertView show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==300)
    {
        if (buttonIndex == 1)
        {
            
            if (selected_Region.length != 0 ) {
                
                [self.txtSelectRegion setText:selected_Region];
                
                

                for (int i=0; i<AllRegion.count; i++) {
                    
                    if ([selected_Region isEqualToString:[[AllRegion valueForKey:@"Region"]objectAtIndex:i]])
                    {
                        strRegionID=[[AllRegion valueForKey:@"RegionId"] objectAtIndex:i];
                    }
                    
                }
                
                
                selected_Region=nil;
                
            }
            else{
                
                selected_Region=[picker_array objectAtIndex:0];
                
                strRegionID=[[AllRegion valueForKey:@"RegionId"] objectAtIndex:0];
                
                [self.txtSelectRegion setText:selected_Region];
                
                
            }
        }
    
    }
    
    
    
    
   
    if (alertView.tag==200)
    {
        if (buttonIndex == 1)
        {
            
           if (selected_position.length != 0 ) {
               
               [self.txt_SelectPosition setText:selected_position];

               selected_position=nil;

           }
           else{
               
               selected_position=[picker_array objectAtIndex:0];

               [self.txt_SelectPosition setText:selected_position];
               
           
           }
            
            
            
           
            
        
            if ([selected_position isEqualToString:MARKETER_POSITION_NAME])
            {
                strPositionID=MARKETER_ROLE_ID;
            }
            if ([selected_position isEqualToString:HOS_POSITION_NAME])
            {
                strPositionID=HOS_ROLE_ID;
            }
            if ([selected_position isEqualToString:BM_POSITION_NAME])
            {
                strPositionID=BM_ROLE_ID;
            }
                
          
       }
            
    }
    
    if (alertView.tag==100)
    {
        if (buttonIndex == 1) {
            [self deleteEmployeeService];
        }
  
    }
    
    
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
    return [picker_array count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return picker_array[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"SELECTED >> %@", [picker_array objectAtIndex:row]);
    
    
    if (pickerView.tag==1) {
        
        selected_position=[picker_array objectAtIndex:row];
        //[self.txt_SelectPosition setText:[picker_array objectAtIndex:row]];
      
    }
    
    if (pickerView.tag==2) {
        
        selected_Region=[picker_array objectAtIndex:row];
        
        
       // [self.txtSelectRegion setText:[picker_array objectAtIndex:row]];
       

    }
    
   
}

#pragma mark - Button Actions


- (IBAction)BtnSelectRegion:(id)sender {
    
    picker_array=[[NSMutableArray alloc]init];

    
    for (int i=0; i<AllRegion.count; i++) {
        
        [picker_array addObject:[[AllRegion valueForKey:@ "Region"]objectAtIndex:i]];
        
    }
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Select Region :" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alertView.tag=300;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alertView.bounds.size.height, 320, 216)];
    picker.delegate = (id)self;
    picker.dataSource = (id)self;
    [alertView addSubview:picker];
    picker.tag = 2;
    alertView.bounds = CGRectMake(0, 0, 320 + 20, alertView.bounds.size.height + 216 + 20);
    [alertView setValue:picker forKey:@"accessoryView"];
    [alertView show];
    
}



- (IBAction)Btn_Back:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
    
    if([_delegate respondsToSelector:@selector(updateNewEmployeeInList)])
    {
        
        [_delegate updateNewEmployeeInList];
        
    }

}

- (IBAction)Btn_Delete:(id)sender
{
    if (Btn_Delete_State==0)
    {
        [self setUserInteraction:NO];
        [self.Btn_SelectPosition setUserInteractionEnabled:NO];
        
        [self.Btn_Delete setTitle:@"Delete" forState:UIControlStateNormal];
        [self.Btn_Edit setTitle:@"EDIT" forState:UIControlStateNormal];
        
        Btn_Delete_State=1;
        self.Btn_Edit.tag = 0;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Are you sure want to delete this employee?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.tag = 100;
        [alertView show];
    }
}
- (IBAction)Btn_Edit:(id)sender
{
    
    strEmployeeID = [self.txt_EmployeeId text];
    strEmployeeName = [self.txt_EmployeeName text];
    
   // strPositionID = [self.txt_SelectPosition text];
    strPhoneNo =[self.txt_PhoneNumber text];
    strEmailID = [self.txt_EmailAdress text];
    
    if (self.strAddEmployeeMode == 1)
    {
        
        [self addEmployeeWebService];
    }
    else
    {
        [self.Btn_SelectPosition setUserInteractionEnabled:YES];
        [self.BtnSelectRegion setUserInteractionEnabled:YES];

        
        NSLog(@"button tag is>>>%ld",(long)self.Btn_Edit.tag);
         Btn_Delete_State=0;
        
         if (self.Btn_Edit.tag == 0)
         {
             
             [self.Btn_Delete setTitle:@"Cancel" forState:UIControlStateNormal];
            
             
             strPositionID=[_employeeInfoDict objectForKey:@"Position"];

            
             self.Btn_Edit.tag = 1;
             [self.Btn_Edit setTitle:@"UPDATE" forState:UIControlStateNormal];
             [self setUserInteraction:YES];
             [self.txt_EmployeeId becomeFirstResponder];
            
         }
         else
         {
            
             NSLog(@"str pos>>>%@",strPositionID);
             [self updateAgentDetailsWebService];
         }
    }
    
}


#pragma mark - CALL Web Services for selection

-(void) deleteEmployeeService
{
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     
     {
     "AgentID":[1,2,3]
     }
     
     */
    NSArray *agentIDs = [[NSArray alloc]initWithObjects:[_employeeInfoDict objectForKey:@"Id"], nil];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            agentIDs,@"EmpId",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_EMPLOYEE]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_EMPLOYEE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForUpdateEmployee:responseObject];
            });
            NSLog(@">> %@",responseObject);
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



-(void) updateAgentDetailsWebService {
    
    if ([strEmployeeID length] == 0 || [strEmployeeName length] == 0 || [strPositionID length] == 0 || [strPhoneNo length] == 0 || [strEmailID length] == 0 )
    {
        //        NSLog(@"%@ %@",strTierID,strBranchID);
        [self.view makeToast:@"Please fill up all the fields."];
    }
    else if (![self validateEmail:strEmailID]) {
        [self.view makeToast:@"Enter valid email id."];
    }
    else if ([strPhoneNo length] != 10) {
        [self.view makeToast:@"Please enter valid phone no."];
    }
    else
    {
        
        
        NSString *userID = [_employeeInfoDict objectForKey:@"Id"];
        NSString *region = [_employeeInfoDict objectForKey:@"RegionId"];
        NSString *branch = [_employeeInfoDict objectForKey:@"BranchId"];
        
        NSString *ParentId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
        
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /*
         
         {
         "UserId":"700",
         "EmpId":"MKT_guj_001",
         "Position":"9",
         "Name":"MKT_guj_001",
         "Phone":"1212121212",
         “Email":"MKT_guj_001@gmail.com",
         
         }
         
         */
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                userID,@"UserId",
                                strEmployeeID,@"EmpId",
                                strPositionID,@"Position",
                                strEmployeeName,@"Name",
                                strPhoneNo,@"Phone",
                                strEmailID,@"Email",
                                region,@"Region",
                                branch,@"Branch",
                                ParentId,@"ParentId",

                                nil];
        
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_EMPLOYEE]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_EMPLOYEE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObjectForUpdateEmployee:responseObject];
                });
                NSLog(@">> %@",responseObject);
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
}

-(void)parseDataResponseObjectForUpdateEmployee:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
            [self dismissViewControllerAnimated:YES completion:nil];
            if([_delegate respondsToSelector:@selector(updateNewEmployeeInList)]) {
                
                [_delegate updateNewEmployeeInList];
                
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
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
        }
    }
    
}


-(void) addEmployeeWebService {
    
    if ([strEmployeeID length] == 0 || [strEmployeeName length] == 0 || [strPositionID length] == 0 || [strPhoneNo length] == 0 || [strEmailID length] == 0 )
    {
        //        NSLog(@"%@ %@",strTierID,strBranchID);
        [self.view makeToast:@"Please fill up all the fields."];
    }
    else if ([[userDetails objectForKey:@"Pos_name"] isEqualToString:RM_POSITION_NAME]){
    
        if ([strEmployeeID length] == 0 || [strEmployeeName length] == 0 || [strPositionID length] == 0 || [strPhoneNo length] == 0 || [strEmailID length] == 0 ||  [strRegionID length] == 0){
        
            [self.view makeToast:@"Please fill up all the fields."];
        
        }
        else{
        
            [self AddEmployeeWebService1];

        }
    
    }
    else if (![self validateEmail:strEmailID]) {
        [self.view makeToast:@"Enter valid email id."];
    }
    else if ([strPhoneNo length] != 10) {
        [self.view makeToast:@"Please enter valid phone no."];
    }
    else {
        
        [self AddEmployeeWebService1];
        
      /*  NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
        NSString *region =strRegionID;//[[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"RegionId"];
        NSString *branch = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Branch"];
        NSString * zero=@"0";
        
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
              NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strEmployeeID,@"EmpId",
                                strEmployeeName,@"Name",
                                strPositionID,@"Position",
                                strPhoneNo,@"Phone",
                                strEmailID,@"Email",
                                userID,@"ParentId",
                                region,@"Region",
                                branch,@"Branch",
                                zero,@"Department",
                                zero,@"Userpic",
                                zero,@"DepartmentPIC",
                                zero,@"RoleDescription",
                                zero,@"PositionName",

                                nil];
        
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_EMPLOYEE]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_EMPLOYEE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObjectForAddEmployee:responseObject];
                });
                NSLog(@">> %@",responseObject);
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
        }];*/
        
        
    }
}

-(void)AddEmployeeWebService1{


    NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
    NSString *region =strRegionID;//[[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"RegionId"];
    NSString *branch = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Branch"];
    NSString * zero=@"0";
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     
     {
     "EmpId":"MKT_guj_005",
     "Name":""MKT_guj_005,
     "Branch":51,
     "MobileNo":"9898989898",
     "EmailId":"mMKT_guj_005@gmail.com",
     "ParentId":userID,
     "Region":"KR345",
     "Branch":"",
     
     }
     
     */
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            strEmployeeID,@"EmpId",
                            strEmployeeName,@"Name",
                            strPositionID,@"Position",
                            strPhoneNo,@"Phone",
                            strEmailID,@"Email",
                            userID,@"ParentId",
                            region,@"Region",
                            branch,@"Branch",
                            zero,@"Department",
                            zero,@"Userpic",
                            zero,@"DepartmentPIC",
                            zero,@"RoleDescription",
                            zero,@"PositionName",
                            
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_EMPLOYEE]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_EMPLOYEE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForAddEmployee:responseObject];
            });
            NSLog(@">> %@",responseObject);
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





-(void)parseDataResponseObjectForAddEmployee:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
            [self dismissViewControllerAnimated:YES completion:nil];
            if([_delegate respondsToSelector:@selector(updateNewEmployeeInList)]) {
                
                [_delegate updateNewEmployeeInList];
                
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
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
        }
    }
    
}



-(BOOL) validateEmail:(NSString*) emailString{
    
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    ////NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0){
        return NO;
    }
    else
        return YES;
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
