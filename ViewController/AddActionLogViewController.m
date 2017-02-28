//
//  AddActionLogViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AddActionLogViewController.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"

@interface AddActionLogViewController ()<UIDocumentPickerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *hud;
    
    NSArray *agentNameArr, *departmentArr,*inChargeArr, *priorityArr;
    
    NSMutableArray *filterArray;
    NSString *strURL;
    
    NSString *strAgentName, *strAgentID, *strDepartmentName, *strDepartmentID, *strIncharge, *strPriority, *strDescription, *strFileName;
    
    UIImage *image1;
    NSString *letters, *randomString;
    NSString  *fullPath;
}
@end

@implementation AddActionLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnAddBottomConstraint.constant = 15.0f;
    
    _txtAgentName.delegate = self;
    _txtAgentName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    filterArray = [[NSMutableArray alloc]init];
    
    priorityArr = [[NSArray alloc] initWithObjects:@"High", @"Medium", @"Low", nil];
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    randomString = [self randomStringWithLength:10];
    
    strAgentID = @"";
    strAgentName = @"";
    strDepartmentName = @"";
    strDepartmentID = @"";
    strPriority  = @"";
    strIncharge = @"";
    strFileName = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@empid=%@",AGENT_LIST,[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Userid"]];
        
        [self fetchAgentListFromWebServices:urlStr :@"agent" parameter:nil];
    });
    
    _tableView.hidden = YES;
    
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
    if (textField != _txtAgentName) {
        UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(20, 10, 320, 40)];
        
        keyboardToolBar.barStyle = UIBarStyleBlackOpaque;
        [keyboardToolBar setTintColor:[UIColor whiteColor]];
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                    
                                    [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                    nil]];
        textField.inputAccessoryView = keyboardToolBar;
        
    }
    
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

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString1 = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString1 appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString1;
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
            
            if ([strURL isEqualToString:@"agent"]) {
                if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                    if ([[dictionary objectForKey:@"data"] objectForKey:@"Agents"] != [NSNull null]) {
                        
                        agentNameArr = [[dictionary objectForKey:@"data"] objectForKey:@"Agents"];
                        NSLog(@"---->>> %@",agentNameArr);
                        [self hideHud];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self fetchAgentListFromWebServices:FETCH_DEPARTMENT :@"department" parameter:nil];
                        });
                    }
                }
            }
            else if ([strURL isEqualToString:@"department"]) {
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
                UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 100)];
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

#pragma mark - UITableview Delegate & Datasource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgentCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[filterArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
    cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14] ;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    strAgentID = [[filterArray objectAtIndex:indexPath.row] objectForKey:@"AgentID"];
    
    _txtAgentName.text = [[filterArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
    [filterArray removeAllObjects];
    _txtAgentName.clearButtonMode = UITextFieldViewModeNever;
    _tableView.hidden = YES;
    [_tableView reloadData];
    
}

#pragma mark - UITextfield Delegate Method

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    _txtAgentName.text = nil;
    [filterArray removeAllObjects];
    _tableView.hidden = YES;
    [_tableView reloadData];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtAgentName) {
        
        
        [filterArray removeAllObjects];
        
        NSString *strTextField = [NSString stringWithString:textField.text];
        
        strTextField = [strTextField
                        stringByReplacingCharactersInRange:range withString:string];
        
        
        if ([strTextField isEqualToString:@""]) {
            _tableView.hidden = YES;
        }
        else
        {
            _tableView.hidden = NO;
            _txtAgentName.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            
            for(NSDictionary *dict in agentNameArr)
            {
                NSRange substringRange = [[[dict objectForKey:@"Name"] lowercaseString] rangeOfString:[strTextField lowercaseString]];
                if (substringRange.location == 0) {
                    [filterArray addObject:dict];
                }
            }
        }
        
        [_tableView reloadData];

    }
    return YES;
}

#pragma mark - Drop Down UIAlertview methods

- (IBAction)btnSelection:(id)sender {
    
    if ([sender tag] == 3) {
        if ([strDepartmentID length] == 0) {
            
            [self.view makeToast:@"Please select department first"];
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self fetchInChargeService:strDepartmentID];
            });
        }
    }   
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"LIST OF DATA" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 100)];
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
    if (pickerView.tag == 1) {
        arrCount = [agentNameArr count];
    }
    else if (pickerView.tag == 2) {
        arrCount = [departmentArr count];
    }
    else if (pickerView.tag == 3) {
        arrCount = [inChargeArr count];
    }
    else  {
        arrCount = [priorityArr count];
    }
    return arrCount;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle;
    
    if (pickerView.tag == 1) {
        strTitle = [[agentNameArr objectAtIndex:row] objectForKey:@"Name"];
    }
    else if (pickerView.tag == 2) {
        strTitle = [[departmentArr objectAtIndex:row] objectForKey:@"Department"];
    }
    else if (pickerView.tag == 3) {
        strTitle = [[inChargeArr objectAtIndex:row] objectForKey:@"PicName"];
    }
    else  {
        strTitle = [priorityArr objectAtIndex:row];
    }
    
    return strTitle;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView.tag == 1) {
    
        strAgentID = [[agentNameArr objectAtIndex:row] objectForKey:@"AgentID"];
        strAgentName = [[agentNameArr objectAtIndex:row] objectForKey:@"Name"];
    }
    else if (pickerView.tag == 2) {
        strDepartmentName = [[departmentArr objectAtIndex:row] objectForKey:@"Department"];
        strDepartmentID = [[departmentArr objectAtIndex:row] objectForKey:@"DepartmentID"];
    }
    else if (pickerView.tag == 3) {
        strIncharge = [[inChargeArr objectAtIndex:row] objectForKey:@"PicName"];
    }
    else  {
        strPriority = [priorityArr objectAtIndex:row];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            if ([strAgentName length] !=0) {
                
                [self.txtAgentName setText:strAgentName];
            }
            else {
                strAgentID = [[agentNameArr objectAtIndex:0] objectForKey:@"AgentID"];
                strAgentName = [[agentNameArr objectAtIndex:0] objectForKey:@"Name"];
                [self.txtAgentName setText:strAgentName];
            }
            
        }
        else {
            if([self.txtAgentName.text length] ==0) {
                
                strAgentID = @"";
                strAgentName = @"";
            }
            
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            if ([strDepartmentName length] !=0) {
                
                [self.txtDepatmentName setText:strDepartmentName];
            }
            else {
                strDepartmentName = [[departmentArr objectAtIndex:0] objectForKey:@"Department"];
                strDepartmentID = [[departmentArr objectAtIndex:0] objectForKey:@"DepartmentID"];
                [self.txtDepatmentName setText:strDepartmentName];
                
            }
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
            if ([strIncharge length] !=0) {
                
                [self.txtInChargeName setText:strIncharge];
            }
            else {
                strIncharge = [[inChargeArr objectAtIndex:0] objectForKey:@"PicName"];
                [self.txtInChargeName setText:strIncharge];
            }
            
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
                strPriority = [priorityArr objectAtIndex:0];
                [self.txtPriorityName setText:strPriority];
            }
        }
        else {
            if ([self.txtPriorityName.text length] ==0) {
                
                strPriority = @"";
            }
            
        }
    }
}


#pragma  mark - Add Action Log IBAction method

- (IBAction)btnAddActionLog:(id)sender {
    
    strDescription = [self.txtDescription text];
    
    NSString *userID = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Userid"];
   
    if ([strAgentID length]==0 || [strDepartmentID length]==0 ||[strDepartmentName length]==0 ||[strIncharge length]==0 ||[strPriority length]==0 ||[strDescription length]==0) {
        
        [self.view makeToast:@"Please fill up all data"];
    }
    else {
        
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /*
         {
         "UserId":"699",
         "AgentId":132,
         "Description":"Lorem porem",
         "Status":"",
         "Priroty":"High",
         "File":"amg.action.jpeg",
         "DepartmentId":5,
         "PicName":"manoj"
         }
         
         */
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                userID,@"UserId",
                                userID,@"LastUpdatedUserId",
                                strAgentID,@"AgentId",
                                strDescription,@"Description",
                                @"",@"Status",
                                strPriority,@"Priroty",
                                strFileName,@"File",
                                strDepartmentID,@"DepartmentId",
                                strIncharge,@"PicName",
                                nil];
        NSLog(@">>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_ACTIONLOG]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_ACTIONLOG] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObjectForActionLog:responseObject];
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


-(void)parseDataResponseObjectForActionLog:(NSDictionary *)dictionary {
    NSLog(@"ADDD---- %@",dictionary);
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            [self hideHud];
            [self dismissViewControllerAnimated:YES completion:nil];
            if([_delegate respondsToSelector:@selector(updateActionLogInList)]) {
                
                [_delegate updateActionLogInList];
                
            }
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

#pragma  mark - Upload File IBAction method

-(void)btnUploadFile:(id)sender {
    
    
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
-(void) uploadFileAtPath :(NSString *)path {
    
    
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
