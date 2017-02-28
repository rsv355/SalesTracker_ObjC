//
//  RemarkViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 26/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "RemarkViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "ActionLogTableViewCell.h"

@interface RemarkViewController ()
{
    MBProgressHUD *hud;
    ActionLogTableViewCell *cell;
    NSArray *remarkArr;
}
@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //action_id=130
    
    [self fetchRemarks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)fetchRemarks {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@action_id=%@",BASE_URL,FETCH_REMARK,_actionID]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@action_id=%@",BASE_URL,FETCH_REMARK,_actionID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [remarkArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(ActionLogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([[remarkArr objectAtIndex:indexPath.row] objectForKey:@"Name"] != [NSNull null]) {
        
         cell.lblUserName.text = [[remarkArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
    }
    if ([[remarkArr objectAtIndex:indexPath.row] objectForKey:@"Remarks"] != [NSNull null]) {
        
        cell.lblRemark.text = [[remarkArr objectAtIndex:indexPath.row] objectForKey:@"Remarks"];
    }
    if ([[remarkArr objectAtIndex:indexPath.row] objectForKey:@"Date"] != [NSNull null]) {
        
        cell.lblRemarkDate.text = [[remarkArr objectAtIndex:indexPath.row] objectForKey:@"Date"];
    }
    
    return cell;
}


-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                
                if ([[dictionary objectForKey:@"data"] objectForKey:@"Remarks"] != [NSNull null]) {
                    remarkArr = [[dictionary objectForKey:@"data"] objectForKey:@"Remarks"];
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
