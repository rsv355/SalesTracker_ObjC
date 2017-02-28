//
//  AgentViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AgentViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIButton+tintImage.h"
#import "AgentTableViewCell.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "AddAgentViewController.h"

@interface AgentViewController ()<MFMailComposeViewControllerDelegate, AddAgentViewControllerDelegate, UITextFieldDelegate>
{
    MFMailComposeViewController *mailComposer;
    AgentTableViewCell *cell;
    MBProgressHUD *hud;
    NSDictionary *userDetails;
    NSArray *agentArr, *agentInfoArr;
    NSMutableArray *agentDeleteArr;
    NSMutableArray *agentSearchArr;
}
@end

@implementation AgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"];
    [self setLayout];
    [self fetchAgentListFromWebServices];
   // [self.txtSearchAgent addTarget:self action:@selector(textFieldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
     self.searchViewHeightConstraints.constant = 0.0f;
    self.btnSearch.tag= 1;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Desing Setup method

-(void)setLayout {
  
    [self.btnBack setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSearch setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAddAgent setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.btnAddAgent.hidden = YES;
    [self.btnAddAgent.layer setCornerRadius:30];
    [self setShadowFor:self.btnAddAgent];
}

-(void) setShadowFor:(UIButton *)button {
    
    button.layer.masksToBounds = NO;
    button.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
 
    button.layer.shadowOpacity = 0.8;
    
    button.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:button.bounds];
    button.imageView.layer.shadowPath = path.CGPath;

}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [agentInfoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(AgentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.btnChecked.layer.cornerRadius = 2.0f;
    if ([[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"] != [NSNull null]) {
        [cell.lblAgentName setText:[[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"]];
       
    }
    else {
        [cell.lblAgentName setText:@""];
         [cell.btnChecked setTitle:@"" forState:UIControlStateNormal];
    }
    NSString *strRegion,*strBranchName;
    if ([[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"RegionName"] != [NSNull null]) {
        strRegion =[@", " stringByAppendingString:[[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"RegionName"]];
    }
    else {
        strRegion = @"";
    }
    if ([[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"] != [NSNull null]) {
        strBranchName = [[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"];
    }
    else {
        strBranchName = @"";
    }
    
    if ([[agentDeleteArr objectAtIndex:indexPath.row] integerValue] == 0 ) {
      
        [cell.btnChecked setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.btnChecked setTitle:[[[agentInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"] substringToIndex:1] forState:UIControlStateNormal];
    }
    else {
      
        [cell.btnChecked setImage:[UIImage imageNamed:@"ic_check_white_24dp.png"] forState:UIControlStateNormal];
    }
    cell.lblAgentLocation.text = [strBranchName stringByAppendingString:strRegion];
    
    cell.btnCall.tag = indexPath.row;
    cell.btnSendMail.tag = indexPath.row;
    cell.btnChecked.tag = indexPath.row;
    
    [cell.btnCall addTarget:(id)self action:@selector(btnCall:) forControlEvents:UIControlEventTouchDown];
    [cell.btnSendMail addTarget:(id)self action:@selector(btnSendMail:) forControlEvents:UIControlEventTouchDown];
    //[cell.btnChecked addTarget:(id)self action:@selector(btnChecked:) forControlEvents:UIControlEventTouchDown];
    
    return  cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddAgentViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_AGENT"];
    viewController.strAddAgentMode = 0;
    viewController.agentInfoDict = [agentInfoArr objectAtIndex:indexPath.row];
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
    
}

#pragma  mark - UITableView UIButton IBAction methods

-(void) btnChecked:(id)sender {

    [self.btnSearch setTitle:@"Delete" forState:UIControlStateNormal];
    
    if ([[agentDeleteArr objectAtIndex:[sender tag]] integerValue] == 0) {
        [agentDeleteArr replaceObjectAtIndex:[sender tag] withObject:[[agentInfoArr objectAtIndex:[sender tag]] objectForKey:@"AgentID"]];
    }
    else {
        [agentDeleteArr replaceObjectAtIndex:[sender tag] withObject:@"0"];
    }
    [self.tableView reloadData];
    int deleteCount = 0;
    for (int i = 0; i<[agentDeleteArr count]; i++) {
        if ([[agentDeleteArr objectAtIndex:i] integerValue] != 0) {
            deleteCount += 1;
        }
    }
    if (deleteCount>0) {
        self.btnSearch.tag = 0;
        [self.btnSearch setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btnSearch setTitle:@"Delete" forState:UIControlStateNormal];
        self.btnSearchWidthContraint.constant = 100.0f;
    }
    else {
        self.btnSearch.tag = 1;
        [self.btnSearch setImage:[UIImage imageNamed:@"ic_search_white_24dp.png"] forState:UIControlStateNormal];
        self.btnSearchWidthContraint.constant = 40.0f;
    }
    NSLog(@">>%d",deleteCount);
}

-(void)btnCall:(id)sender {
  
    if ([[agentInfoArr objectAtIndex:[sender tag]] objectForKey:@"MobileNo"] != [NSNull null]) {
        NSString *strMobileNo = [[agentArr objectAtIndex:[sender tag]] objectForKey:@"MobileNo"];
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:strMobileNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

-(void)btnSendMail:(id)sender {
    if ([[agentInfoArr objectAtIndex:[sender tag]] objectForKey:@"Emailid"] != [NSNull null]) {
        NSString *strEmailID = [[agentArr objectAtIndex:[sender tag]] objectForKey:@"Emailid"];
        NSString *emailTitle = @"Test Email";
        // Email Content
        NSString *messageBody = @"TESTING : iOS programming is so fun!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:strEmailID];
        
        mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:emailTitle];
        [mailComposer setMessageBody:messageBody isHTML:NO];
        [mailComposer setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mailComposer animated:YES completion:NULL];
        
    }
}

- (IBAction)btnAddAgent:(id)sender {
    
    AddAgentViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_AGENT"];
    viewController.strAddAgentMode = 1;
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIButton IBAction methods

- (IBAction)btnSearch:(id)sender {
    
    if (self.btnSearch.tag == 0) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Are you sure want to delete this agent?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.tag = 100;
        [alertView show];
    }
    else if (self.btnSearch.tag == 1) {
        
        self.searchViewHeightConstraints.constant = 44.0f;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            //[self deleteAgentService];
            NSMutableArray *idArr = [[NSMutableArray alloc] init];
            for (int i = 0; i<[agentDeleteArr count]; i++) {
                if ([[agentDeleteArr objectAtIndex:i] integerValue] != 0) {
                    [idArr addObject:[agentDeleteArr objectAtIndex:i]];
                }
            }
            [self deleteAgentService:idArr];
        }
    }
}
- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) deleteAgentService:(NSMutableArray *)idArr {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     
     {
     "AgentID":[1,2,3]
     }
     
     */
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            idArr,@"AgentID",
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
-(void)parseDataResponseObjectForUpdateAgent:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
            
            [self viewDidLoad];
            [self hideHud];
            self.btnSearch.tag = 1;
        }
        
    }
    else {
        
        [self hideHud];
        
        self.btnSearch.tag = 1;

        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
        }
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
        }
    }
    
}

#pragma mark - Consume Web services

-(void)fetchAgentListFromWebServices {

    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@empid=%@",BASE_URL,AGENT_LIST,[userDetails objectForKey:@"Userid"]]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@empid=%@",BASE_URL,AGENT_LIST,[userDetails objectForKey:@"Userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                if ([[dictionary objectForKey:@"data"] objectForKey:@"Agents"] != [NSNull null]) {
                    
                    agentArr = [[dictionary objectForKey:@"data"] objectForKey:@"Agents"];
                    agentInfoArr = [NSArray arrayWithArray:agentArr];
                    agentDeleteArr  = [[NSMutableArray alloc]init];
                    for (int i=0 ; i<[agentArr count]; i++) {
                        [agentDeleteArr addObject:@"0"];
    
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        [self.tableView reloadData];
                    });
                    
                    [self hideHud];
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


#pragma mark  - MBProgressHUD methods

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

#pragma mark - UIViewController custom delegate methods

-(void)updateNewAgentInList {
    [self viewDidLoad];
}

/*-(void)textFieldBeginEditing:(UITextField *)textField{
    
   // NSLog(@">>%@", textField.text);
    
    agentSearchArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [agentArr count]; i++) {
        
        if ([[[agentArr objectAtIndex:i] objectForKey:@"Name"] containsString:textField.text] == YES) {
            
           // NSLog(@"---- %@", [[agentArr objectAtIndex:i] objectForKey:@"Name"] );
            
        }
        
        
    }
}
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    //NSLog(@">>%@", self.txtSearchAgent.text);

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)txtOk:(id)sender {
    
    NSLog(@">>----%@",self.txtSearchAgent.text);
    
    agentSearchArr = [[NSMutableArray alloc]init];
    
    NSString *strSearch = self.txtSearchAgent.text;
    
    if(strSearch.length == 0) {
       
        self.searchViewHeightConstraints.constant = 0.0f;
        agentInfoArr = [NSArray arrayWithArray:agentArr];
        
        [self.tableView reloadData];
        
        [self.view endEditing:YES];
           }
    else {
        for (int i = 0; i < [agentArr count]; i++) {
            
            NSString *strName = [[agentArr objectAtIndex:i] objectForKey:@"Name"];
            
            
            if ([[strName lowercaseString] rangeOfString:[strSearch lowercaseString]].location != NSNotFound) {
                
                NSLog(@"contains-->> %@",strName);
                [agentSearchArr addObject:[agentArr objectAtIndex:i]];
            }
            else {
                
                NSLog(@"Do not contain-->> %@",strName);
                
            }
            agentInfoArr = [agentSearchArr copy];
            [self.tableView reloadData];
            
            NSLog(@"RESULT ARRAY ------- >> %@",agentSearchArr);
            
        }

    }
}
@end
