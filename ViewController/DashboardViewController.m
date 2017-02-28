//
//  DashboardViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIButton+tintImage.h"
#import "App_Constant.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "App_Constant.h"
#import "SalesTracker_AppURL.h"
#import "UIView+Toast.h"

@interface DashboardViewController ()
{
    MBProgressHUD *hud;
    DashboardCollectionViewCell *cell;
    NSArray *imageArr, *titleArr, *identifierArr, *dataArr;
    NSDictionary *userDetails, *profileDict;
}
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.btnLogout setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnProfile setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    userDetails = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"];
    NSLog(@">> %@",userDetails);
    
    if ([userDetails objectForKey:@"FirstName"] != nil) {
        [self.lblHeader setText:[NSString stringWithFormat:@"Welcome, %@",[userDetails objectForKey:@"FirstName"]]];
    }
    if ([userDetails objectForKey:@"Pos_name"] != nil) {
       
        [self setDashboardValuesAccordingToUser:[userDetails objectForKey:@"Pos_name"]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setDashboardValuesAccordingToUser:(NSString *)positionName {
    NSLog(@"Position name --->>%@",positionName);
    
    if ([positionName isEqualToString:MARKETER_POSITION_NAME]) {
       
        dataArr = MARKETER_DASHBOARD_ARRAY;
    
    }
    else if ([positionName isEqualToString:AAS_POSITION_NAME]) {
        
        dataArr = AAS_DASHBOARD_ARRAY;
        
    }
    else if ([positionName isEqualToString:HOS_POSITION_NAME]) {
        
        dataArr = HOS_DASHBOARD_ARRAY;
    }
    else if ([positionName isEqualToString:BM_POSITION_NAME]) {
    
        dataArr = BM_DASHBOARD_ARRAY;
    }
    else if ([positionName isEqualToString:RM_POSITION_NAME]) {
        
        dataArr = RM_DASHBOARD_ARRAY;
    }

}


- (IBAction)btnProfile:(id)sender {
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PROFILE"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnLogout:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Do you want to Logout?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.tag = 1;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            [self callLogoutAPI];
        }
    }
}

-(void)callLogoutAPI {
   
    [self showHud];
   
    NSString *strDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Device_Token"];
    NSString *userID = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Userid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /*
     {
     "username": "head",
     "password": "head@123",
     "type": "IOS",
     "token": "I1254",
     "islogin":"true"
     }
     */
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            userID,@"userid",
                            DEVICE_TYPE,@"type",
                            strDeviceToken,@"token",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,USER_LOGOUT]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,USER_LOGOUT] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responseObject];
            });
            
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
        
        if ([[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] != [NSNull null]) {
            
            
            [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
            if ([dictionary objectForKey:@"Data"] != [NSNull null]) {
               
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDetails"];
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
                [self presentViewController:viewController animated:YES completion:nil];
                
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

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataArr count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"Colour_Status"] isEqualToString:@"1"]) {
        [cell setBackgroundColor:[UIColor colorWithRed:(241.0/255.0) green:(241.0/255.0) blue:(241.0/255.0) alpha:1.0f]];
    }
    else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    cell.viewCircle.layer.cornerRadius = 25.0f;
    cell.viewCircle.layer.borderWidth = 1.0f;
    cell.viewCircle.layer.borderColor = [UIColor colorWithRed:(65/225.0) green:(65/225.0) blue:(65/225.0) alpha:1.0f].CGColor;
    UIImage *image2 = [[UIImage imageNamed:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"Icon_Name"]]
                       imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // put UIImage in a UIImageView and adjust color with tintColor
    [cell.imageDashboard setImage:image2];
    cell.imageDashboard.tintColor =[UIColor colorWithRed:(65/225.0) green:(65/225.0) blue:(65/225.0) alpha:1.0f];
    
    cell.lblTitle.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"Title"];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1=collectionviewSize.width/2;
    side2=collectionviewSize.height;
    return CGSizeMake(side1, side1+20);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"Identifier"]];
    [self presentViewController:viewController animated:YES completion:nil];
    
}
@end
