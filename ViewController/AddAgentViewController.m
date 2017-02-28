//
//  AddAgentViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AddAgentViewController.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface AddAgentViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *hud;
    
    NSString *strAgentName, *strTierID, *strBranchID, *strPhoneNo, *strEmailID, *strKruniaNo, *strAMGNo, *strDescription, *strSelection, *strAgentID;
    NSArray *tierArr, *branchArr;
    NSArray *pickerData;
    NSMutableArray *ary;
}
@end

@implementation AddAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.txtAgentName.delegate = (id)self;
    self.btnEditBottomConstraint.constant = 15.0f;
   
   
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchSelectionBranch];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self fetchSelectionTier];
    });
    
    strTierID = @"0";
    strBranchID = @"0";
    
    if (_strAddAgentMode == 1) {
        
        [self.btnDelete setHidden:YES];
        [self.btnEdit setTitle:@"Add Agent" forState:UIControlStateNormal];
    }
    
    else {
        [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [self.btnDelete setHidden:YES];
        [self setUserInteraction:NO];
        if ([_agentInfoDict objectForKey:@"Name"] !=nil) {
            [self.txtAgentName setText:[_agentInfoDict objectForKey:@"Name"]];
        }
        if ([_agentInfoDict objectForKey:@"MobileNo"] !=nil) {
            [self.txtPhoneNo setText:[_agentInfoDict objectForKey:@"MobileNo"]];
        }
        if ([_agentInfoDict objectForKey:@"Emailid"] !=nil) {
            [self.txtEmailId setText:[_agentInfoDict objectForKey:@"Emailid"]];
        }
        if ([_agentInfoDict objectForKey:@"KruniaCode"] !=nil) {
            [self.txtKruniaNo setText:[_agentInfoDict objectForKey:@"KruniaCode"]];
        }
        if ([_agentInfoDict objectForKey:@"AmgCode"] !=nil) {
            [self.txtAMGNo setText:[_agentInfoDict objectForKey:@"AmgCode"]];
        }
        if ([_agentInfoDict objectForKey:@"Description"] !=nil) {
            [self.txtDescription setText:[_agentInfoDict objectForKey:@"Description"]];
        }
        if ([_agentInfoDict objectForKey:@"AgentID"] !=nil) {
            strAgentID = [_agentInfoDict objectForKey:@"AgentID"];
        }
        if ([_agentInfoDict objectForKey:@"AgentID"] !=nil) {
            strAgentID = [_agentInfoDict objectForKey:@"AgentID"];
        }
        if ([_agentInfoDict objectForKey:@"Tierid"] !=nil) {
            strTierID = [_agentInfoDict objectForKey:@"Tierid"];
        }
        if ([_agentInfoDict objectForKey:@"BranchName"] !=nil) {
            [self.txtBranchName setText:[_agentInfoDict objectForKey:@"BranchName"]];
            [self.btnSelectBranch setUserInteractionEnabled:NO];
        }
        
    }
    strSelection = @"tier";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIKeyboard methods

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField

{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(20, 10, 320, 40)];
    
    keyboardToolBar.barStyle = UIBarStyleBlackOpaque;
    [keyboardToolBar setTintColor:[UIColor whiteColor]];
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

-(void)resignKeyboard{
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [textField resignFirstResponder];
    return YES;
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
    if([_delegate respondsToSelector:@selector(updateNewAgentInList)]) {
        
        [_delegate updateNewAgentInList];
        
    }
}


#pragma mark - Agent Operation methods

-(void) setUserInteraction : (BOOL)isTrue {
    
     [self.txtAgentName setUserInteractionEnabled:isTrue];
     [self.btnSelectTier setUserInteractionEnabled:isTrue];
     [self.txtPhoneNo setUserInteractionEnabled:isTrue];
     [self.txtEmailId setUserInteractionEnabled:isTrue];
     [self.txtKruniaNo setUserInteractionEnabled:isTrue];
     [self.txtAMGNo setUserInteractionEnabled:isTrue];
     [self.txtDescription setUserInteractionEnabled:isTrue];
    
}
- (IBAction)btnUpdate:(id)sender {
  
    strAgentName = [self.txtAgentName text];
    strPhoneNo = [self.txtPhoneNo text];
    strEmailID = [self.txtEmailId text];
    strKruniaNo = [self.txtKruniaNo text];
    strAMGNo = [self.txtAMGNo text];
    strDescription = [self.txtDescription text];
    
    if (self.strAddAgentMode == 1) {
        
        [self addAgentWebService];
    }
    else {
        
        if (self.btnEdit.tag == 0) {
            self.btnEdit.tag = 1;
            [self.btnEdit setTitle:@"UPDATE" forState:UIControlStateNormal];
            [self setUserInteraction:YES];
            [self.txtAgentName becomeFirstResponder];
        }
        else {
//            [self.btnEdit setTitle:@"EDIT" forState:UIControlStateNormal];
//            [self setUserInteraction:NO];
            [self updateAgentDetailsWebService];
        }
    }
    
}

-(void) addAgentWebService {
    
    if ([strAgentName length] == 0 || [strPhoneNo length] == 0 || [strEmailID length] == 0 || [strKruniaNo length] == 0 || [strAMGNo length] == 0 || [strDescription length] == 0 || [strTierID integerValue] == 0 || [strBranchID integerValue] == 0) {
//        NSLog(@"%@ %@",strTierID,strBranchID);
        [self.view makeToast:@"Please fill up all the fields."];
    }
    else if (![self validateEmail:strEmailID]) {
        [self.view makeToast:@"Enter valid email id."];
    }
    else if ([strPhoneNo length] != 10) {
        [self.view makeToast:@"Please enter valid phone no."];
    }
    else {
        
        NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        /*
         
         {
         "AgentName":"axay",
         "TierId":2,
         "BranchId":43,
         "MobileNo":"9898989898",
         "EmailId":"mkt223@amg.com",
         "AmgCode":"AMG345",
         "KruniaCode":"KR345",
         "Description":"Any description",
         "UserId":676
         }
         
         */
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strAgentName,@"AgentName",
                                strTierID,@"TierId",
                                strBranchID,@"BranchId",
                                strPhoneNo,@"MobileNo",
                                strEmailID,@"EmailId",
                                strAMGNo,@"AmgCode",
                                strKruniaNo,@"KruniaCode",
                                strDescription,@"Description",
                                userID,@"UserId",
                                nil];
        
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_AGENT]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_AGENT] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObjectForAddAgent:responseObject];
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
-(void) updateAgentDetailsWebService {
    
    if ([strAgentName length] == 0 || [strPhoneNo length] == 0 || [strEmailID length] == 0 || [strKruniaNo length] == 0 || [strAMGNo length] == 0 || [strDescription length] == 0 || [strTierID integerValue] == 0 ) {
        NSLog(@">> %@",strTierID);
        [self.view makeToast:@"Please fill up all the fields."];
    }
    else if (![self validateEmail:strEmailID]) {
        [self.view makeToast:@"Enter valid email id."];
    }
    else if ([strPhoneNo length] != 10) {
        [self.view makeToast:@"Please enter valid phone no."];
    }
    else {
        
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /*
         
         {
         "AgentName":"abc",
         "TierId":2,
         "MobileNo":"9898989898",
         "EmailId":"mkt223@amg.com",
         "AmgCode":"Code",
         “KruniaCode":"Code",
         "Description":"Any description",
         "AgentId":200
         }

         */
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strAgentName,@"AgentName",
                                strTierID,@"TierId",
                                strPhoneNo,@"MobileNo",
                                strEmailID,@"EmailId",
                                strAMGNo,@"AmgCode",
                                strKruniaNo,@"KruniaCode",
                                strDescription,@"Description",
                                strAgentID,@"AgentId",
                                nil];
        
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_AGENT]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_AGENT] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (responseObject != [NSNull null]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self parseDataResponseObjectForUpdateAgent:responseObject];
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

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if([textField.text length]<50) {
        return YES;
    }
    else
        return NO;
    
    
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

#pragma mark - UIButton selection buttons 


- (IBAction)btnSelectTier:(id)sender {

    ary = [[NSMutableArray alloc]init];
    strSelection = @"tier";

    if (tierArr >0) {
        for (int i = 0; i<[tierArr count]; i++) {
            [ary addObject:[[tierArr objectAtIndex:i] objectForKey:@"TierName"]];
            NSLog(@"----->> %@",[[tierArr objectAtIndex:i] objectForKey:@"TierName"]);
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Select Tier :" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
        picker.delegate = (id)self;
        picker.dataSource = (id)self;
        [alert addSubview:picker];
        picker.tag = 1;
        alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
        [alert setValue:picker forKey:@"accessoryView"];
        [alert show];
        

    }

}

-(void)btnSelectBranch:(id)sender {
    
    ary = [[NSMutableArray alloc]init];
    strSelection = @"branch";
//    [self fetchSelectionArray:BRANCH_LIST for:@"branch"];
    
    if ([branchArr count] >0) {
       
        for (int i = 0; i<[branchArr count]; i++) {
            [ary addObject:[[branchArr objectAtIndex:i] objectForKey:@"BranchName"]];
            //        NSLog(@"----->> %@",[[branchArr objectAtIndex:i] objectForKey:@"BranchName"]);
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"LIST OF DATA" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
        picker.delegate = (id)self;
        picker.dataSource = (id)self;
        picker.tag = 2;
        [alert addSubview:picker];
        alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
        [alert setValue:picker forKey:@"accessoryView"];
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
    return [ary count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ary[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"SELECTED >> %@", [ary objectAtIndex:row]);
    if (pickerView.tag ==1) {
      
        [self.txtTierName setText:[ary objectAtIndex:row]];
        strTierID = [[tierArr objectAtIndex:row] objectForKey:@"Teirid"];
    }
    else {
        if (pickerView.tag ==2) {
            [self.txtBranchName setText:[ary objectAtIndex:row]];
            strBranchID = [[branchArr objectAtIndex:row] objectForKey:@"BranchId"];
        }
    }
}

#pragma mark - CALL Web Services for selection

-(void) fetchSelectionBranch {
    
    [self showHud];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@",BASE_URL,BRANCH_LIST]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,BRANCH_LIST] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responseArr != nil ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForBranch:responseArr];
            });
        }
        
        else {
//            [self hideHud];
            [self.view makeToast:@"Incorrect!!"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR------>> %@",error);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}
-(void)parseDataResponseObjectForBranch:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            
                    if ([[dictionary objectForKey:@"data"] objectForKey:@"Branches"] != [NSNull null]) {
                        branchArr = [[dictionary objectForKey:@"data"] objectForKey:@"Branches"];
                    }
             
//                 [self hideHud];
               
            }
            
            
        }
        
    }
    else {
//         [self hideHud];
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
        }
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
        }
    }
   
}
-(void) fetchSelectionTier {
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@",BASE_URL,TIER_LIST]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,TIER_LIST] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responseArr != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForTier:responseArr];
            });
        }
        
        else {
            [self hideHud];
            [self.view makeToast:@"Incorrect!!"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR------>> %@",error);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}
-(void)parseDataResponseObjectForTier:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                
                    if ([[dictionary objectForKey:@"data"] objectForKey:@"Tiers"] != [NSNull null]) {
                        tierArr = [[dictionary objectForKey:@"data"] objectForKey:@"Tiers"];
                        //NSLog(@">>%@",tierArr);
                        if (_strAddAgentMode == 0) {
                            for (int i=0; i<[tierArr count]; i++) {
                                if ([[[tierArr objectAtIndex:i] objectForKey:@"Teirid"] integerValue] == [[_agentInfoDict objectForKey:@"Tierid"] integerValue]) {
                            
                                    if ([[tierArr objectAtIndex:i] objectForKey:@"TierName"]!= [NSNull null]) {
                                        [self.txtTierName setText:[[tierArr objectAtIndex:i] objectForKey:@"TierName"]];
                                    }
                                
                                }
                            }
                        }
                        
                    }
                
                [self hideHud];
                
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

-(void)parseDataResponseObjectForAddAgent:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
            [self dismissViewControllerAnimated:YES completion:nil];
            if([_delegate respondsToSelector:@selector(updateNewAgentInList)]) {
                
                    [_delegate updateNewAgentInList];
                
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
-(void)parseDataResponseObjectForUpdateAgent:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
            [self dismissViewControllerAnimated:YES completion:nil];
            if([_delegate respondsToSelector:@selector(updateNewAgentInList)]) {
                
                [_delegate updateNewAgentInList];
                
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


- (IBAction)btnDelete:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Are you sure want to delete this agent?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.tag = 100;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            [self deleteAgentService];
        }
    }
}


-(void) deleteAgentService {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     
     {
     "AgentID":[1,2,3]
     }
     
     */
    NSArray *agentIDs = [[NSArray alloc]initWithObjects:strAgentID, nil];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            agentIDs,@"AgentID",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_AGENT]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_AGENT] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForUpdateAgent:responseObject];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"-----%@",textField.text);
}
@end
