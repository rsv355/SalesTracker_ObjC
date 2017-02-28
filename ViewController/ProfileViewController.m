//
//  ProfileViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIButton+tintImage.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface ProfileViewController ()
{
    NSMutableDictionary *userDetails;
    MBProgressHUD *hud;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btnBack setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnEditBottomConstraint.constant = 15.0f;
    userDetails = [[NSMutableDictionary alloc]init];
    userDetails = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"];
    [self.txtName setText:[userDetails objectForKey:@"FirstName"]];
    [self.txtPosition setText:[userDetails objectForKey:@"Pos_name"]];
    [self.txtPhoneNo setText:[userDetails objectForKey:@"Mobile"]];
    [self.txtEmailID setText:[userDetails objectForKey:@"Email"]];
    [self.txtBranch setText:[userDetails objectForKey:@"Branch_name"]];
    
    NSArray * Allregion=[userDetails objectForKey:@"AllRegion"];

    NSString* str= [[Allregion valueForKey:@"Region"] componentsJoinedByString: @","];
    
    
    [self.txtRegion setText:str];

  /* 
   
   NSLog(@"all region%@",Allregion);
   NSString *temp;

   
   for (int i=0; i<Allregion.count; i++) {
        
        NSString * region=[NSString stringWithFormat:@"%@",[[Allregion objectAtIndex:i] valueForKey:@"Region"]];
        NSLog(@"%@",region);
        
        if ([Allregion objectAtIndex:0]) {
            
            temp=[temp stringByAppendingString:region];

        }else{
            temp=[temp stringByAppendingString:region];
        }
        
    }*/
    
    [self setTextFieldUserInteractionEnable:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)resignKeyboard {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
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

#pragma mark - UIButton IBAction methods 

- (IBAction)btnUpdate:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.btnEdit.tag == 0) {
        
        [self setTextFieldUserInteractionEnable:YES];
        [self.btnEdit setTitle:@"UPDATE" forState:UIControlStateNormal];
        [self.btnEdit setTag:1];
        [self.txtName becomeFirstResponder];
    }
    else {
        
        NSString *strName = [self.txtName text];
        NSString *strPhoneNo = [self.txtPhoneNo text];
        NSString *strEmailID = [self.txtEmailID text];
        NSString *userID = [userDetails objectForKey:@"Userid"];
        
        if ([strName length] == 0 || [strPhoneNo length] == 0 || [strEmailID length] == 0) {
            
            [self.view makeToast:@"Please enter all fields."];
        }
        else if(![self validateEmail:strEmailID]) {
            
            [self.view makeToast:@"Please enter valid email id."];
        }
        else if ([strPhoneNo length] != 10) {
            
            [self.view makeToast:@"Enter valid phone no."];
        }
        else {
           
            [self showHud];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            /*
             {
             "Name":"Xitij Patel",
             "Phone":9978923080,
             "EmailId":"dddddd@live.com",
             "UserId":699
             }
             */

            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    strName,@"Name",
                                    strPhoneNo,@"Phone",
                                    strEmailID,@"EmailId",
                                    userID,@"UserId",
                                    nil];
            
            NSLog(@"---->>%@",params);
            manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_PROFILE]);
            
            [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_PROFILE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                if (responseObject != [NSNull null]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        [self parseDataResponseObject:responseObject];
                    });
                    
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
}

-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
   
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            
            userDetails = [NSMutableDictionary dictionaryWithDictionary:userDetails];
            [userDetails setValue:[self.txtName text] forKey:@"FirstName"];
            
            [userDetails setValue:[self.txtEmailID text] forKey:@"Email"];
            
            [userDetails setValue:[self.txtPhoneNo text] forKey:@"Mobile"];
            
            [[NSUserDefaults standardUserDefaults] setObject:userDetails forKey:@"userDetails"];
            [self dismissViewControllerAnimated:YES completion:nil];
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
    }
    [self hideHud];
}

-(void)setTextFieldUserInteractionEnable:(BOOL)isEnable {
    
    [self.txtName setUserInteractionEnabled:isEnable];
    [self.txtPhoneNo setUserInteractionEnabled:isEnable];
    [self.txtEmailID setUserInteractionEnabled:isEnable];
    
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

@end
