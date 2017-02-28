//
//  LoginViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagePassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtEmployeeID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnContactUS;
- (IBAction)btnContactUs:(id)sender;
@end
