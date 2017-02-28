//
//  RecruitmentViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "RecruitmentViewController.h"
#import "AddPlanTableViewCell.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"

@interface RecruitmentViewController ()
{
    AddPlanTableViewCell *cell;
    MBProgressHUD *hud;
    NSInteger success, totalCount, deleteRecruitmentIndex, enditingIndex;
    NSString *userID, *strDate, *strLevel;
    NSDateFormatter *dateFormatter;
    NSDate *date;
    NSMutableArray *recruitmentArr;
    NSMutableDictionary *recruitmentDict;
    NSArray *levelArr;
}
@end

@implementation RecruitmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    totalCount = 0;
    deleteRecruitmentIndex = -1;
    self.tablleViewHeightConstraints.constant = 0 * 171;
    
    recruitmentArr = [[NSMutableArray alloc] init];
    
    [self.btnAddMore setHidden:YES];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    date = [[NSDate alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] ==[NSNull null] || [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] == nil) {
        
        date = [NSDate date];
        strDate = [dateFormatter stringFromDate:date];
        
    }
    else {
        
        strDate  = [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"];
        date = [dateFormatter dateFromString:strDate];
    }
    
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    strDate = [dateFormatter stringFromDate:date];
    
    userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"salesVisitID"] ;;
    
    [self.btnUpdate setTitle:@"" forState:UIControlStateNormal];
    
    levelArr = [[NSArray alloc] initWithObjects:@"Blank",@"L1",@"L2",@"P1",@"P2",@"P3",@"R", nil];
    [self fetchRecruitmentForUser:userID ForDate:strDate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (success == 1) {
        
        return [recruitmentArr count];
    }
    else {
        
        return totalCount;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=(AddPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (success == 1) {
        
        /*
         {
         "RecId": "192",
         "UserId": "699",
         "Date": "2016-09-29",
         "Existing": "Any Name41",
         "ExistingVisit": "L41",
         "TimeVisit": "7 to 7.301"
         },
         */
        
        [cell.txtRecruitmentAgentName setText:[[recruitmentArr objectAtIndex:indexPath.row] objectForKey:@"ExistingName"]];
        [cell.txtRecruitmentLevel setText:[[recruitmentArr objectAtIndex:indexPath.row] objectForKey:@"ExistingLevel"]];
        [cell.txtRecruitmentRemark setText:[[recruitmentArr objectAtIndex:indexPath.row] objectForKey:@"TimeVisit"]];
        
        [self.btnAddMore setHidden:YES];
    }
    else {
        
        if (indexPath.row == 0) {
            
            cell.btnDeleteRecruitment.hidden = YES;
        }
        else {
            
            cell.btnDeleteRecruitment.hidden = NO;
        }
        [cell.txtRecruitmentAgentName setText:[[recruitmentArr objectAtIndex:indexPath.row] objectForKey:@"ExistingName"]];
        [cell.txtRecruitmentLevel setText:[[recruitmentArr objectAtIndex:indexPath.row] objectForKey:@"ExistingLevel"]];
        [cell.txtRecruitmentRemark setText:[[recruitmentArr objectAtIndex:indexPath.row] objectForKey:@"TimeVisit"]];
        
        [self.btnAddMore setHidden:NO];
        
        
    }
    
    cell.txtRecruitmentAgentName.tag = indexPath.row;
    [cell.txtRecruitmentAgentName addTarget:(id)self action:@selector(txtRecruitmentAgentName:) forControlEvents:UIControlEventEditingChanged];
    
    cell.txtRecruitmentRemark.tag = indexPath.row;
    [cell.txtRecruitmentRemark addTarget:(id)self action:@selector(txtRecruitmentRemark:) forControlEvents:UIControlEventEditingChanged];
    
    cell.btnRecruitmentLEvel.tag = indexPath.row;
    [cell.btnRecruitmentLEvel addTarget:(id)self action:@selector(btnRecruitmentLevel:) forControlEvents:UIControlEventTouchDown];
    
    cell.btnDeleteRecruitment.tag = indexPath.row;
    [cell.btnDeleteRecruitment addTarget:(id)self action:@selector(btnDeleterecruitment:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *txtField = [[UITextField alloc] init];
    cell.accessoryView = txtField;

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(void)txtRecruitmentAgentName:(UITextField *)sender {
    
    [[recruitmentArr objectAtIndex:[sender tag]] setObject:[sender text] forKey:@"ExistingName"];
}

-(void)txtRecruitmentRemark:(UITextField *)sender {
    
    [[recruitmentArr objectAtIndex:[sender tag]] setObject:[sender text] forKey:@"TimeVisit"];
}

-(void)btnRecruitmentLevel:(id)sender {
    
    strLevel = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Select :" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
    picker.delegate = (id)self;
    picker.dataSource = (id)self;
    [alert addSubview:picker];
    picker.tag = [sender tag];
    alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
    [alert setValue:picker forKey:@"accessoryView"];
    alert.tag = [sender tag];
    [alert show];

}


-(void)btnDeleterecruitment:(id)sender {
    
    if (success == 1) {
        
        /*
         {
         "MapId":19
         }
        */
        
        deleteRecruitmentIndex = [sender tag];
        NSString *MapId = [[recruitmentArr objectAtIndex:[sender tag]] objectForKey:@"Id"];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:MapId,@"MapId", nil];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_RECRUITMENT];
        [self addRecruitmentWithData:params withURL:strURL];
    }
    else {
        
        totalCount = totalCount - 1;
        self.tablleViewHeightConstraints.constant = totalCount * 171;
        [recruitmentArr removeObjectAtIndex:[sender tag]];
        [self.tableView reloadData];
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
    return [levelArr count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return levelArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"SELECTED >> %@", [levelArr objectAtIndex:row]);
    
    strLevel = [levelArr objectAtIndex:row];
    
}

#pragma mark - UIButton IBAction methods

- (IBAction)btnUpdate:(id)sender {
    
   
    
    /*
     
     
     
     {
     "Recruitment": {
     "UserId": 700,
     "CreatedDate": "2016-11-06",
     "Data": [{
     "Id": "202",
     "ExistingName": "Any Name51",
     "ExistingLevel": "L51",
     "TimeVisit": "5 to 71"
     }]
     }
     }
     

     */
    NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              userID,@"UserId",
                              strDate,@"CreatedDate",
                              recruitmentArr,@"Data",
                              nil];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:dataDict,@"Recruitment", nil];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_RECRUITMENT];
    
    [self addRecruitmentWithData:params withURL:strURL];
}

- (IBAction)btnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddMore:(id)sender {
    
    
    totalCount = totalCount + 1;
    
    recruitmentDict = [[NSMutableDictionary alloc] init];
    [recruitmentDict setObject:@"" forKey:@"ExistingName"];
    [recruitmentDict setObject:@"Blank" forKey:@"ExistingLevel"];
    [recruitmentDict setObject:@"" forKey:@"TimeVisit"];
    [recruitmentArr addObject:recruitmentDict];
    
    self.tablleViewHeightConstraints.constant = totalCount * 171;
    
    [self.tableView reloadData];
    
    //Go to last index of tableview
    
    NSIndexPath* ip = [NSIndexPath indexPathForRow:totalCount-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}



#pragma mark - Consume Webservice

-(void)fetchRecruitmentForUser:(NSString *)userId ForDate:(NSString *)Date {
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     
     {
     "UserId":699,
     "Date":"2016-09-28"
     }
     
     */
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            userId,@"UserId",
                            Date,@"Date",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_RECRUITMENT]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_RECRUITMENT] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

-(void)parseDataResponseObject:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"]  != [NSNull null]) {
            
            success = 1;
            NSArray *dataArr = [dictionary objectForKey:@"data"];
            
            for (NSDictionary *dict in dataArr) {
                
                recruitmentDict = [[NSMutableDictionary alloc] init];
                
                [recruitmentDict setObject:[dict objectForKey:@"RecId"] forKey:@"Id"];
                [recruitmentDict setObject:[dict objectForKey:@"Existing"] forKey:@"ExistingName"];
                [recruitmentDict setObject:[dict objectForKey:@"ExistingVisit"] forKey:@"ExistingLevel"];
                [recruitmentDict setObject:[dict objectForKey:@"TimeVisit"] forKey:@"TimeVisit"];
                
                [recruitmentArr addObject:recruitmentDict];
            }
            [self.tableView reloadData];
            self.tablleViewHeightConstraints.constant = [recruitmentArr count] * 171;
            [self hideHud];
            
            [self.btnUpdate setTitle:@"UPDATE" forState:UIControlStateNormal];
            
        }
        
    }
    else {
        [self hideHud];
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            
            [self.btnUpdate setTitle:@"SUBMIT" forState:UIControlStateNormal];
            success = 0;
            totalCount = 1;
            recruitmentDict = [[NSMutableDictionary alloc] init];
            [recruitmentDict setObject:@"" forKey:@"ExistingName"];
            [recruitmentDict setObject:@"Blank" forKey:@"ExistingLevel"];
            [recruitmentDict setObject:@"" forKey:@"TimeVisit"];
            [recruitmentArr addObject:recruitmentDict];
            
            NSLog(@"recruitment >> %@",recruitmentArr);
            [self.tableView reloadData];
            self.tablleViewHeightConstraints.constant = 1 * 171;
            
        }
    }
    
    
}

-(void)addRecruitmentWithData:(NSDictionary *)params withURL:(NSString *)strURL {
    
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSLog(@"PARAM ------->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",strURL);
    
    [manager POST:strURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForAddRecruitment:responseObject];
            });
            NSLog(@"----->> %@",responseObject);
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


-(void)parseDataResponseObjectForAddRecruitment:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        
        NSLog(@"----->> %ld",(long)deleteRecruitmentIndex);
        
        if (deleteRecruitmentIndex == -1) {
            
            if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] != [NSNull null]) {
                
                [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        else {
            
            
            [recruitmentArr removeObjectAtIndex:deleteRecruitmentIndex];
            
            if ([recruitmentArr count] == 0) {
                
                deleteRecruitmentIndex = -1;
                [self.btnAddMore setHidden:NO];
                [self.btnUpdate setTitle:@"SUBMIT" forState:UIControlStateNormal];
                success = 0;
                totalCount = 1;
                recruitmentDict = [[NSMutableDictionary alloc] init];
                [recruitmentDict setObject:@"" forKey:@"ExistingName"];
                [recruitmentDict setObject:@"Blank" forKey:@"ExistingLevel"];
                [recruitmentDict setObject:@"" forKey:@"TimeVisit"];
                [recruitmentArr addObject:recruitmentDict];
                
                NSLog(@"recruitment >> %@",recruitmentArr);
                [self.tableView reloadData];
                self.tablleViewHeightConstraints.constant = 1 * 171;
            }
            else {
                
                self.tablleViewHeightConstraints.constant = [recruitmentArr count] * 171;
                [self.tableView reloadData];
                
            }
            
        }
        
    }
    else {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
        }
        else {
            
            [self.view makeToast:@"Failed to add recruitment"];
        }
    }
}


#pragma mark - UIAlertView method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if ([strLevel length] == 0) {
         
            [[recruitmentArr objectAtIndex:[alertView tag]] setObject:@"Blank" forKey:@"ExistingLevel"];
        }
        else {
            
            [[recruitmentArr objectAtIndex:[alertView tag]] setObject:strLevel forKey:@"ExistingLevel"];
        }
        [self.tableView reloadData];
        
    }
    
    else {
        strLevel = @"";
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

@end
