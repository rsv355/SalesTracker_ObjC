//
//  ActionLogListViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ActionLogListViewController.h"
#import "ActionLogTableViewCell.h"
#import "UIButton+tintImage.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "ActionLogDetailsViewController.h"
#import "RemarkViewController.h"
#import "AddActionLogViewController.h"
#import "App_Constant.h"

@interface ActionLogListViewController () <ActionLogViewControllerDelegate, RemarkDelegate>
{
    ActionLogTableViewCell *cell;
    MBProgressHUD *hud;
    UIColor *pendingColor, *rejectedColor, *completedColor, *processingColor;
    NSArray *actionArr;
    NSDateFormatter *dateFormatter;
    
    NSArray *sortedArray;
}
@end

@implementation ActionLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setLayout];
    
    pendingColor = [UIColor colorWithRed:(249/255.0) green:(168/255.0) blue:(37/255.0) alpha:1.0f];
    rejectedColor = [UIColor colorWithRed:(255/255.0) green:(96/255.0) blue:(96/255.0) alpha:1.0f];
    completedColor = [UIColor colorWithRed:(67/255.0) green:(160/255.0) blue:(71/255.0) alpha:1.0f];
    processingColor = [UIColor colorWithRed:(0/255.0) green:(168/255.0) blue:(255/255.0) alpha:1.0f];
    
  
    
    [self fetchActionLogListFromWebServices];
    
}
-(void)formatedSortedUsingDates
{
    
//    NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CreatedDatetime" ascending:NO];
//    NSArray *sortDescriptors = @[ageDescriptor];
//    sortedArray = [actionArr sortedArrayUsingDescriptors:sortDescriptors];
    sortedArray = [NSArray arrayWithArray: actionArr];
    NSLog(@"sorted array list>>>%@",sortedArray);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Desing Setup method
-(void)setLayout {
    
    [self.btnAddActionLog.layer setCornerRadius:30];
    [self setShadowFor:self.btnAddActionLog];
    
    self.viewPending.layer.cornerRadius = 6.0f;
    self.viewRejected.layer.cornerRadius = 6.0f;
    self.viewCompleted.layer.cornerRadius = 6.0f;
    self.viewProcessing.layer.cornerRadius = 6.0f;
    
    [self.btnAddActionLog setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
    return [sortedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(ActionLogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Id"] != [NSNull null]) {
        cell.lblActionLogName.text = [[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Id"];
    }
    else {
        cell.lblActionLogName.text = @"**Deleted Agent**";
    }
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"CreaterName"] != [NSNull null]) {
      
        cell.lblActionLogUserName.text = [NSString stringWithFormat:@"User : %@",[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"CreaterName"]];
    }
    
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Description"] != [NSNull null]) {
        cell.lblDescription.text = [[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
    }
    else if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Description"] != nil) {
        
        cell.lblDescription.text = @"No Description";
    }
    else {
        cell.lblDescription.text = @"No Description";
    }
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"CreatedDatetime"] != [NSNull null]) {
        
        NSString *strCreatedDate = [[sortedArray objectAtIndex:indexPath.row] objectForKey:@"CreatedDatetime"];
        
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        NSDate *date = [[NSDate alloc]init];
        date = [dateFormatter dateFromString:strCreatedDate];
        
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM"];
        cell.lblMonthName.text = [dateFormatter stringFromDate:date];
        
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd"];
        cell.lblDate.text = [dateFormatter stringFromDate:date];
        
    }
    
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"UpdatedDatetime"] != [NSNull null]) {
        
    
        NSString *strUpdatedTime = [[sortedArray objectAtIndex:indexPath.row]objectForKey:@"UpdatedDatetime"];
        
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        NSRange range = [strUpdatedTime rangeOfString:@"By"];
        
        NSDate *date = [[NSDate alloc] init];
        
        date = [dateFormatter dateFromString:[strUpdatedTime substringToIndex:range.location]];
       
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM,yyyy hh:mm a"];
        cell.lblLastUpdatedDate.text = [NSString stringWithFormat:@"Last Updated : %@%@",[dateFormatter stringFromDate:date],[strUpdatedTime substringFromIndex:range.location]];
    
    }
    
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"RemarkCount"] != [NSNull null]) {
        
        if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"RemarkCount"] integerValue]>0) {
            NSLog(@"--->>%@",[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"RemarkCount"]);
            [cell.btnRemarks setHidden:NO];
            
            [cell.btnRemarks setTitle:[NSString stringWithFormat:@"%@ Remark",[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"RemarkCount"]] forState:UIControlStateNormal];
        }
        else {
            [cell.btnRemarks setHidden:YES];
        }
    }
    else {
        [cell.btnRemarks setHidden:YES];
    }
    
    if ([[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] != [NSNull null]) {
        if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"C"]) {
            
            [cell.lblStatus setText:C];
        }
        else if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"P"]) {
            
            [cell.lblStatus setText:P];
        }
        else if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"R"]) {
            
            [cell.lblStatus setText:R];
        }
        else if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"PR"]) {
            
            [cell.lblStatus setText:PR];
        }
        else if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"OD"]) {
            
            [cell.lblStatus setText:OD];
        }
        else if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"OG"]) {
            
            [cell.lblStatus setText:A];
        }
        else if ([[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Status"] isEqualToString:@"A"]) {
            
            [cell.lblStatus setText:OG];
        }
    }
    cell.btnRemarks.tag = indexPath.row;
    [cell.btnRemarks addTarget:(id)self action:@selector(btnRemarks:) forControlEvents:UIControlEventTouchDown];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActionLogDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ACTION_LOG_DETAILS"];
    viewController.actionLogDict = [sortedArray objectAtIndex:indexPath.row];
    
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
    
}

#pragma mark - UIButton IBAction methods


-(void)btnRemarks:(id)sender {
    
    NSLog(@"%@",[[@"AMG_101" componentsSeparatedByString:@"_"] lastObject]);
    RemarkViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"REMARKS"];
    viewController.actionID = [[[[sortedArray objectAtIndex:[sender tag]] objectForKey:@"Id"] componentsSeparatedByString:@"_"] lastObject];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnAddActionLog:(id)sender {
    
    AddActionLogViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_ACTION_LOG"];
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void) fetchActionLogListFromWebServices {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@user_id=%@",BASE_URL,ACTIONLOG_LIST,[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"]objectForKey:@"Userid"]]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@user_id=%@",BASE_URL,ACTIONLOG_LIST,[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"]objectForKey:@"Userid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        [self hideHud];
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
}

-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            if ([dictionary objectForKey:@"data"] != [NSNull null]) {
                if ([[dictionary objectForKey:@"data"] objectForKey:@"Action"] != [NSNull null]) {
                    
                    actionArr = [[dictionary objectForKey:@"data"] objectForKey:@"Action"];
                    
                    [self formatedSortedUsingDates];
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

-(void)updateActionLogInList {
  
    [self viewDidLoad];
}

-(void)updateActionLogRemark {
    
    [self viewDidLoad];
}
@end
