//
//  ContactsViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 ; Systems Pvt Ltd. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import <MessageUI/MessageUI.h>


@interface ContactsViewController ()<MFMailComposeViewControllerDelegate>
{
    
    MFMailComposeViewController *mailComposer;
    ContactsTableViewCell *cell;
    MBProgressHUD *hud;
    NSString *CELL_NAME;
    NSString *branchID;
    NSArray *contactArr;
    NSArray *branchContactArr, *branchInfoArr;
    NSMutableArray *sectionNameArr, *sectionInfoArr;
    NSMutableDictionary *departmentDict;
    
    NSArray *sortedArray;
}
@end


@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchViewHeightConstraints.constant  = 0.0f;
    branchID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Branch"];
    CELL_NAME = @"DepartmentCell";
   
    self.segmentControlHeightConstraints.constant = 32.0f;
    self.segmentControl.selectedSegmentIndex = 1;

    [self fetchDepartmentContactService];
    
    
//    sortedArray = [sectionInfoArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    
//    NSLog(@"sortedArray is>>%@",sortedArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

 
 #pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([CELL_NAME isEqualToString:@"BranchCell"]) {
       
        return 1;
    }
    else {
        return [sectionInfoArr count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
    // if ([CELL_NAME isEqualToString:@"BranchCell"]) {
    //
     //    return [branchInfoArr count];
    // }
     //else {
         return [[departmentDict objectForKey:[sectionInfoArr objectAtIndex:section]] count];
     //}
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
   // if ([CELL_NAME isEqualToString:@"BranchCell"]) {
        
       // return nil;
   // }
    //else {
        return [sectionInfoArr objectAtIndex:section];

    //}
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    
     cell=(ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELL_NAME];
     
     /*if ([CELL_NAME isEqualToString:@"BranchCell"]) {
         
         if ([[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"] != [NSNull null] || [[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Position"] != [NSNull null]) {
             
             [cell.lblBranchTitle setText:[NSString stringWithFormat:@"%@ (%@)",[[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"],[[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Position"]]];
             
         }
         
         if ([[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"]) {
             [cell.btnBranchChecked setTitle:[[[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"] substringToIndex:1] forState:UIControlStateNormal];
         }
         
         if ([[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"] != [NSNull null] || [[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Region"] != [NSNull null] ) {
            
             [cell.lblBranchName setText:[NSString stringWithFormat:@"%@ (%@)",[[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"],[[branchInfoArr objectAtIndex:indexPath.row] objectForKey:@"Region"]]];
         }
         
         cell.btnBranchCall.tag = indexPath.row;
         cell.btnSendBranchMail.tag = indexPath.row;
         
         [cell.btnSendBranchMail addTarget:(id)self action:@selector(btnSendBranchMail:) forControlEvents:UIControlEventTouchDown];
         [cell.btnBranchCall addTarget:(id)self action:@selector(btnBranchCall:) forControlEvents:UIControlEventTouchDown];
     }
     else {*/
         
         NSString *sectionTitle = [sectionInfoArr objectAtIndex:indexPath.section];
         NSArray *sectionAnimals = [departmentDict objectForKey:sectionTitle];
         NSDictionary *departmentInfo = [sectionAnimals objectAtIndex:indexPath.row];
        NSLog(@"%ld---%ld--- %@",(long)indexPath.section,(long)indexPath.row,departmentInfo);
         [cell.lblDepartmentTitle setText:[departmentInfo objectForKey:@"Name"]];
         
         cell.btnDepartmentCall.tag = indexPath.row;
         cell.btnDepartmentMail.tag = indexPath.row;
         
         [cell.btnDepartmentMail addTarget:(id)self action:@selector(btnDepartmentMail:) forControlEvents:UIControlEventTouchDown];
         [cell.btnDepartmentCall addTarget:(id)self action:@selector(btnDepartmentCall:) forControlEvents:UIControlEventTouchDown];
     //}
     return  cell;

}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
     [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heightRow;
    
   // if (self.segmentControl.selectedSegmentIndex == 0) {
   //     heightRow = 73;
   // }
   // else {
        heightRow = 52;
    //}
    return heightRow;
}


#pragma mark -UITableView UIButton methods

-(void)btnSendBranchMail:(id)sender {
    
    if ([[branchInfoArr objectAtIndex:[sender tag]] objectForKey:@"Emailid"] != [NSNull null]) {
        
        NSString *strEmailID = [[branchInfoArr objectAtIndex:[sender tag]] objectForKey:@"Emailid"];
        NSString *emailTitle = @"Test Email";
    // Email Content
        NSString *messageBody = @"iOS programming is so fun!";
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

-(void)btnBranchCall:(id)sender {
    
    if ([[branchInfoArr objectAtIndex:[sender tag]] objectForKey:@"MobileNo"] != [NSNull null]) {
        NSString *strMobileNo = [[branchInfoArr objectAtIndex:[sender tag]] objectForKey:@"MobileNo"];
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:strMobileNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}
-(void)btnDepartmentMail:(id)sender {
   // NSLog(@">> %ld-----",[sender tag]);
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%ld-----%ld",(long)indexPath.section, (long)indexPath.row);
    
    NSString *sectionTitle = [sectionInfoArr objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [departmentDict objectForKey:sectionTitle];
    NSDictionary *departmentInfo = [sectionAnimals objectAtIndex:indexPath.row];

    if ([departmentInfo objectForKey:@"Emailid"] != [NSNull null]) {
      
        NSString *strEmailID = [departmentInfo objectForKey:@"Emailid"] ;
        NSString *emailTitle = @"Test Email";
        //Email Content
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

-(void)btnDepartmentCall:(id)sender {
   
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%ld-----%ld",(long)indexPath.section, (long)indexPath.row);
    
    NSString *sectionTitle = [sectionInfoArr objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [departmentDict objectForKey:sectionTitle];
    NSDictionary *departmentInfo = [sectionAnimals objectAtIndex:indexPath.row];
    
    if ([departmentInfo objectForKey:@"MobileNo"] != [NSNull null]) {
        NSString *strMobileNo = [departmentInfo objectForKey:@"MobileNo"] ;
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:strMobileNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }

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


#pragma mark - UISengment Control method 

- (IBAction)segmentControlClicked:(id)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        self.searchViewHeightConstraints.constant = 0.0f;
        self.txtSearchBar.text = @"";
        CELL_NAME = @"BranchCell";
        [self fetchBranchContactservice];
    }
    else if (self.segmentControl.selectedSegmentIndex == 1) {
        self.searchViewHeightConstraints.constant = 0.0f;
         self.txtSearchBar.text = @"";
        CELL_NAME = @"DepartmentCell";
        [self fetchDepartmentContactService];
    }
}

#pragma mark - Web Service Call

-(void)fetchBranchContactservice {
    
     [self showHud];
     
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@branch=%@",BASE_URL,BRANCH_CONTACT,branchID]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@branch=%@",BASE_URL,BRANCH_CONTACT,branchID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responseArr != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responseArr];
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
            
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                
                if ([[dictionary objectForKey:@"data"] objectForKey:@"Contacts"] != [NSNull null]) {
                    
                    branchContactArr = [[dictionary objectForKey:@"data"] objectForKey:@"Contacts"];
                    branchInfoArr = [NSArray arrayWithArray:branchContactArr];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        [self.tableView reloadData];
                    });
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
    }
    [self hideHud];
}

-(void)fetchDepartmentContactService {
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@",BASE_URL,DEPARTMENT_CONTACT]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,DEPARTMENT_CONTACT] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@">>%@",responseArr);
        if (responseArr != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForDepartment:responseArr];
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
-(void)parseDataResponseObjectForDepartment:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                
                if ([[dictionary objectForKey:@"data"] objectForKey:@"contacts"] != [NSNull null]) {
                    
                  contactArr = [[dictionary objectForKey:@"data"] objectForKey:@"contacts"];
                    
                    NSLog(@"Department-- %@",contactArr);
                    sectionNameArr = [[NSMutableArray alloc]init];
                    
                    NSMutableArray *arr = [[NSMutableArray alloc]init];

                    for (int i=0; i< [contactArr count]; i++) {
                        
                        [arr addObject:[[contactArr objectAtIndex:i] objectForKey:@"DepartmentName"]];
                    }
                    
                    NSSet *set = [NSSet setWithArray:arr];
                    
                    for(NSString *myString in set){
                        [sectionNameArr addObject:myString];
                    }
                    NSLog(@"Section--->>%@",sectionNameArr);
                    
                    sectionInfoArr = [NSMutableArray arrayWithArray:sectionNameArr];
                    NSLog(@"-------------------------------");
                    
                    sortedArray = [sectionInfoArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                    
                    sectionInfoArr=[NSMutableArray arrayWithArray:sortedArray];
                    NSLog(@"sortedArray is>>%@",sortedArray);
                    
                    
                    departmentDict = [[NSMutableDictionary alloc]init];
                    
                    for (int i =0 ; i< [sectionNameArr count]; i++) {
                        NSMutableArray *ary = [[NSMutableArray alloc]init];
                        for (int j=0; j< [contactArr count]; j++) {
                            
                            if ([[sectionNameArr objectAtIndex:i] isEqualToString:[[contactArr objectAtIndex:j] objectForKey:@"DepartmentName"]]) {
                                NSLog(@"%d---%d--->>%@",i,j,[contactArr objectAtIndex:j]);
                                [ary addObject:[contactArr objectAtIndex:j]];
                            }
                        }
                        [departmentDict setObject:ary forKey:[sectionNameArr objectAtIndex:i]];
                    }
                    NSLog(@"Department Dict :: >> %@",departmentDict);
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
    }
    [self hideHud];
}

-(void)parseDictionaryForSection:(NSMutableArray *) array {
   
    
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

#pragma mark - Search Functionality methods

- (IBAction)btnSearch:(id)sender {

    self.searchViewHeightConstraints.constant = 44.0f;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
- (IBAction)searchEditing:(id)sender {
    
    NSLog(@">>----%@",self.txtSearchBar.text);
    
    NSMutableArray *contactSearchArr = [[NSMutableArray alloc]init];
    NSString *strSearch = self.txtSearchBar.text;
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        if(strSearch.length == 0) {
            
            self.searchViewHeightConstraints.constant = 0.0f;
            branchInfoArr = [NSArray arrayWithArray:branchContactArr];
            
            [self.tableView reloadData];
            
            [self.view endEditing:YES];
        }
        else {
            for (int i = 0; i < [branchContactArr count]; i++) {
                
                NSString *strName = [[branchContactArr objectAtIndex:i] objectForKey:@"Name"];
                
                
                if ([[strName lowercaseString] rangeOfString:[strSearch lowercaseString]].location != NSNotFound) {
                    
                    NSLog(@"contains-->> %@",strName);
                    [contactSearchArr addObject:[branchContactArr objectAtIndex:i]];
                }
                else {
                    
                    NSLog(@"Do not contain-->> %@",strName);
                    
                }
                branchInfoArr = [contactSearchArr copy];
                [self.tableView reloadData];
                
                NSLog(@"RESULT ARRAY ------- >> %@",contactSearchArr);
                
            }
            
        }

    }
    else {
        
        if(strSearch.length == 0) {
            
              self.searchViewHeightConstraints.constant = 0.0f;
            sectionInfoArr = [NSMutableArray arrayWithArray:sectionNameArr];
            
            [self.tableView reloadData];
            
            [self.view endEditing:YES];
        }
        else {
            for (int i = 0; i < [sectionNameArr count]; i++) {
                
                NSString *strName = [sectionNameArr objectAtIndex:i];
                
                
                if ([[strName lowercaseString] rangeOfString:[strSearch lowercaseString]].location != NSNotFound) {
                    
                    NSLog(@"contains-->> %@",strName);
                    [contactSearchArr addObject:[sectionNameArr objectAtIndex:i]];
                }
                else {
                    
                    NSLog(@"Do not contain-->> %@",strName);
                    
                }
                sectionInfoArr = [contactSearchArr copy];
                [self.tableView reloadData];
                
                NSLog(@"RESULT ARRAY ------- >> %@",contactSearchArr);
                
            }
            
        }
    }
  

}


@end
