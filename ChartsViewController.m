//
//  ChartsViewController.m
//  SalesTracker
//
//  Created by Webmyne on 06/12/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ChartsViewController.h"
#import "ChartsCollectionViewCell.h"
#import "CommonWebViewViewController.h"
#import "App_Constant.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"


@interface ChartsViewController ()
{
    MBProgressHUD *hud;
    ChartsCollectionViewCell *cell;
    UIPickerView *picker;
    NSArray *dataArr;
    NSMutableArray *yearArr, *monthArr;
    NSArray *regionArr, *branchArr;
    NSMutableArray *ary;
    NSString *strBranchId, *strRegionId, *strMonth;
    NSInteger chartIndex;
    NSString *positionName;
    
    NSDictionary * userDetails;
    NSArray * AllRegion;
    
}
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ary = [[NSMutableArray alloc] init];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Charts" ofType:@"plist"];
    
    userDetails=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"];
   
    positionName = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Pos_name"];
    
    dataArr = [NSArray arrayWithContentsOfFile:path];
    chartIndex = [dataArr count] + 1;
    
    self.collectionViewHeightConstraints.constant = ([dataArr count]/2)*(self.collectionView.frame.size.width/4.5);
    
    [self initialize];
    [self checkPosition];

    
    yearArr = [[NSMutableArray alloc] init];
    monthArr = [[NSMutableArray alloc] init];
    
    for (int i = 2016; i<=2070; i++) {
        
        [yearArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    monthArr = [[NSMutableArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    
    
    [self fetchDataFromWebServices:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_REGION] for:@"region"];
    
    //setup default as current month and year
    long curYear;
    long curMonth;
    
    NSDate *date = [NSDate date];
    NSCalendar *curCalendar = [NSCalendar currentCalendar];
  
    NSDateComponents *dateComponents = [curCalendar components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    
    curYear = [dateComponents year];
    
    
    for (int i = 0; i<yearArr.count; i++) {
       
        if([[yearArr objectAtIndex:i] integerValue]==curYear){
            [self.btnYear setTitle:[yearArr objectAtIndex:i] forState:UIControlStateNormal];
            break;
        }
    }
    
    //set current month
    curMonth = [dateComponents month]-1;
    strMonth = [NSString stringWithFormat:@"%ld",(long)[dateComponents month]];
    [self.btnMonth setTitle:[monthArr objectAtIndex:curMonth] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initialize {
    
    self.btnShowChart.hidden = YES;
    
    self.viewBranch.hidden= YES;
    self.viewRegion.hidden= YES;
    self.viewYear.hidden= YES;
    self.viewMonth.hidden= YES;
    
    [self.viewSelectTimeHeightConstraints setConstant:0.0f];
    [self.viewSelectLocationHeightConstraints setConstant:0.0f];
    
    self.viewBranch.layer.borderWidth = 1.0f;
    self.viewBranch.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.viewRegion.layer.borderWidth = 1.0f;
    self.viewRegion.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.viewYear.layer.borderWidth = 1.0f;
    self.viewYear.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.viewMonth.layer.borderWidth = 1.0f;
    self.viewMonth.layer.borderColor = [UIColor grayColor].CGColor;
    
    
}

-(void)checkPosition
{
    
    if ([positionName isEqualToString:BM_POSITION_NAME]) {
        
        [self.btnBranch setTitle:[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Branch_name"] forState:UIControlStateNormal];
        
        [self.btnRegion setTitle:[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Region"] forState:UIControlStateNormal];
        [self.btnRegion setUserInteractionEnabled:NO];
     //   [self.btnBranch setUserInteractionEnabled:NO];
        
        
      //  strRegionId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"RegionId"];
        AllRegion=[userDetails objectForKey:@"AllRegion"] ;
        
        
        [self.btnRegion setTitle:[[AllRegion valueForKey:@"Region"] objectAtIndex:0] forState:UIControlStateNormal];

        strRegionId=[[AllRegion valueForKey:@"RegionId"] objectAtIndex:0];
        
        strBranchId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Branch"];
    }
    else if ([positionName isEqualToString:RM_POSITION_NAME]) {
        
        NSLog(@"region is  %@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Region"]);
        
       // [self.btnRegion setTitle:[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Region"] forState:UIControlStateNormal];
       // [self.btnRegion setUserInteractionEnabled:NO];
        
        AllRegion=[userDetails objectForKey:@"AllRegion"];
        
        [self.btnRegion setTitle:[[AllRegion valueForKey:@"Region"] objectAtIndex:0] forState:UIControlStateNormal];
       
      //  strRegionId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"RegionId"];
        strRegionId=[[AllRegion valueForKey:@"RegionId"] objectAtIndex:0];
        
        
         [self fetchDataFromWebServices:[NSString stringWithFormat:@"%@%@regionid=%@",BASE_URL,FETCH_BRANCHES,[[AllRegion valueForKey:@"RegionId"]objectAtIndex:0]] for:@"branch"];
        
    }
}
    
#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"Color"] isEqualToString:@"1"])
    {
        [cell setBackgroundColor:[UIColor colorWithRed:(241.0/255.0) green:(241.0/255.0) blue:(241.0/255.0) alpha:1.0f]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    cell.lblTitle.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"Title"];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1=collectionviewSize.width/2;
    side2=collectionviewSize.height;
    return CGSizeMake(side1, side1/2.5);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i<[dataArr count]; i++) {
        
        NSIndexPath *indexPATH = [NSIndexPath indexPathForItem:i inSection:0];
        ChartsCollectionViewCell *selCell = (ChartsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPATH];
       
        if (indexPath.row == i) {
             [selCell.lblTitle setTextColor:[UIColor blueColor]];
             [selCell.lblTitle setFont:[UIFont fontWithName:@"Ubuntu" size:16]];
        }
        else {
             [selCell.lblTitle setTextColor:[UIColor blackColor]];
            [selCell.lblTitle setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
        }
    }
    if (indexPath.row == 3) {
       
        self.viewYear.hidden= NO;
        self.viewMonth.hidden= NO;
        self.viewBranch.hidden= NO;
        self.viewRegion.hidden= NO;
        [self.viewSelectTimeHeightConstraints setConstant:40.0f];
        [self.viewSelectLocationHeightConstraints setConstant:40.0f];
        
        
    }
    else if (indexPath.row == 0){
    
        if ([positionName isEqualToString:RM_POSITION_NAME]) {
            
            self.viewYear.hidden= NO;
            self.viewMonth.hidden= NO;
            self.viewBranch.hidden= YES;
            self.viewRegion.hidden= NO;
            [self.viewSelectTimeHeightConstraints setConstant:40.0f];
            [self.viewSelectLocationHeightConstraints setConstant:40.0f];

        }
        else
        {
        
            self.viewYear.hidden= NO;
            self.viewMonth.hidden= NO;
            self.viewBranch.hidden= YES;
            self.viewRegion.hidden= YES;
            [self.viewSelectTimeHeightConstraints setConstant:40.0f];
            [self.viewSelectLocationHeightConstraints setConstant:0.0f];
        
        }
        
    }
    else {
        self.viewYear.hidden= NO;
        self.viewMonth.hidden= NO;
        self.viewBranch.hidden= YES;
        self.viewRegion.hidden= YES;
        [self.viewSelectTimeHeightConstraints setConstant:40.0f];
        [self.viewSelectLocationHeightConstraints setConstant:0.0f];
    }
    self.btnShowChart.hidden = NO;
    chartIndex = indexPath.row;
    

}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShowChart:(id)sender {
    
    if (chartIndex == 3) {
        
        if ([[[self.btnYear titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select year"]) {
            [self.view makeToast:@"Please Select Year"];
        }
        else if ([[[self.btnMonth titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select month"]) {
            [self.view makeToast:@"Please Select Month"];
        }
        else if ([[[self.btnRegion titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select region"]) {
            [self.view makeToast:@"Please Select Region"];
        }
        else if ([[[self.btnBranch titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select branch"]) {
            [self.view makeToast:@"Please Select Branch"];
        }
        else {
            
            CommonWebViewViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COMMON_WEBVIEW"];
            viewController.strHeader = @"CHART";
            viewController.strURL = [NSString stringWithFormat:SVP_CHART_URL,BASE_URL,[self.btnYear titleForState:UIControlStateNormal],strMonth,strRegionId,strBranchId, [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"]];
            viewController.strWebviewType = WEBVIEW_TYPE_URL;
            [self presentViewController:viewController animated:YES completion:nil];

        }

    }
    else {
            
            if ([[[self.btnYear titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select year"]) {
                [self.view makeToast:@"Please Select Year"];
            }
            else if ([[[self.btnMonth titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select month"]) {
                [self.view makeToast:@"Please Select Month"];
            }
        
            else {
                
                NSString *strURL;
                
                NSString *strUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"]objectForKey:@"Userid"];
                
                if (chartIndex == 0) {
                    
                    strURL = [NSString stringWithFormat:BRANCH_CHART_URL,BASE_URL,strMonth,[self.btnYear titleForState:UIControlStateNormal],strUserID,strRegionId];
                }
                else if (chartIndex == 1) {
                    strURL = [NSString stringWithFormat:DEPARTMENT_CHART_URL,BASE_URL,strMonth,[self.btnYear titleForState:UIControlStateNormal]];
                }
                else if (chartIndex == 2) {
                    strURL = [NSString stringWithFormat:DEPARTMENT_SLA_CHART_URL,BASE_URL,strMonth,[self.btnYear titleForState:UIControlStateNormal],strUserID];
                }
                CommonWebViewViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COMMON_WEBVIEW"];
                viewController.strHeader = @"CHART";
                viewController.strURL = strURL;
                viewController.strWebviewType = WEBVIEW_TYPE_URL;
                [self presentViewController:viewController animated:YES completion:nil];
                
                
            }
            
        }
    
}
- (IBAction)btnSelection:(id)sender {
   
    ary = [[NSMutableArray alloc] init];
    NSString *strMessage;
    
    if ([sender tag] == 1) {
        
        ary = [NSMutableArray arrayWithArray:yearArr];
        strMessage = @"Select Year";
    }
    else if ([sender tag] == 2) {
            
        ary = [NSMutableArray arrayWithArray:monthArr];
        strMessage = @"Select Month";
    }
    else if ([sender tag] == 3) {
        
       // ary = [NSMutableArray arrayWithArray:regionArr];
         ary = [NSMutableArray arrayWithArray:AllRegion];

        strMessage = @"Select Region";
    }
    else if ([sender tag] == 4) {
        
        if ([[[self.btnRegion titleForState:UIControlStateNormal] lowercaseString] isEqualToString:@"select region"]) {
            [self.view makeToast:@"Please select region."];
            return;
        }
        else {
            
            for (NSDictionary *dict in branchArr) {
                if ([[dict objectForKey:@"RegionId"] isEqualToString:strRegionId]) {
                    NSLog(@"----%@----%@",[dict objectForKey:@"RegionId"], strRegionId);
                    strMessage = @"Select Branch";
                    [ary addObject:dict];
                }
            }
        }
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:strMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
    picker.delegate = (id)self;
    picker.dataSource = (id)self;
    [alert addSubview:picker];
    picker.tag = [sender tag];
    alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
    [alert setValue:picker forKey:@"accessoryView"];
    [alert setTag:[sender tag]];
    [alert show];

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
    return [ary count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 3) {
      //  return [[ary objectAtIndex:row] objectForKey:@"RegionId"];
        return [[ary objectAtIndex:row] objectForKey:@"Region"];

    }
    else if (pickerView.tag == 4) {
        return [[ary objectAtIndex:row] objectForKey:@"BranchName"];
    }
    else {
        
        return ary[row];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"------->>%ld", (long)[picker selectedRowInComponent:0]);
    if (alertView.tag == 1) {
        
        
        if (buttonIndex == 1) {
            
            [self.btnYear setTitle:[ary objectAtIndex:[picker selectedRowInComponent:0]] forState:UIControlStateNormal];
        }
    }
    else if (alertView.tag == 2) {
        
        if (buttonIndex == 1) {
            
            strMonth = [NSString stringWithFormat:@"%ld",(long)[picker selectedRowInComponent:0]+1];
            [self.btnMonth setTitle:[ary objectAtIndex:[picker selectedRowInComponent:0]] forState:UIControlStateNormal];
        }
    }
    else if (alertView.tag == 3) {
        
        if (buttonIndex == 1) {
            
            strRegionId = [[ary objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"RegionId"];
          //  strRegionId = [[ary objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"Region"];
                           
           // [self.btnRegion setTitle:[[ary objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"RegionId"] forState:UIControlStateNormal];
               [self.btnRegion setTitle:[[ary objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"Region"] forState:UIControlStateNormal];
            
            strBranchId = @"";
            [self.btnBranch setTitle:@"Select Branch" forState:UIControlStateNormal];
        }
    }
    else if (alertView.tag == 4) {
        
        if (buttonIndex == 1) {
            
            strBranchId = [[ary objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"BranchId"];
            
            [self.btnBranch setTitle:[[ary objectAtIndex:[picker selectedRowInComponent:0]] objectForKey:@"BranchName"] forState:UIControlStateNormal];
        }
    }
//    if (pickerView.tag == 3) {
//        return [[ary objectAtIndex:row] objectForKey:@"RegionId"];
//    }
//    else if (pickerView.tag == 4) {
//        return [[ary objectAtIndex:row] objectForKey:@"BranchName"];
//    }
}

-(void) fetchDataFromWebServices:(NSString *)strURL for:(NSString *)selection {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",strURL);
    
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responsDict != nil) {
            
            [self hideHud];
            [self parseDataResponseObject:responsDict for:selection];
            NSLog(@"----------->>%@",responsDict);
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

-(void)parseDataResponseObject:(NSDictionary *)dictionary for:(NSString *)selection {
    
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            
            // [self hideHud];
            
            if ([selection isEqualToString:@"region"]) {
                
                regionArr = [[dictionary objectForKey:@"data"] objectForKey:@"Branches"];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self fetchDataFromWebServices:[NSString stringWithFormat:@"%@%@regionid=0",BASE_URL,FETCH_BRANCHES] for:@"branch"];
                    
                });
            }
            else if ([selection isEqualToString:@"branch"]) {
                
                branchArr = [[dictionary objectForKey:@"data"] objectForKey:@"Branches"];
                
                
                for (NSDictionary *dict in branchArr) {
                    if ([[dict objectForKey:@"RegionId"] isEqualToString:strRegionId]) {
                        NSLog(@"----%@----%@",[dict objectForKey:@"RegionId"], strRegionId);
                        //  strMessage = @"Select Branch";
                        [ary addObject:dict];
                        
                    }
                }
                [self.btnBranch setTitle:[[ary valueForKey:@"BranchName"] objectAtIndex:0] forState:UIControlStateNormal];
                strBranchId=[[ary valueForKey:@"BranchId"] objectAtIndex:0];

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

@end
