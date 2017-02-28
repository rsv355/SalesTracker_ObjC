//
//  MappingViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 17/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "MappingViewController.h"
#import "AddPlanTableViewCell.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"

@interface MappingViewController ()
{
    AddPlanTableViewCell *cell;
    MBProgressHUD *hud;
    NSInteger success, totalCount, deleteMappingIndex, enditingIndex;
    NSString *userID, *strDate;
    NSDateFormatter *dateFormatter;
    NSDate *date;
    NSMutableArray *mappingArr;
    NSMutableDictionary *mappingDict;
}
@end

@implementation MappingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    totalCount = 0;
    deleteMappingIndex = -1;
    self.tablleViewHeightConstraints.constant = 0 * 61;
    
    mappingArr = [[NSMutableArray alloc] init];
    
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
    [self fetchMappingForUser:userID ForDate:strDate];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark- UITableView Datasource and Delegate methods
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     if (success == 1) {
         
         return [mappingArr count];
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
         "MappingId": "107",
         "UserId": "700",
         "Date": "2016-11-04",
         "Mapping": "Mapping Name4",
         "MappingVisit": "v4"
         }
         */
        
        [cell.txtMapping setText:[[mappingArr objectAtIndex:indexPath.row] objectForKey:@"Mapping"]];
        [cell.txtMappingVisit setText:[[mappingArr objectAtIndex:indexPath.row] objectForKey:@"MappingVisit"]];
        
        [self.btnAddMore setHidden:YES];
    }
    else {
        
        if (indexPath.row == 0) {
            
            cell.btnDeleteMapping.hidden = YES;
        }
        else {
            
            cell.btnDeleteMapping.hidden = NO;
        }
        [cell.txtMapping setText:[[mappingArr objectAtIndex:indexPath.row] objectForKey:@"Mapping"]];
        [cell.txtMappingVisit setText:[[mappingArr objectAtIndex:indexPath.row] objectForKey:@"MappingVisit"]];
        [self.btnAddMore setHidden:NO];
        
        
    }
    
    cell.txtMapping.tag = indexPath.row;
    [cell.txtMapping addTarget:(id)self action:@selector(txtMapping:) forControlEvents:UIControlEventEditingChanged];
    
    cell.txtMappingVisit.tag = indexPath.row;
    [cell.txtMappingVisit addTarget:(id)self action:@selector(txtMappingVisit:) forControlEvents:UIControlEventEditingChanged];
    
    cell.btnDeleteMapping.tag = indexPath.row;
    [cell.btnDeleteMapping addTarget:(id)self action:@selector(btnDeleteMapping:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *txtField = [[UITextField alloc] init];
    cell.accessoryView = txtField;
    
    return  cell;
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
}



#pragma mark - UITextField TableViewCell methods


-(void)txtMapping:(UITextField *)sender {
    
    [[mappingArr objectAtIndex:[sender tag]] setObject:[sender text] forKey:@"Mapping"];
}

-(void)txtMappingVisit:(UITextField *)sender {

    [[mappingArr objectAtIndex:[sender tag]] setObject:[sender text] forKey:@"MappingVisit"];
}

-(void)btnDeleteMapping:(id)sender {
    
    if (success == 1) {
        
        /*
         {
         "MapId":19
         }
         */
        
        deleteMappingIndex = [sender tag];
        NSString *MapId = [[mappingArr objectAtIndex:[sender tag]] objectForKey:@"Id"];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:MapId,@"MapId", nil];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_MAPPING];
        [self addMappingWithData:params withURL:strURL];
    }
    else {
        
        totalCount = totalCount - 1;
        self.tablleViewHeightConstraints.constant = totalCount * 61;
        [mappingArr removeObjectAtIndex:[sender tag]];
        [self.tableView reloadData];
    }
}




#pragma mark - UIButton IBAction methods

- (IBAction)btnUpdate:(id)sender {
    
    /*
     
     {
     
     "MappingData": {
     "UserId": 699,
     "CreatedDate": "2016-09-30",
     "Data": [{
     "Mapping": "Mapping Name4",
     "MappingVisit": "v4"
     },
     {
     "Mapping": "Mapping Name5",
     "MappingVisit": "v5"
     }]
     }
     
     }
     
     */

    NSDictionary *dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              userID,@"UserId",
                              strDate,@"CreatedDate",
                              mappingArr,@"Data",
                              nil];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:dataDict,@"MappingData", nil];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_MAPPING];
    
    [self addMappingWithData:params withURL:strURL];

}

- (IBAction)btnClose:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddMore:(id)sender {
    
    
    totalCount = totalCount + 1;
    
    mappingDict = [[NSMutableDictionary alloc] init];
    [mappingDict setObject:@"" forKey:@"Mapping"];
    [mappingDict setObject:@"" forKey:@"MappingVisit"];
    [mappingArr addObject:mappingDict];
    
    self.tablleViewHeightConstraints.constant = totalCount * 61;
    
    [self.tableView reloadData];
    
    //Go to last index of tableview
    
    NSIndexPath* ip = [NSIndexPath indexPathForRow:totalCount-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];

}

#pragma mark - Consume Webservice

-(void)fetchMappingForUser:(NSString *)userId ForDate:(NSString *)Date {

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
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_MAPPING]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_MAPPING] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                
                mappingDict = [[NSMutableDictionary alloc] init];
                
                [mappingDict setObject:[dict objectForKey:@"MappingId"] forKey:@"Id"];
                [mappingDict setObject:[dict objectForKey:@"Mapping"] forKey:@"Mapping"];
                [mappingDict setObject:[dict objectForKey:@"MappingVisit"] forKey:@"MappingVisit"];
                
                [mappingArr addObject:mappingDict];
            }
            [self.tableView reloadData];
            self.tablleViewHeightConstraints.constant = [mappingArr count] * 61;
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
            mappingDict = [[NSMutableDictionary alloc] init];
            [mappingDict setObject:@"" forKey:@"Mapping"];
            [mappingDict setObject:@"" forKey:@"MappingVisit"];
            [mappingArr addObject:mappingDict];
            
            NSLog(@"MAPPING >> %@",mappingArr);
            [self.tableView reloadData];
            self.tablleViewHeightConstraints.constant = 1 * 61;
            
        }
    }
    
    
}

-(void)addMappingWithData:(NSDictionary *)params withURL:(NSString *)strURL {
    
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
   
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",strURL);
    
    [manager POST:strURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForAddMapping:responseObject];
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


-(void)parseDataResponseObjectForAddMapping:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
       
        
        NSLog(@"----->> %ld",(long)deleteMappingIndex);
        if (deleteMappingIndex == -1) {
           
            if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] != [NSNull null]) {
                
                [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        else {
            
        
            [mappingArr removeObjectAtIndex:deleteMappingIndex];
            
            if ([mappingArr count] == 0) {
                
                deleteMappingIndex = -1;
                [self.btnAddMore setHidden:NO];
                [self.btnUpdate setTitle:@"SUBMIT" forState:UIControlStateNormal];
                success = 0;
                totalCount = 1;
                mappingDict = [[NSMutableDictionary alloc] init];
                [mappingDict setObject:@"" forKey:@"Mapping"];
                [mappingDict setObject:@"" forKey:@"MappingVisit"];
                [mappingArr addObject:mappingDict];
                
                NSLog(@"MAPPING >> %@",mappingArr);
                [self.tableView reloadData];
                self.tablleViewHeightConstraints.constant = 1 * 61;
            }
            else {
           
                self.tablleViewHeightConstraints.constant = [mappingArr count] * 61;
                [self.tableView reloadData];

            }
            
        }
        
    }
    else {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]];
        }
        else {
            
            [self.view makeToast:@"Failed to add Mapping"];
        }
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
