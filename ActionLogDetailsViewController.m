//
//  ActionLogDetailsViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ActionLogDetailsViewController.h"
#import "ActionLogTableViewCell.h"
#import "UITextView+Placeholder.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "AFNetworking.h"
#import "App_Constant.h"
#import "CommonWebViewViewController.h"
#import "UpdateActionLogViewController.h"


@interface ActionLogDetailsViewController ()
{
    ActionLogTableViewCell *cell;
    MBProgressHUD *hud;
    NSArray *titleArr, *dataArr;
}
@end

@implementation ActionLogDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleArr = [[NSArray alloc]initWithObjects:@"Agent Name",@"User",@"Description",@"Date Raised",@"Status",@"Department",@"Department In-Charge",@"SLA",@"Last Updated",@"Approved Date",@"Attachment", nil];
    
    self.tableViewHeightConstraints.constant = 48*[titleArr count];
   
    [self checkActionLogStatus];
    
}

-(void) checkActionLogStatus {
    
    NSLog(@"%@",[_actionLogDict valueForKey:@"Status"]);
    if ([[_actionLogDict valueForKey:@"Status"] isEqualToString:@"R"] || [[_actionLogDict valueForKey:@"Status"] isEqualToString:@"A"] || [[_actionLogDict valueForKey:@"Status"] isEqualToString:@"C"]) {
        
        [self.btnReject setHidden:YES];
        [self.btnApprove setHidden:YES];
    }
    else {
        
        NSString *positionId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Roleid"];
        
        NSString *strUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"]objectForKey:@"Userid"];
        
        if ([[_actionLogDict valueForKey:@"CreaterId"] isEqualToString:strUserID]) {
            
            [self.btnReject setHidden:YES];
            [self.btnApprove setHidden:YES];
        }
        else if ([[_actionLogDict valueForKey:@"PositionId"] isEqualToString:positionId]) {
            
            [self.btnReject setHidden:YES];
            [self.btnApprove setHidden:YES];
        }
        else {
          
            NSString *currentPositionId = [self.actionLogDict objectForKey:@"PositionId"];
            
            if ([currentPositionId isEqualToString:MARKETER_ROLE_ID] && ([positionId isEqualToString:AAS_ROLE_ID] ||[positionId isEqualToString:HOS_ROLE_ID] || [positionId isEqualToString:BM_ROLE_ID] || [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnReject setHidden:NO];
                [self.btnApprove setHidden:NO];
            }
            else if ([currentPositionId isEqualToString:AAS_ROLE_ID] && ([positionId isEqualToString:HOS_ROLE_ID] || [positionId isEqualToString:BM_ROLE_ID] || [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnReject setHidden:NO];
                [self.btnApprove setHidden:NO];
            }
            else if ([currentPositionId isEqualToString:HOS_ROLE_ID] && ( [positionId isEqualToString:BM_ROLE_ID] || [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnReject setHidden:NO];
                [self.btnApprove setHidden:NO];
            }
            else if ([currentPositionId isEqualToString:BM_ROLE_ID] && ( [positionId isEqualToString:RM_ROLE_ID])) {
                
                [self.btnReject setHidden:NO];
                [self.btnApprove setHidden:NO];
            }
            else {
                [self.btnReject setHidden:YES];
                [self.btnApprove setHidden:YES];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(ActionLogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.lblDetailTitle.text = [titleArr objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            if ([self.actionLogDict objectForKey:@"AgentName"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"AgentName"];
            }
            break;
        case 1:
            if ([self.actionLogDict objectForKey:@"CreaterName"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"CreaterName"];
            }
            break;
        case 2:
            if ([self.actionLogDict objectForKey:@"Description"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"Description"];
            }
            break;
        case 3:
            if ([self.actionLogDict objectForKey:@"CreatedDatetime"] != [NSNull null]) {
                
               
               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                
                NSDate *date = [[NSDate alloc] init];
                
                date = [dateFormatter dateFromString:[self.actionLogDict objectForKey:@"CreatedDatetime"]];
                
                dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd MMMM,yyyy hh:mm a"];
                
                 cell.lblDetails.text = [dateFormatter stringFromDate:date];
            }
            break;
        case 4:
            if ([self.actionLogDict objectForKey:@"Status"] != [NSNull null]) {
                
                if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"C"]) {
                    
                    [cell.lblDetails setText:C];
                }
                else if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"P"]) {
                    
                    [cell.lblDetails setText:P];
                }
                else if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"R"]) {
                    
                    [cell.lblDetails setText:R];
                }
                else if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"PR"]) {
                    
                    [cell.lblDetails setText:PR];
                }
                else if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"OD"]) {
                    
                    [cell.lblDetails setText:OD];
                }
                else if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"OG"]) {
                    
                    [cell.lblDetails setText:A];
                }
                else if ([[self.actionLogDict objectForKey:@"Status"] isEqualToString:@"A"]) {
                    
                    [cell.lblDetails setText:OG];
                }
            }
            break;
        case 5:
            if ([self.actionLogDict objectForKey:@"DepartmentName"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"DepartmentName"];
            }
            break;
        case 6:
            if ([self.actionLogDict objectForKey:@"PICName"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"PICName"];
            }
            break;
        case 7:
            if ([self.actionLogDict objectForKey:@"Sla"] != [NSNull null]) {
                
                cell.lblDetails.text = [NSString stringWithFormat:@"%@ Days",[self.actionLogDict objectForKey:@"Sla"]];
            }
            break;
        case 8:
            if ([self.actionLogDict objectForKey:@"UpdatedDatetime"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"UpdatedDatetime"];
            }
            break;
        case 9:
            if ([self.actionLogDict objectForKey:@"ApprovedDateAndBy"] != [NSNull null]) {
                
                if ([[self.actionLogDict objectForKey:@"ApprovedDateAndBy"] isEqualToString:@"0"]) {
                    
                    cell.lblDetails.text = @"Yet Not Approved";
                }
                else {
                    cell.lblDetails.text = [self.actionLogDict objectForKey:@"ApprovedDateAndBy"];
                }
            }
            break;
        case 10:
            if ([self.actionLogDict objectForKey:@"Attachment"] != [NSNull null]) {
                
                cell.lblDetails.text = [self.actionLogDict objectForKey:@"Attachment"];
            }
            break;
        default:
            break;
    }
    
    return  cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 10) {
        
        if ([self.actionLogDict objectForKey:@"Attachment"] != [NSNull null]) {
            
            CommonWebViewViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COMMON_WEBVIEW"];
            viewController.strHeader = @"Action Log Attachment";
            
            NSString *attachment = [self.actionLogDict objectForKey:@"Attachment"];
            
            
            viewController.strURL = [NSString stringWithFormat:@"%@%@",ACTION_LOG_PATH,[attachment stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSLog(@"Attachment---- %@",[NSString stringWithFormat:@"%@%@",ACTION_LOG_PATH,[attachment stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]);
            viewController.strWebviewType = WEBVIEW_TYPE_URL;
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if([_delegate respondsToSelector:@selector(updateActionLogRemark)]) {
        
        [_delegate updateActionLogRemark];
        
    }
    
}


- (IBAction)btnAddRemark:(id)sender {
    UIAlertView *testAlert = [[UIAlertView alloc] initWithTitle:@"Add New Remark"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    testAlert.alertViewStyle =  UIAlertViewStylePlainTextInput;
    [testAlert textFieldAtIndex:0].placeholder = @"Description";
    testAlert.tag = 1;
    [testAlert show];
}

#pragma - Mark UIAlertView methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            UITextField *txtField = [alertView textFieldAtIndex:0];
            [txtField resignFirstResponder];
            if(txtField.text.length ==0) {
                
                [self.view makeToast:@"Please enter something"];
            }
            else {
                [self showHud];
                
                NSString *strDescription = txtField.text ;
                NSString *agentID = [[[_actionLogDict objectForKey:@"Id"] componentsSeparatedByString:@"_"] lastObject];
                NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"]objectForKey:@"Userid"];
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                /*
                 {
                 "UserId":691,
                 "Description":"Remark rrrrrrm",
                 "ActionLogId":130
                 }
                 */
                
                NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        userID,@"UserId",
                                        strDescription,@"Description",
                                        agentID,@"ActionLogId",
                                        nil];
                
                NSLog(@"---->>%@",params);
                manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_REMARK]);
                
                [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,ADD_REMARK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    if (responseObject != [NSNull null]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self parseDataResponseObject:responseObject];
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
    }
}
-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
   
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            [self hideHud];
            
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


- (IBAction)btnReopenAction:(id)sender {
    
    NSString *status;
    
    if ([sender tag] == 0) {
        
        status = @"A";
    }
    else {
        status = @"R";
    }
    
    [self showHud];
    
    NSString *strReopenID = [[[self.actionLogDict objectForKey:@"Id"] componentsSeparatedByString:@"_"] lastObject];
    NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"]objectForKey:@"Userid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     {
     "UserId":691,
     "Description":"Remark rrrrrrm",
     "ActionLogId":130
     }
     */
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:strReopenID,@"ActionId",status,@"Status",userID,@"UserId",nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,CHANGE_ACTION_LOG]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,CHANGE_ACTION_LOG] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responseObject];
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


       
    

- (IBAction)btnEditActionLog:(id)sender {
    
       
    
    UpdateActionLogViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UPDATE_ACTION_LOG"];
    viewController.actionDict = _actionLogDict;
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
