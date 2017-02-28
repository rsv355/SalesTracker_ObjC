//
//  LoginViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "App_Constant.h"

@interface LoginViewController ()
{
     MBProgressHUD *hud;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setLayout {
   
    UIImage *image1 = [[UIImage imageNamed:@"ic_account.png"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // put UIImage in a UIImageView and adjust color with tintColor
    [self.imageEmail setImage:image1];
    self.imageEmail.tintColor =[UIColor colorWithRed:(86/225.0) green:(86/225.0) blue:(86/225.0) alpha:1.0f];
    
    UIImage *image2 = [[UIImage imageNamed:@"ic_password.png"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // put UIImage in a UIImageView and adjust color with tintColor
    [self.imagePassword setImage:image2];
    self.imagePassword.tintColor =[UIColor colorWithRed:(86/225.0) green:(86/225.0) blue:(86/225.0) alpha:1.0f];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)btnLogin:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *strEmployeeID = [self.txtEmployeeID text];
    NSString *strPassword = [self.txtPassword text];
    NSString *strDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Device_Token"];
    
    if (strDeviceToken==nil)
    {
        strDeviceToken=@"0";
    }
    
    if ([strEmployeeID length] == 0 || [strPassword length] == 0) {
        
        [self.view makeToast:@"Please enter all fields."];
    }
    else if( [strPassword length] < 8) {
        
     [self.view makeToast:@"Password must be of minimum 8 digit"];
    }
    else {
        
        [self showHud];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        /*
         {
         "username": "head",
         "password": "head@123",
         "type": "IOS",
         "token": "I1254",
         "islogin":"true"
         }
         */
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strEmployeeID,@"username",
                                strPassword,@"password",
                                DEVICE_TYPE,@"type",
                                strDeviceToken,@"token",
                                @"true",@"islogin",
                                nil];
        
        NSLog(@"---->>%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,USER_LOGIN]);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,USER_LOGIN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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


-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            if ([dictionary objectForKey:@"Data"] != [NSNull null])
            {
                NSDictionary *userDetail = [dictionary objectForKey:@"Data"];
                
                    [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"userDetails"];
                    UIViewController *viewCotnroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DASHBOARD"];
                    [self presentViewController:viewCotnroller animated:YES completion:nil];
                
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
    }
    [self hideHud];
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


- (IBAction)btnContactUs:(id)sender {
}

@end
