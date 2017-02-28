//
//  EmployeeViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 17/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "EmployeeViewController.h"
#import "EmployeeTableViewCell.h"
#import "AddEmployeeViewController.h"
#import "UIButton+tintImage.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"
#import <MessageUI/MessageUI.h>
#import "SelectRegionViewController.h"
#import "CustomAnimationAndTransiotion.h"
#import "App_Constant.h"


@interface EmployeeViewController ()<MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,addEmployeeViewController,SelectRegionViewControllerDelegate>
{
    EmployeeTableViewCell * cell;
    MBProgressHUD *hud;
    MFMailComposeViewController *mailComposer;
    
    NSDictionary *userDetails;
    
    NSArray *employeeArr, *employeeInfoArr;
    NSMutableArray *employeeDeleteArr;
    
    UIColor * red;
    UIColor * blue;

}

@property(strong, nonatomic)CustomAnimationAndTransiotion  *customTransitionController;

@end

@implementation EmployeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _btn_addEmployee.hidden=YES;
    

    
    userDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"];
    NSLog(@"user data...:%@",userDetails);
    
    NSArray *regionArr=[userDetails objectForKey:@"AllRegion"];
    NSString * str=[[regionArr objectAtIndex:0] valueForKey:@"RegionId"];

    [self.btnSelectRegion setTitle:[[regionArr objectAtIndex:0] valueForKey:@"Region"] forState:UIControlStateNormal];
    
    self.EmployeeTableView.dataSource=self;
    self.EmployeeTableView.delegate=self;

    [self setLayout];
    [self fetchEmployeeListFromWebServices:str];
    
    [self.btn_Delete setHidden:YES];

    red=[UIColor colorWithRed:182.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    blue=[UIColor colorWithRed:53.0/255.0 green:122.0/255.0 blue:233.00/255.0 alpha:1];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID])
    {
        
        //self.RegionDropdownHeightConstrint.constant=40.0f;
        //self.RegionDropDownView.hidden=NO;
        
        self.RegionDropdownHeightConstrint.constant=0.0f;
        self.RegionDropDownView.hidden=YES;
        
    }
    else
    {
        
        self.RegionDropdownHeightConstrint.constant=0.0f;
        self.RegionDropDownView.hidden=YES;
        
    }
}


#pragma mark - Desing Setup method

-(void)setLayout {
    
    [self.Btn_back setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    [self.btn_addEmployee setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btn_addEmployee.layer setCornerRadius:30];
   // [self setShadowFor:self.btn_addEmployee];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [employeeInfoArr count];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(EmployeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.Btn_checked.layer.cornerRadius = 2.0f;
    if ([[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"] != [NSNull null]) {
        [cell.lbl_EmployeeName setText:[[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"]];
        
    }
    else {
        [cell.lbl_EmployeeName setText:@""];
        [cell.Btn_checked setTitle:@"" forState:UIControlStateNormal];
    }
    NSString *strRegion,*strBranchName;
    if ([[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Region"] != [NSNull null]) {
        strRegion =[@", " stringByAppendingString:[[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Region"]];
    }
    else {
        strRegion = @"";
    }
    if ([[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Branch"] != [NSNull null]) {
        strBranchName = [[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Branch"];
    }
    else {
        strBranchName = @"";
    }

    if ([[employeeDeleteArr objectAtIndex:indexPath.row] integerValue] == 0 )
    {
        [cell.Btn_checked setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.Btn_checked setTitle:[[[employeeInfoArr objectAtIndex:indexPath.row] objectForKey:@"Name"] substringToIndex:1] forState:UIControlStateNormal];
        
         [cell.Btn_checked setBackgroundColor:[UIColor colorWithRed:86.0/255.0 green:86.0/255.0 blue:86.0/255.0 alpha:1]];
    }
    else
    {
        [cell.Btn_checked setImage:[UIImage imageNamed:@"ic_check_white_24dp.png"] forState:UIControlStateNormal];
        
         [cell.Btn_checked setBackgroundColor:red];
    }
    cell.lbl_EmployeeLocation.text = [strBranchName stringByAppendingString:strRegion];

    cell.Btn_Call.tag = indexPath.row;
    cell.Btn_SendMail.tag = indexPath.row;
    cell.Btn_checked.tag = indexPath.row;
    
    [cell.Btn_Call addTarget:(id)self action:@selector(btnCall:) forControlEvents:UIControlEventTouchDown];
    [cell.Btn_SendMail addTarget:(id)self action:@selector(btnSendMail:) forControlEvents:UIControlEventTouchDown];
    //[cell.Btn_checked addTarget:(id)self action:@selector(btnChecked:) forControlEvents:UIControlEventTouchDown];

   // [cell.Btn_checked setBackgroundColor:[UIColor redColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.EmployeeTableView deselectRowAtIndexPath:indexPath animated:YES];
    AddEmployeeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_EMPLOYEE"];
    
        viewController.strAddEmployeeMode = 0;
        viewController.delegate = (id)self;
    viewController.employeeInfoDict = [employeeInfoArr objectAtIndex:indexPath.row];

       [self presentViewController:viewController animated:YES completion:nil];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73.0f;
}

#pragma  mark - UITableView UIButton IBAction methods
-(void) btnChecked:(id)sender
{
    [self.btn_Delete setHidden:NO];
    if ([[employeeDeleteArr objectAtIndex:[sender tag]] integerValue] == 0) {
        [employeeDeleteArr replaceObjectAtIndex:[sender tag] withObject:[[employeeInfoArr objectAtIndex:[sender tag]] objectForKey:@"Id"]];
    }
    else {
        [employeeDeleteArr replaceObjectAtIndex:[sender tag] withObject:@"0"];
    }
    [self.EmployeeTableView reloadData];

    int deleteCount = 0;
    for (int i = 0; i<[employeeDeleteArr count]; i++) {
        if ([[employeeDeleteArr objectAtIndex:i] integerValue] != 0) {
            deleteCount += 1;
        }
    }
    if (deleteCount>0)
    {
        [self.Title_View setBackgroundColor:red];
        
        [self.btn_Delete setTitle:@"Delete" forState:UIControlStateNormal];
      
    }
    else
    {
        [self.Title_View setBackgroundColor:blue];
        
        [self.btn_Delete setHidden:YES];
       // self.btnSearch.tag = 1;
       // [self.btnSearch setImage:[UIImage imageNamed:@"ic_search_white_24dp.png"] forState:UIControlStateNormal];
      //  self.btnSearchWidthContraint.constant = 40.0f;
    }
    NSLog(@">>%d",deleteCount);


}
-(void)btnCall:(id)sender
{
    
    if ([[employeeInfoArr objectAtIndex:[sender tag]] objectForKey:@"Phone"] != [NSNull null]) {
        NSString *strMobileNo = [[employeeArr objectAtIndex:[sender tag]] objectForKey:@"Phone"];
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:strMobileNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

-(void)btnSendMail:(id)sender {
    if ([[employeeInfoArr objectAtIndex:[sender tag]] objectForKey:@"EmailId"] != [NSNull null]) {
        NSString *strEmailID = [[employeeArr objectAtIndex:[sender tag]] objectForKey:@"EmailId"];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Button_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)btn_addEmployee:(id)sender
{
    AddEmployeeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_EMPLOYEE"];
    viewController.strAddEmployeeMode = 1;
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


- (IBAction)btn_Delete:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Are you sure want to delete this employee?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.tag = 100;
    [alertView show];

    
}

- (IBAction)btnSelectRegion:(id)sender
{
    
    SelectRegionViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SELECTION_REGION"];
    popover.delegate = (id)self;
   //  popover.strSelection = @"0";
    popover.dataArr = [userDetails objectForKey:@"AllRegion"];
   // popover.selectedIndex = branchIndex;
   //  popover.filterIndex = [sender tag];
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            //[self deleteAgentService];
            NSMutableArray *idArr = [[NSMutableArray alloc] init];
            for (int i = 0; i<[employeeDeleteArr count]; i++)
            {
                if ([[employeeDeleteArr objectAtIndex:i] integerValue] != 0)
                {
                    [idArr addObject:[employeeDeleteArr objectAtIndex:i]];
            
                }
                
           }
            NSLog(@"id which will be delete:%@",idArr);

            [self deleteEmployeeService:idArr];
        }
    }

}

#pragma mark - Consume Web services


-(void) deleteEmployeeService:(NSMutableArray *)idArr {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            idArr,@"EmpId",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_EMPLOYEE]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_EMPLOYEE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObjectForUpdateEmployee:responseObject];
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

-(void)parseDataResponseObjectForUpdateEmployee:(NSDictionary *)dictionary {
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
            
            [self viewDidLoad];
            [self hideHud];
          //  self.btnSearch.tag = 1;
        }
        
    }
    else {
        [self hideHud];
        //self.btnSearch.tag = 1;
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null]) {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
        }
        else {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"Code"]];
        }
    }
    
}




-(void)fetchEmployeeListFromWebServices:(NSString*)str
{
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //NSArray *regionArr=[userDetails objectForKey:@"AllRegion"];
    
  //  NSString * str=[[regionArr objectAtIndex:0] valueForKey:@"RegionId"];
    
  //   NSString* str1= [[regionArr valueForKey:@"RegionId"] componentsJoinedByString: @"&region_id="];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@user_id=%@&region_id=%@",BASE_URL,EMPLOYEE_LIST,[userDetails objectForKey:@"Userid"],str]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@user_id=%@&region_id=%@",BASE_URL,EMPLOYEE_LIST,[userDetails objectForKey:@"Userid"],str] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            
            if ([dictionary objectForKey:@"data"] != [NSNull null])
            {
                if ([[dictionary objectForKey:@"data"] objectForKey:@"Employee"] != [NSNull null])
                {
                    
                    employeeArr = [[dictionary objectForKey:@"data"] objectForKey:@"Employee"];
                    employeeInfoArr = [NSArray arrayWithArray:employeeArr];
                    employeeDeleteArr  = [[NSMutableArray alloc]init];
                    for (int i=0 ; i<[employeeArr count]; i++)
                    {
                        [employeeDeleteArr addObject:@"0"];
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.EmployeeTableView reloadData];
                    });
                    [self hideHud];
                }
            }
        }
        
    }
    else {
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]
            != [NSNull null])
        {
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            
        }
        else
        {
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

-(void)updateNewEmployeeInList {
    [self viewDidLoad];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}

-(void)backFromSelectRegionviewControllerForType:(NSString *)Regionid :(NSString *)regionName
{
    NSLog(@"Regiontype  >>>%@",Regionid);
    
    [self fetchEmployeeListFromWebServices:Regionid];
    
    [self.btnSelectRegion setTitle:regionName forState:UIControlStateNormal];
    
    [self.EmployeeTableView reloadData];
}

@end
