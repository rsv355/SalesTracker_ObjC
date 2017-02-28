//
//  SalesVisitPlanViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "SalesVisitPlanViewController.h"

#import "MonthViewCalendarViewController.h"
#import "CustomAnimationAndTransiotion.h"
#import "AddPlanViewController.h"
#import "DayViewCalendarViewController.h"

#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"

#import "SalesTracker_AppURL.h"
#import "App_Constant.h"

#import "SelectFilterViewController.h"
#import "CustomAnimationAndTransiotion.h"

#import "SalesVisitPlanCollectionViewCell.h"
#import "SelectRegionViewController.h"

@interface SalesVisitPlanViewController ()<MonthViewControllerDelegate, AddPlanViewControllerDelegate, DayViewControllerDelegate, SelectFilterViewControllerDelegate,SelectRegionViewControllerDelegate>
{
    SalesVisitPlanCollectionViewCell *cell;
    MBProgressHUD *hud;
    
    NSDate *date ;
    
    NSDateFormatter *dateFormatter, *wsDateFormatter;
    NSMutableArray *dateArr, *eventArr, *planArr;
    NSString *firstDate, *currentMonth, *today;
    NSString *userID, *salesVisitID, *strStoryboardID;
    UIColor *selectColor, *deselectColor;
    
    NSMutableArray *branchArr, *employeeArr, *marketerArr, *hosArr, *aasArr;
    NSInteger branchIndex, marketerIndex, aasIndex, hosIndex;
    
    NSArray *filterDataArr;
    
    NSMutableArray *placeHolderArr;
    
    NSDictionary *userDetails;
    NSArray * allRegion;
    NSString * regionsName1, *branchName1,  *regionId;
}

@property(strong, nonatomic)CustomAnimationAndTransiotion  *customTransitionController;
@end


@implementation SalesVisitPlanViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
   
    userDetails = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"];
    NSLog(@"user data...:%@",userDetails);

    allRegion=[userDetails objectForKey:@"AllRegion"];
    regionsName1=[[allRegion valueForKey:@"Region"] objectAtIndex:0];
    
    
    // Do any additional setup after loading the view.

    placeHolderArr = [[NSMutableArray alloc] init];
    

    [self initialize];
    
    [self initializeCalendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialize {
    
    NSString *positionName =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetails"] objectForKey:@"Pos_name"];
    
    if ([positionName isEqualToString:MARKETER_POSITION_NAME]) {
        
        self.collectionViewHeightConstraint.constant = 0.0f;
    }
    else if ([positionName isEqualToString:AAS_POSITION_NAME]) {
        
        self.collectionViewHeightConstraint.constant = 0.0f;
    }
    else if ([positionName isEqualToString:HOS_POSITION_NAME]) {
        
        filterDataArr = HOS_FILTER_ARRAY;
        
    }
    else if ([positionName isEqualToString:BM_POSITION_NAME]) {
        
        filterDataArr = BM_FILTER_ARRAY;
    }
    else if ([positionName isEqualToString:RM_POSITION_NAME]) {
        
       filterDataArr = RM_FILTER_ARRAY;
    }
    
    for (NSDictionary *dict in filterDataArr) {
        
        [placeHolderArr addObject:[dict objectForKey:@"title"]];
    }
    
    double collectionviewSize = (self.collectionView.frame.size.width/2) - 10;
    NSInteger c;
    
    if ([filterDataArr count]%2 ==0) {
       
        c = [filterDataArr count]/2;
      
    }
    else {
        c = ([filterDataArr count]/2) +1;
    }
    
    if ([positionName isEqualToString:RM_POSITION_NAME]) {
        
        self.collectionViewHeightConstraint.constant = ((collectionviewSize/4)*c)+10;
    }
    else{
        
        self.collectionViewHeightConstraint.constant = ((collectionviewSize/4)*c)+5;
   }
    
    
    [self.collectionView reloadData];
}

-(void)initializeCalendar {
 
    self.viewProgress.layer.cornerRadius = 6.0f;
    self.viewCalendar.layer.cornerRadius = 23.0f;
    
    selectColor = [UIColor blackColor];
    deselectColor = [UIColor grayColor];
    
    userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
    salesVisitID = [NSString stringWithString:userID];
    [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
    self.segmentControl.layer.cornerRadius = 20.0f;
    self.segmentControl.selectedSegmentIndex = 1;
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    wsDateFormatter = [[NSDateFormatter alloc] init];
    wsDateFormatter.dateFormat = @"yyyy-MM-dd";
    
    date =[[NSDate alloc] init];
    
    today = [dateFormatter stringFromDate:date];
    
    strStoryboardID = @"MONTH_VIEW";
    self.btnAddPlan.hidden = YES;
    
    
    branchArr = [[NSMutableArray alloc]init];
    employeeArr = [[NSMutableArray alloc]init];
    marketerArr = [[NSMutableArray alloc]init];
    hosArr = [[NSMutableArray alloc]init];
    aasArr = [[NSMutableArray alloc]init];
    
    [self fetchSalesVisitPlan];
    
    //NSString *regionId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"RegionId"];
    
  
    if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]) {
        
        if (placeHolderArr.count>0) {
            
            regionId =[[allRegion valueForKey:@"RegionId"] objectAtIndex:0];
            
            [placeHolderArr replaceObjectAtIndex:0 withObject:[[allRegion valueForKey:@"Region"] objectAtIndex:0]];
            
            [self fetchFilterDataFromWebServices:[NSString stringWithFormat:@"%@%@regionid=%@",BASE_URL,FETCH_BRANCHES,regionId] for:0];
            
        }

    }
    else{
        
         regionId =[[allRegion valueForKey:@"RegionId"] objectAtIndex:0];
    
    
        [self fetchFilterDataFromWebServices:[NSString stringWithFormat:@"%@%@regionid=%@",BASE_URL,FETCH_BRANCHES,regionId] for:0];
    
    }
    
}

- (IBAction)btnback:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"strDate"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentControlClicked:(id)sender {
  
    if (self.segmentControl.selectedSegmentIndex == 1 ) {
        
        self.btnAddPlan.hidden = YES;
        strStoryboardID = @"MONTH_VIEW";
        
        [self fetchSalesVisitPlan];
    
    }
    else if (self.segmentControl.selectedSegmentIndex == 0) {
       
        if([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID])
        {
            self.btnAddPlan.hidden = YES;

        }
        else
        {
            self.btnAddPlan.hidden = NO;

        }
        
        [self EmbedContainerView:@"DAY_VIEW"];
    }

}

- (IBAction)btnAddPlan:(id)sender {
    
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:(-86400.0*1)];
    
    NSDate *changedDate = [dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"]];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *newChangeDate = [cal dateByAddingUnit:NSCalendarUnitDay
                                       value:1
                                      toDate:changedDate
                                     options:0];
    
    if ([currentDate timeIntervalSince1970] >= [newChangeDate timeIntervalSince1970]) {
        
        [self.view makeToast:@"You can not add"];
    }
    else {
    
        AddPlanViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_PLAN"];
        popover.delegate = (id)self;
        popover.modalPresentationStyle = UIModalPresentationCustom;
        [popover setTransitioningDelegate:_customTransitionController];
        [self presentViewController:popover animated:YES completion:nil];
    }

}

-(void)EmbedContainerView:(NSString *)storyboardID {
   
    if ([storyboardID isEqualToString:@"DAY_VIEW"]) {
        
        DayViewCalendarViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
        vc.delegate = (id)self;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        [self.containerView addSubview:vc.view];
    }
    else if ([storyboardID isEqualToString:@"MONTH_VIEW"]) {
        
        
        MonthViewCalendarViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MONTH_VIEW"];
        vc.delegate = (id)self;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        [self.containerView addSubview:vc.view];    }
}

-(void)fetchSalesVisitPlan {
    NSString *strDate;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] == [NSNull null] || [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"] == nil) {
        
        date = [NSDate date];
        strDate = [dateFormatter stringFromDate:date];
        
    }
    else {
        strDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"strDate"];
        date = [dateFormatter dateFromString:strDate];
    }
    
    [self fetchPlanForMonth:[[strDate componentsSeparatedByString:@"-"] objectAtIndex:1] forYear:[[strDate componentsSeparatedByString:@"-"] objectAtIndex:2] forUser:salesVisitID];

}

#pragma mark - Custom Delegate methods

-(void)updateCalendar:(NSInteger)selction {
    
    if (selction == 1) {
        
        self.btnAddPlan.hidden = NO;
        self.segmentControl.selectedSegmentIndex = 0;
        
        [self EmbedContainerView:@"DAY_VIEW"];

    }
    else {
        
        
        strStoryboardID = @"MONTH_VIEW";
        [self fetchSalesVisitPlan];
    }
}

-(void)backFromAddPlanViewController {
    
    strStoryboardID = @"DAY_VIEW";
    
    [self fetchSalesVisitPlan];
    
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


#pragma mark - Consume webservice for plan

-(void)fetchPlanForMonth :(NSString *)month forYear:(NSString *)year forUser:(NSString *)currentID {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*
     
     {
     "UserId":699,
     "Month":9,
     "Year":2016
     }
     
     */
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            currentID,@"UserId",
                            month,@"Month",
                            year,@"Year",
                            nil];
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_PLAN]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_PLAN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseObject != [NSNull null]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responseObject];
            });
            //NSLog(@">> %@",responseObject);
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

-(void)parseDataResponseObject :(NSDictionary *)dictionary {
    
    planArr = [[NSMutableArray alloc] init];
    eventArr = [[NSMutableArray alloc] init];
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            
            if ([[dictionary objectForKey:@"data"] objectForKey:@"Plans"] != [NSNull null]) {
                
                planArr = [[dictionary objectForKey:@"data"] objectForKey:@"Plans"];
                
                NSArray *planArray = [NSArray arrayWithArray:planArr];
                [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:planArray] forKey:@"PLANS"];
                
                [self EmbedContainerView:strStoryboardID];
                if ([strStoryboardID isEqualToString:@"MONTH_VIEW"]) {
                    
                    [self initialize];
                }
                
            }
            
        }
        
    }
    else {
        
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"PLANS"];
        [self EmbedContainerView:strStoryboardID];
        if ([strStoryboardID isEqualToString:@"MONTH_VIEW"]) {

            [self initialize];
        }
        
    }
}

-(void)updateCalenderView
{
    strStoryboardID = @"DAY_VIEW";
    [self fetchSalesVisitPlan];
}


#pragma mark - FILTER Methods

- (IBAction)selectFilter:(id)sender {
    
    if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:@"0"]) {
        
        SelectFilterViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SELECTION_FILTER"];
        popover.delegate = (id)self;
        popover.strSelection = @"0";
        popover.dataArr = [NSArray arrayWithArray:branchArr];
        popover.selectedIndex = branchIndex;
        popover.filterIndex = [sender tag];
        popover.modalPresentationStyle = UIModalPresentationCustom;
        [popover setTransitioningDelegate:_customTransitionController];
        [self presentViewController:popover animated:YES completion:nil];
    }
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:@"-1"]){
    
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
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:MARKETER_ROLE_ID]) {
        
        NSMutableArray *filterArr = [[NSMutableArray alloc]init];
        
        if (![[placeHolderArr objectAtIndex:0] isEqualToString:@"Select Branch"]) {
            
           filterArr = [self filterMarketerFromList:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchId"]];
        }
        else {
            
            filterArr = [NSMutableArray arrayWithArray:marketerArr];
        }
       
        
        if ([filterArr count] == 0) {
            
            [self.view makeToast:@"No Markter Found"];
        }
        else {
            
            
            NSLog(@"Select Marketer------>>%@",filterArr);
            SelectFilterViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SELECTION_FILTER"];
            popover.delegate = (id)self;
            popover.strSelection = MARKETER_ROLE_ID;
            popover.dataArr = [NSArray arrayWithArray:filterArr];
            popover.selectedIndex = marketerIndex;
            popover.filterIndex = [sender tag];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
            
            
            //--------------------------Change the segment control---------------------------
            if (self.segmentControl.selectedSegmentIndex == 0){
                
                self.segmentControl.selectedSegmentIndex = 1;
                
                // [self.segmentControl setSelectedSegmentIndex:1];
            }

        }
        
      
        
    }
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:AAS_ROLE_ID]) {
        
        NSMutableArray *filterArr = [[NSMutableArray alloc]init];
        
        if (![[placeHolderArr objectAtIndex:0] isEqualToString:@"Select Branch"]) {
            
            filterArr = [self filterAASFromList:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchId"]];
        }
        else {
            
            filterArr = [NSMutableArray arrayWithArray:aasArr];
        }
        
        
        if ([filterArr count] == 0) {
            
            [self.view makeToast:@"No AAS Found"];
        }
        else {
            SelectFilterViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SELECTION_FILTER"];
            popover.delegate = (id)self;
            popover.strSelection = AAS_ROLE_ID;
            popover.dataArr = [NSArray arrayWithArray:filterArr];
            popover.selectedIndex = aasIndex;
            popover.filterIndex = [sender tag];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
            
            
            //--------------------------Change the segment control---------------------------
            if (self.segmentControl.selectedSegmentIndex == 0){
                
                self.segmentControl.selectedSegmentIndex = 1;
                
                // [self.segmentControl setSelectedSegmentIndex:1];
            }

            
        }
        
        
        
    }
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:HOS_ROLE_ID]) {
       
        NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    
        if (![[placeHolderArr objectAtIndex:0] isEqualToString:@"Select Branch"]) {
            
            filterArr = [self filterHOSFromList:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchId"]];
        }
        else {
            
            filterArr = [NSMutableArray arrayWithArray:hosArr];
        }
        
        if ([filterArr count] == 0) {
            
            [self.view makeToast:@"No HOS from selected branch"];
        }
        else {
            NSLog(@"FILTERED------>>%@",filterArr);

            SelectFilterViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SELECTION_FILTER"];
            popover.delegate = (id)self;
            popover.strSelection = HOS_ROLE_ID;
            popover.dataArr = [NSArray arrayWithArray:filterArr];
            popover.selectedIndex = hosIndex;
             popover.filterIndex = [sender tag];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
            
            
            //--------------------------Change the segment control---------------------------
            if (self.segmentControl.selectedSegmentIndex == 0){
                
                self.segmentControl.selectedSegmentIndex = 1;
                
                // [self.segmentControl setSelectedSegmentIndex:1];
            }

        }
        
       
        
    }
    
    
    

}

-(NSMutableArray *)filterMarketerFromList:(NSString *)branchID {
    
    NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in marketerArr) {
        
        if ([branchID isEqualToString:[dict objectForKey:@"BranchId"]]) {
            
            [filterArr addObject:dict];
           
        }
    }
    
    return filterArr;
}
-(NSMutableArray *)filterAASFromList:(NSString *)branchID {
    
    NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in aasArr) {
        
        if ([branchID isEqualToString:[dict objectForKey:@"BranchId"]]) {
            
            [filterArr addObject:dict];
            
        }
    }
    
    return filterArr;
}

-(NSMutableArray *)filterHOSFromList:(NSString *)branchID {
    
    NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in hosArr) {
        
        if ([branchID isEqualToString:[dict objectForKey:@"BranchId"]]) {
            
            [filterArr addObject:dict];
            
        }
    }
    
    
    return filterArr;
}


- (IBAction)deselectFilter:(id)sender {
    
    if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:@"0"]) {
        
        branchIndex = 0;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]){
        
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
        
        }
        
//        //--------------------------Change the segment control---------------------------
//        if (self.segmentControl.selectedSegmentIndex == 0){
//            
//            self.segmentControl.selectedSegmentIndex = 1;
//            
//            // [self.segmentControl setSelectedSegmentIndex:1];
//        }
//
        
        [self.collectionView reloadData];
    }
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:MARKETER_ROLE_ID]) {
        
        salesVisitID = [NSString stringWithString:userID];
        [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
        [self fetchSalesVisitPlan];
        
        marketerIndex = 0;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]){
            
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
            [placeHolderArr replaceObjectAtIndex:1 withObject:branchName1];

        }

        
        //--------------------------Change the segment control---------------------------
        if (self.segmentControl.selectedSegmentIndex == 0){
            
            self.segmentControl.selectedSegmentIndex = 1;
            
            // [self.segmentControl setSelectedSegmentIndex:1];
        }
        

        
        [self.collectionView reloadData];
    }
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:AAS_ROLE_ID]) {
        
        salesVisitID = [NSString stringWithString:userID];
        [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
        [self fetchSalesVisitPlan];
        
        aasIndex = 0;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]){
            
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
            [placeHolderArr replaceObjectAtIndex:1 withObject:branchName1];
            
        }

        //--------------------------Change the segment control---------------------------
        if (self.segmentControl.selectedSegmentIndex == 0){
            
            self.segmentControl.selectedSegmentIndex = 1;
            
            // [self.segmentControl setSelectedSegmentIndex:1];
        }
        

        
        [self.collectionView reloadData];
    }
    else if ([[[filterDataArr objectAtIndex:[sender tag]] objectForKey:@"tag"] isEqualToString:HOS_ROLE_ID]) {
        
        salesVisitID = [NSString stringWithString:userID];
        [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
        [self fetchSalesVisitPlan];
        
        hosIndex = 0;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID]){
            
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
            [placeHolderArr replaceObjectAtIndex:1 withObject:branchName1];
            
        }

        //--------------------------Change the segment control---------------------------
        if (self.segmentControl.selectedSegmentIndex == 0){
            
            self.segmentControl.selectedSegmentIndex = 1;
            
            // [self.segmentControl setSelectedSegmentIndex:1];
        }
        

        
        [self.collectionView reloadData];
    }


}

-(void) fetchFilterDataFromWebServices:(NSString *)strURL for:(NSInteger)selection {
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",strURL);
    
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responsDict != nil) {
            
            [self hideHud];
            [self parseFilterDataResponseObject:responsDict for:selection];
            
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

-(void)parseFilterDataResponseObject:(NSDictionary *)dictionary for:(NSInteger)selection {
    
    
    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"]integerValue] == 1) {
        
        if ([dictionary objectForKey:@"data"] != [NSNull null]) {
            
            if (selection == 0) {
                
                branchArr = [[dictionary objectForKey:@"data"] objectForKey:@"Branches"];
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *strURL = [NSString stringWithFormat:@"%@%@user_id=%@&region_id=%@",BASE_URL,FETCH_EMPLOYEE,userID,regionId];
                    
                    NSLog(@"fetch employee for 4>>>>%@%@user_id=%@&region_id=%@",BASE_URL,FETCH_EMPLOYEE,userID,regionId);
                    
                    [self fetchFilterDataFromWebServices:strURL for:4];
                });
                
                if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID])
                {
                    
                    branchName1=[[branchArr valueForKey:@"BranchName"] objectAtIndex:0];
                    
                [placeHolderArr replaceObjectAtIndex:1 withObject:[[branchArr valueForKey:@"BranchName"] objectAtIndex:0]];
                }
                [self.collectionView reloadData];
            
            }
            
            else
            {
                
                employeeArr = [[dictionary objectForKey:@"data"] objectForKey:@"Employee"];
                
//                NSLog(@"employeeArr is>>>>>>>%@",employeeArr);
                
                marketerArr=[[NSMutableArray alloc]init];
                aasArr=[[NSMutableArray alloc]init];
                hosArr=[[NSMutableArray alloc]init];

                
                for (NSDictionary *dict in employeeArr) {
                    
                    if ([[dict objectForKey:@"Position"] isEqualToString:MARKETER_ROLE_ID]) {
                      
                        
                        [marketerArr addObject:dict];
                    }
                    else if ([[dict objectForKey:@"Position"] isEqualToString:AAS_ROLE_ID]) {
                        
                        [aasArr addObject:dict];
                    }
                    else if ([[dict objectForKey:@"Position"] isEqualToString:HOS_ROLE_ID]) {
                        
                        [hosArr addObject:dict];
                    }

                }
        
                [self hideHud];
            }
        }
    }
}

-(void)backFromSelectFilterviewControllerForType:(NSInteger)filtertype withIndexpath:(NSInteger)selection {
    
    
    NSLog(@"BACK WITH ----->>>%@",filterDataArr);
    
    if ([[[filterDataArr objectAtIndex:filtertype] objectForKey:@"tag"] isEqualToString:@"0"]) {
        
        branchIndex = selection;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
         [placeHolderArr replaceObjectAtIndex:filtertype withObject:[[branchArr objectAtIndex:selection] objectForKey:@"BranchName"]];
        
        branchName1=[[branchArr objectAtIndex:selection] objectForKey:@"BranchName"];
        
         [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
        
        [self.collectionView reloadData];
    }
    else if ([[[filterDataArr objectAtIndex:filtertype] objectForKey:@"tag"] isEqualToString:MARKETER_ROLE_ID]) {
        
        marketerIndex = selection;
       
        [placeHolderArr removeAllObjects];
        
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
//        [placeHolderArr replaceObjectAtIndex:0 withObject:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchName"]];
        NSMutableArray *filterArr = [self filterMarketerFromList:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchId"]];

        [placeHolderArr replaceObjectAtIndex:filtertype withObject:[[filterArr objectAtIndex:selection] objectForKey:@"Name"]];
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID])
        {
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
            [placeHolderArr replaceObjectAtIndex:1 withObject:branchName1];
        
            NSLog(@"placeHolderArr in MKT is>>>>%@",placeHolderArr);
        }
        
        [self.collectionView reloadData];
       
        salesVisitID = [[filterArr objectAtIndex:marketerIndex] objectForKey:@"Id"];
       
        [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
        [self fetchSalesVisitPlan];
    }
    else if ([[[filterDataArr objectAtIndex:filtertype] objectForKey:@"tag"] isEqualToString:AAS_ROLE_ID]) {
        
        aasIndex = selection;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
//        [placeHolderArr replaceObjectAtIndex:0 withObject:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchName"]];
       NSMutableArray *filterArr = [self filterAASFromList:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchId"]];
        
        [placeHolderArr replaceObjectAtIndex:filtertype withObject:[[filterArr objectAtIndex:selection] objectForKey:@"Name"]];
        
        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID])
        {
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
            [placeHolderArr replaceObjectAtIndex:1 withObject:branchName1];
        
            NSLog(@"placeHolderArr in ASS is>>>>%@",placeHolderArr);
        }
    
        [self.collectionView reloadData];
        
        salesVisitID = [[filterArr objectAtIndex:aasIndex] objectForKey:@"Id"];
        
        [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
        [self fetchSalesVisitPlan];
    }

    else if ([[[filterDataArr objectAtIndex:filtertype] objectForKey:@"tag"] isEqualToString:HOS_ROLE_ID]) {
        
        hosIndex = selection;
        
        [placeHolderArr removeAllObjects];
        for (NSDictionary *dict in filterDataArr) {
            
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }

        NSMutableArray *filterArr = [self filterHOSFromList:[[branchArr objectAtIndex:branchIndex] objectForKey:@"BranchId"]];
       
        [placeHolderArr replaceObjectAtIndex:filtertype withObject:[[filterArr objectAtIndex:selection] objectForKey:@"Name"]];
        
        NSLog(@"FILTERED------>>%@",filterArr);

        if ([[userDetails objectForKey:@"Roleid"] isEqualToString:RM_ROLE_ID])
        {
            [placeHolderArr replaceObjectAtIndex:0 withObject:regionsName1];
            [placeHolderArr replaceObjectAtIndex:1 withObject:branchName1];
        
            NSLog(@"placeHolderArr in HOS is>>>>%@",placeHolderArr);
        }
        
        [self.collectionView reloadData];
        
        salesVisitID = [[filterArr objectAtIndex:hosIndex] objectForKey:@"Id"];
        
        [[NSUserDefaults standardUserDefaults] setObject:salesVisitID forKey:@"salesVisitID"];
        
        [self fetchSalesVisitPlan];
    }

}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [filterDataArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:(65/225.0) green:(65/225.0) blue:(65/225.0) alpha:1.0f].CGColor;
    
    [cell.btnSelectFilter setTitle:[placeHolderArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    cell.btnSelectFilter.tag = indexPath.row;
    [cell.btnSelectFilter addTarget:self action:@selector(selectFilter:) forControlEvents:UIControlEventTouchDown];
    
    cell.btnDeselectFilter.tag = indexPath.row;
    [cell.btnDeselectFilter addTarget:self action:@selector(deselectFilter:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1 = (collectionviewSize.width/2) - 10;
    side2=collectionviewSize.height;
    //self.collectionViewHeightConstraint.constant = ((side1/4)*2)+5;
    return CGSizeMake(side1, side1/4);
}

#pragma mark-select region custom delegate method

-(void)backFromSelectRegionviewControllerForType:(NSString *)Regionid :(NSString *)regionName{

    NSLog(@"region id is>>>>%@",Regionid);
    NSLog(@"region name is>>>>>%@",regionName);

    regionsName1=regionName;
    
    if ([[[filterDataArr objectAtIndex:0] objectForKey:@"tag"] isEqualToString:@"-1"]) {
        
           [placeHolderArr removeAllObjects];
        
        for (NSDictionary *dict in filterDataArr)
        {
            [placeHolderArr addObject:[dict objectForKey:@"title"]];
        }
        
        [placeHolderArr replaceObjectAtIndex:0 withObject:regionName];
        
        regionId=Regionid;
        branchIndex=0;

        [self fetchFilterDataFromWebServices:[NSString stringWithFormat:@"%@%@regionid=%@",BASE_URL,FETCH_BRANCHES,regionId] for:0];

        
        //[placeHolderArr replaceObjectAtIndex:1 withObject:[[branchArr valueForKey:@"BranchName"] objectAtIndex:0]];
        
           //        [self.collectionView reloadData];
    }
}

@end
