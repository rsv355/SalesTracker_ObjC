//
//  UpdateActionLogViewController.m
//  SalesTracker
//
//  Created by webmyne on 09/01/17.
//  Copyright © 2017 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "UpdateActionLogViewController.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "App_Constant.h"
#import "UIView+Toast.h"

@interface UpdateActionLogViewController ()<UIDocumentPickerDelegate>
{
    MBProgressHUD *hud;
    UIPickerView *picker ;
    
    NSArray *agentNameArr, *departmentArr,*inChargeArr, *priorityArr, *statusArr;
    
    NSMutableArray *filterArray;
    NSString *strURL;
    
    NSString *strAgentName, *strAgentID, *strDepartmentName, *strDepartmentID, *strIncharge, *strInchargeID, *strPriority, *strStatus, *strStatusId, *strDescription,*strFileName;
    
    UIImage *image1;
    NSString *letters, *randomString;
    NSString  *fullPath;
    
}
@end

@implementation UpdateActionLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"PassedActionDictionary:- %@",_actionDict);
    statusArr = [[NSArray alloc]initWithObjects:@"Approval",@"Completed",@"Reject",@"Pending", nil];
    priorityArr = [[NSArray alloc] initWithObjects:@"High", @"Medium", @"Low", nil];
    
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    randomString = [self randomStringWithLength:10];

    
    [self checkActionLogStatus];
    
    [self displayData];
    [_txtAgentName setUserInteractionEnabled:NO];
    
    [self fetchAgentListFromWebServices:FETCH_DEPARTMENT :@"department" parameter:nil];
    
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString1 = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString1 appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) checkActionLogStatus {
    
    NSString *positionId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Roleid"];

        
    NSString *currentPositionId = [self.actionDict objectForKey:@"PositionId"];
            
        if ([currentPositionId isEqualToString:MARKETER_ROLE_ID] && ([positionId isEqualToString:HOS_ROLE_ID] || [positionId isEqualToString:BM_ROLE_ID] || [positionId isEqualToString:RM_ROLE_ID])) {
                
            
            [self.btnStatus setUserInteractionEnabled:YES];
            }
            else if ([currentPositionId isEqualToString:AAS_ROLE_ID] && ([positionId isEqualToString:HOS_ROLE_ID] || [positionId isEqualToString:BM_ROLE_ID] || [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnStatus setUserInteractionEnabled:YES];
            }
            else if ([currentPositionId isEqualToString:HOS_ROLE_ID] && ( [positionId isEqualToString:BM_ROLE_ID] || [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnStatus setUserInteractionEnabled:YES];
            }
            else if ([currentPositionId isEqualToString:BM_ROLE_ID] && ( [positionId isEqualToString:RM_ROLE_ID])) {
                
                  [self.btnStatus setUserInteractionEnabled:YES];
            }
            else if ([currentPositionId isEqualToString:RM_ROLE_ID] && ( [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnStatus setUserInteractionEnabled:YES];
            }
            else {
                 [self.btnStatus setUserInteractionEnabled:NO];            }
}


-(void)displayData
{
    
    strDepartmentID = [_actionDict valueForKey:@"DepartmentId"];
    strInchargeID = [_actionDict valueForKey:@"PICId"];
    strStatus = [_actionDict valueForKey:@"Status"];
    strStatusId = [_actionDict valueForKey:@"Status"];
    strFileName=[_actionDict valueForKey:@"Attachment"];
    
    _txtAgentName.text = [_actionDict valueForKey:@"AgentName"];
    _txtDepatmentName.text = [_actionDict valueForKey:@"DepartmentName"];
    _txtInChargeName.text = [_actionDict valueForKey:@"PICName"];
    _txtPriorityName.text = [_actionDict valueForKey:@"Priority"];
    _txtFileName.text=[_actionDict valueForKey:@"Attachment"];
    
    if ([strStatus isEqualToString:@"A"]) {
        _txtStatus.text = @"Approval";
    }
    else if ([strStatus isEqualToString:@"R"]){
        _txtStatus.text = @"Reject";
    }
    else if ([strStatus isEqualToString:@"C"]){
        _txtStatus.text = @"Completed";
    }
    else if ([strStatus isEqualToString:@"OG"] || [strStatus isEqualToString:@"P"]){
        _txtStatus.text = @"Pending";
    }
    
    //_txtDescription.text = [_actionDict valueForKey:@"Description"];
    
    
    
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

-(void)resignKeyboard{
    
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
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.frame.size.width, self.scrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Button Action
-(IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)btnUpdateActionLog:(id)sender {
    
    strDescription = [self.txtDescription text];
    
    NSString *userID = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Userid"];
    
    NSString *actionLogID = [[[_actionDict objectForKey:@"Id"] componentsSeparatedByString:@"_"] lastObject];
    
    if ([_txtDepatmentName.text length]==0 ||[_txtInChargeName.text length]==0 ||[_txtPriorityName.text length]==0 ||[_txtStatus.text length]==0 ||[_txtDescription.text length]==0) {
        
        [self.view makeToast:@"Please fill up all data"];
    }
    else {
        
        
//        NSLog(@"-------Update Action Log--------");
//        NSLog(@"UserId = %@",userID);
//        NSLog(@"Description = %@",strDescription);
//        NSLog(@"ActionlogId = %@",[_actionDict valueForKey:@"Id"]);
//        NSLog(@"Status = %@",_txtStatus.text);
//        NSLog(@"StatusID = %@",strStatusId);
//        NSLog(@"DepartmentID = %@",strDepartmentID);
//        NSLog(@"PicId = %@",strInchargeID);
//        NSLog(@"-------Update Action Log--------");
        
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /*
         
         {
         "UserId": 1276,
         "Description": "Remark rrrrrrm",
         "ActionLogId": 328,
         "Status": "C",
         "DepartmentId": 3,
         "PicId": 1165,
         "Priority": "High"
         }
         
         */
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                userID,@"UserId",
                                strDescription,@"Description",
                                actionLogID,@"ActionLogId",
                                strStatusId,@"Status",
                                strDepartmentID,@"DepartmentId",
                                strInchargeID,@"PicId",
                                _txtPriorityName.text,@"Priority",
                                strFileName,@"File",

                                nil];
        NSLog(@"ActionLogId>>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_ACTIONLOG]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_ACTIONLOG] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObjectForEdit:responseObject];
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

-(void)parseDataResponseObjectForEdit:(NSDictionary *)dictionary {
    
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
             [self.view makeToast:@"Action Log successfully updated."];
            
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DASHBOARD"];
            [self presentViewController:viewController animated:YES completion:nil];
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


#pragma mark - Drop Down Alertview method

- (IBAction)txtFileName:(id)sender {
}


- (IBAction)btnSelection:(id)sender {
    
    if ([sender tag] == 3) {
        [self fetchInChargeService:strDepartmentID];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"LIST OF DATA" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 100)];
        picker.delegate = (id)self;
        picker.dataSource = (id)self;
        picker.tag = [sender tag];
        [alert addSubview:picker];
        alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
        [alert setValue:picker forKey:@"accessoryView"];
        alert.tag = [sender tag];
        [alert show];
        
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
    NSInteger arrCount;
    
    if (pickerView.tag == 2) {
        arrCount = [departmentArr count];
    }
    else if (pickerView.tag == 3) {
        arrCount = [inChargeArr count];
    }
    else if (pickerView.tag == 4) {
        arrCount = [priorityArr count];
    }
    else {
        arrCount = [statusArr count];
    }
    return arrCount;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle;
    
    if (pickerView.tag == 2) {
        strTitle = [[departmentArr objectAtIndex:row] objectForKey:@"Department"];
    }
    else if (pickerView.tag == 3) {
        strTitle = [[inChargeArr objectAtIndex:row] objectForKey:@"PicName"];
    }
    else  if (pickerView.tag == 4){
        strTitle = [priorityArr objectAtIndex:row];
    }
    else {
        strTitle = [statusArr objectAtIndex:row];
    }
    
    return strTitle;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    /*if (pickerView.tag == 2) {
     strDepartmentName = [[departmentArr objectAtIndex:row] objectForKey:@"Department"];
     strDepartmentID = [[departmentArr objectAtIndex:row] objectForKey:@"DepartmentID"];
     }
     else if (pickerView.tag == 3) {
     strIncharge = [[inChargeArr objectAtIndex:row] objectForKey:@"PicName"];
     strInchargeID = [[inChargeArr objectAtIndex:row] objectForKey:@"PicID"];
     }
     else  if (pickerView.tag == 4){
     strPriority = [priorityArr objectAtIndex:row];
     }
     else {
     strStatus = [statusArr objectAtIndex:row];
     }
     */
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            strDepartmentName = [[departmentArr objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"Department"];
            strDepartmentID = [[departmentArr objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"DepartmentID"];
            [self.txtDepatmentName setText:strDepartmentName];
            
            strIncharge = @"";
            [self.txtInChargeName setText:@""];
        }
        else {
            if ([self.txtDepatmentName.text length] == 0) {
                
                strDepartmentID = @"";
                strDepartmentName = @"";
            }
            
        }
    }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 1)
        {
            strIncharge = [[inChargeArr objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"PicName"];
            strInchargeID = [[inChargeArr objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"PicID"];
            [self.txtInChargeName setText:strIncharge];
            
        }
        else {
            if ([self.txtInChargeName.text length] ==0) {
                
                strIncharge = @"";
            }
            
        }
    }
    if(alertView.tag == 4)
    {
        if(buttonIndex == 1)
        {
            if ([strPriority length] !=0) {
                
                [self.txtPriorityName setText:strPriority];
            }
            else {
                strPriority = [priorityArr objectAtIndex:[picker selectedRowInComponent:0]];
                [self.txtPriorityName setText:strPriority];
            }
        }
        else {
            if ([self.txtPriorityName.text length] ==0) {
                
                strPriority = @"";
            }
            
        }
    }
    
    if(alertView.tag == 5)
    {
        if(buttonIndex == 1)
        {
            
            strStatus = [statusArr objectAtIndex:[picker selectedRowInComponent:0]];
            [self.txtStatus setText:strStatus];
            
            if ([strStatus isEqualToString:@"Approval"]) {
                strStatusId = @"A";
            }
            else if ([strStatus isEqualToString:@"Complete"]){
                strStatusId = @"C";
            }
            else if ([strStatus isEqualToString:@"Reject"]){
                strStatusId = @"R";
            }
            else {
                strStatusId = @"OG";
            }
        }
//        else {
//            if ([self.txtStatus.text length] ==0) {
//                
//                strStatus = @"";
//            }
//            
//        }
    }
    
    
}


#pragma mark - Consume Web services

-(void)fetchAgentListFromWebServices :(NSString *)URL_CALL :(NSString *)selection parameter:(NSDictionary *)params {
    
    
    strURL = selection;
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@",BASE_URL,URL_CALL]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_CALL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responsDict != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responsDict];
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
    
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            if ([strURL isEqualToString:@"department"]) {
                if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                    if ([[dictionary objectForKey:@"data"] objectForKey:@"Department"] != [NSNull null]) {
                        
                        departmentArr = [[dictionary objectForKey:@"data"] objectForKey:@"Department"];
                        NSLog(@">> %ld",(unsigned long)[departmentArr count]);
                        [self hideHud];
                        
                        
                    }
                }
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

-(void) fetchInChargeService :(NSString *)paramsID {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     {
     "DepartmentId": "5"
     }
     */
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            paramsID,@"DepartmentId",
                            nil];
    NSLog(@">>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_INCAHRGE]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_INCAHRGE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForInchagrge:responseObject];
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
-(void)parseDataResponseObjectForInchagrge:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            if ([[dictionary objectForKey:@"data"] objectForKey:@"DepartmentPic"] != [NSNull null]) {
                
                inChargeArr = [[dictionary objectForKey:@"data"] objectForKey:@"DepartmentPic"];
                
                [self hideHud];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"LIST OF DATA" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 100)];
                picker.delegate = (id)self;
                picker.dataSource = (id)self;
                picker.tag = 3;
                [alert addSubview:picker];
                alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
                [alert setValue:picker forKey:@"accessoryView"];
                alert.tag = 3;
                [alert show];
                
                
                
            }
        }
        
        
    }
    else {
        [self hideHud];
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            //            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sales Tracker" message:@"No Incharge Found" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alertView show];
        }
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
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

#pragma  mark - Upload File IBAction method

- (IBAction)btnUploadFile:(id)sender {
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload File"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Photo Gallery",@"Upload From iCloud", nil];
    [actionSheet setTag:2];
    [actionSheet showInView:[self view]];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if (buttonIndex == 2) {
        
        [self importFileFromDrive];
    }
}


-(void)importFileFromDrive {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        NSString *alertMessage = [NSString stringWithFormat:@"Successfully imported %@", [url lastPathComponent]];
        NSLog(@"Imported ::>> %@",url);
        
        strFileName = [url lastPathComponent];
        
        [self uploadFileAtPath:[NSString stringWithFormat:@"%@",url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Import"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}
-(void) uploadFileAtPath :(NSString *)path
{
    
    NSString *actualPath = [path stringByReplacingOccurrencesOfString:@"file:///private/" withString:@""];
    
    actualPath = [actualPath stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    NSLog(@"Full path .. >>%@", actualPath);
    
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SCRFTPRequest *ftpRequest = [SCRFTPRequest requestWithURL:[NSURL URLWithString:FTP_URL] toUploadFile:actualPath];
        
        ftpRequest.username = FTP_USERNAME;
        ftpRequest.password = FTP_PASSWORD;
        //ftpRequest.customUploadFileName = @"ConductCare3.png";
        ftpRequest.delegate = self;
        [ftpRequest startAsynchronous];
        
    });
    
    
}


/*
 *
 * Cancelled
 *
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Cancelled");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"------");
    NSData *webData;
    NSString *strImageName;
    
    strImageName = [NSString stringWithFormat:@"%@_%@_iOSImage.jpg",[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Userid"],randomString];
    strFileName = strImageName;
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    webData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:strImageName];
    [webData writeToFile:localFilePath atomically:YES];
    NSLog(@"localFilePath.%@",localFilePath);
    
    fullPath = localFilePath;
    image1 = [UIImage imageWithContentsOfFile:localFilePath];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImageAtPath:fullPath];
    
}
#pragma mark - FTP Upload Image methods

-(void) uploadImageAtPath :(NSString *)path {
    
    NSLog(@"fullPAth...... %@",path);
    
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SCRFTPRequest *ftpRequest = [SCRFTPRequest requestWithURL:[NSURL URLWithString:FTP_URL] toUploadFile:path];
        
        ftpRequest.username = FTP_USERNAME;
        ftpRequest.password = FTP_PASSWORD;
        //ftpRequest.customUploadFileName = @"ConductCare3.png";
        ftpRequest.delegate = self;
        [ftpRequest startAsynchronous];
        
    });
    
    
}
- (void)ftpRequestWillStart:(SCRFTPRequest *)request
{
    NSLog(@"started");
}

- (void)ftpRequest:(SCRFTPRequest *)request didChangeStatus:(SCRFTPRequestStatus)status

{
    NSLog(@"didChanged");
}

- (void)ftpRequest:(SCRFTPRequest *)request didWriteBytes:(NSUInteger)bytesWritten
{
    // NSLog(@"didWrited");
}
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request

{
    [self.txtFileName setText:strFileName];
    [self.view makeToast:@"File Uploaded Successfully."];
    [self hideHud];
}

- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error);
    strFileName = @"";
    [self.view makeToast:@"File Upload Failed. Please Try Again."];
    [self hideHud];
}





@end
