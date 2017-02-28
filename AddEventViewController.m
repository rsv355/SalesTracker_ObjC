//
//  AddEventViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AddEventViewController.h"
#import "SelectionViewController.h"
#import "CustomAnimationAndTransiotion.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"

@interface AddEventViewController () <SelectionViewControllerDelegate>
{
    MBProgressHUD *hud;
    NSArray *regionArr, *branchArr, *positionArr;
    NSString *regionId, *branchId, *positionId;
    NSString *strRegion, *strBranch, *strPosition;
    
    UIDatePicker *datePicker,* tempPicker;
    NSString * dateFromPicker;
}

@property(strong, nonatomic)CustomAnimationAndTransiotion  *customTransitionController;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"eventDict.... is:%@",self.eventDict);
    
    self.bottomSpaceToScrollConstraints.constant = 15.0f;
    if (self.eventDict == nil) {
        
        [self.lblHeader setText:@"Add Event"];
        [self.btnAddEvent setTitle:@"Add Event" forState:UIControlStateNormal];
        [self showHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self fetchDataFromWebServices:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_REGION] for:@"region"];
            
        });
    }
    else {
        
        [self.lblHeader setText:@"Event Detail"];
        
        
        [self.btnAddEvent setTitle:@"Update Event" forState:UIControlStateNormal];
        self.viewTopSpaceConstraint.constant = 15.0f;
        self.viewBranchHeightConstraints.constant = 0.0f;
        self.viewRegionHeightConstraints.constant = 0.0f;
        self.viewPositionHeightConstraints.constant = 0.0f;
        [self.txtBranch setHidden:YES];
        [self.txtRegion setHidden:YES];
        [self.txtPosition setHidden:YES];
        [self setTextFieldValues];
        
        
    }
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self
                   action:@selector(dateUpdated:)
         forControlEvents:UIControlEventValueChanged];
    self.txtDate.inputView = datePicker;
    
    
}

- (void) dateUpdated:(UIDatePicker *)datePicker1 {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    
    dateFromPicker=[formatter stringFromDate:datePicker1.date];
    
    // self.txtDate.text = [formatter stringFromDate:datePicker1.date];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIKeyboard methods

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField

{
    if (textField == _txtDate) {
        
        UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(20, 10, 320, 40)];
        
        keyboardToolBar.barStyle = UIBarStyleBlackOpaque;
        [keyboardToolBar setTintColor:[UIColor whiteColor]];
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                    
                                    [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboardForPicker)],
                                    nil]];
        
        textField.inputAccessoryView = keyboardToolBar;
    }
    else {
        UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(20, 10, 320, 40)];
        
        keyboardToolBar.barStyle = UIBarStyleBlackOpaque;
        [keyboardToolBar setTintColor:[UIColor whiteColor]];
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                    
                                    [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                    nil]];
        
        textField.inputAccessoryView = keyboardToolBar;

    }
    return YES;
}

-(void)resignKeyboard {
    
    [self.view endEditing:YES];
}

-(void)resignKeyboardForPicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateFromPicker=[formatter stringFromDate:datePicker.date];
    self.txtDate.text = dateFromPicker;
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.frame.size.width, self.scrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



-(void)setTextFieldValues {
    
    if ([self.eventDict objectForKey:@"Title"] != [NSNull null]) {
        
        [self.txtEventName setText:[self.eventDict objectForKey:@"Title"]];
    }
    if ([self.eventDict objectForKey:@"Description"] != [NSNull null]) {
        
        [self.txtDecription setText:[self.eventDict objectForKey:@"Description"]];
    }
    if ([self.eventDict objectForKey:@"EventDate"] != [NSNull null]) {
        
        [self.txtDate setText:[self.eventDict objectForKey:@"EventDate"]];
    }
    if ([self.eventDict objectForKey:@"RegionId"] != [NSNull null]) {
        
        regionId = [self.eventDict objectForKey:@"RegionId"];
    }
    if ([self.eventDict objectForKey:@"BranchId"] != [NSNull null]) {
        
        branchId = [self.eventDict objectForKey:@"BranchId"];
    }
    if ([self.eventDict objectForKey:@"RoleId"] != [NSNull null]) {
        
        positionId = [self.eventDict objectForKey:@"RoleId"];
    }
    if ([self.eventDict objectForKey:@"RoleId"] != [NSNull null]) {
        
        positionId = [self.eventDict objectForKey:@"RoleId"];
    }
    if ([self.eventDict objectForKey:@"UserID"] != [NSNull null]) {
        
        if ([[self.eventDict objectForKey:@"UserID"] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"]]) {
            
            self.btnAddEvent.hidden = NO;
            self.btnDelete.hidden = NO;
            [self setUserInteraction:YES];
        }
        else {
            self.btnAddEvent.hidden = YES;
            self.btnDelete.hidden = YES;
            [self setUserInteraction:NO];
        }
    }
    
}

-(void)setUserInteraction :(BOOL)isTrue {
    
    [self.txtEventName setUserInteractionEnabled:isTrue];
    [self.txtDecription setUserInteractionEnabled:isTrue];
    [self.txtDate setUserInteractionEnabled:isTrue];
    [self.btnDate setUserInteractionEnabled:isTrue];
    [self.btnRegion setUserInteractionEnabled:isTrue];
    [self.btnBranch setUserInteractionEnabled:isTrue];
    [self.btnPosition setUserInteractionEnabled:isTrue];
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSelection:(id)sender {
    
    NSString *strSelection;
    
    if ([sender tag] == 1) {
        
    }
    else  {
        NSArray *ary;
        NSString *strSelect;
        if ([sender tag] == 2) {
            
            ary = [NSArray arrayWithArray:regionArr];
            strSelect = regionId;
            strSelection = @"region";
        }
        else if ([sender tag] == 3) {
            
            if (regionId == nil || [regionId length] == 0) {
                
                ary = [NSArray arrayWithArray:branchArr];
            }
            else if([regionId isEqualToString:@"0"]){
                
                ary = [NSArray arrayWithArray:branchArr];
            }
            else {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in branchArr) {
                    if ([[dict objectForKey:@"RegionId"] isEqualToString:regionId]) {
                        
                        [mutArr addObject:dict];
                    }
                }
                ary = [NSArray arrayWithArray:mutArr];
            }
            //ary = [NSArray arrayWithArray:branchArr];
            strSelect = branchId;
            strSelection = @"branch";
        }
        else if ([sender tag] == 4) {
            
            ary = [NSArray arrayWithArray:positionArr];
            strSelect = positionId;
            strSelection = @"position";
        }
        
        SelectionViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SELECTION"];
        popover.delegate = (id)self;
        popover.strSelection = strSelection;
        popover.dataArr = ary;
        popover.strSelectedId = strSelect;
        popover.modalPresentationStyle = UIModalPresentationCustom;
        [popover setTransitioningDelegate:_customTransitionController];
        [self presentViewController:popover animated:YES completion:nil];
    }
}

- (IBAction)btnAddEvent:(id)sender {
    /*
     {
     Id: "87",
     UserID: "694",
     EventDate: "2016-10-19",
     Title: "bm",
     Description: "ok",
     RegionId: "20",
     BranchId: "51,",
     RoleId: "5,"
     },
     */
    
    if (self.eventDict == nil) {
        
        if ([[self.txtEventName text] length] == 0 || [[self.txtDate text] length] == 0 || [[self.txtRegion text] length] == 0 || [[self.txtBranch text] length] == 0 || [[self.txtPosition text] length] == 0 || [[self.txtDecription text] length] == 0) {
            
            [self.view makeToast:@"Please fill up all the fields."];
        }
        else  {
            
            NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            
//            NSDate *date = [NSDate date];
//            NSDateFormatter *dateFromatter = [[NSDateFormatter alloc]init];
//            [dateFromatter setDateFormat:@"yyyy-MM-dd"];
            NSString *eventDate = [self.txtDate text];
            
            [params setObject:userID forKey:@"UserId"];
            [params setObject:eventDate forKey:@"Date"];
            [params setObject:[self.txtEventName text] forKey:@"Title"];
            [params setObject:[self.txtDecription text] forKey:@"Description"];
            [params setObject:regionId forKey:@"RegionId"];
            [params setObject:branchId forKey:@"BranchId"];
            [params setObject:positionId forKey:@"RoleId"];
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,ADD_EVENT];
            [self changeEventDateWithWebservices:strURL withParameters:params];
        }
    }
    else {
        
        if ([[self.txtEventName text] length] == 0 || [[self.txtDate text] length] == 0 || [[self.txtDecription text] length] == 0) {
            
            [self.view makeToast:@"Please fill up all the fields"];
        }
        else  {
            
            NSString *userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetails"] objectForKey:@"Userid"];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFromatter = [[NSDateFormatter alloc]init];
            [dateFromatter setDateFormat:@"yyyy-MM-dd"];
            NSString *eventDate = [dateFromatter stringFromDate:date];
            [params setObject:[_eventDict objectForKey:@"Id"] forKey:@"Id"];
            [params setObject:userID forKey:@"UserId"];
            [params setObject:[self.txtDate text] forKey:@"Date"];
            [params setObject:[self.txtEventName text] forKey:@"Title"];
            [params setObject:[self.txtDecription text] forKey:@"Description"];
            [params setObject:regionId forKey:@"RegionId"];
            [params setObject:branchId forKey:@"BranchId"];
            [params setObject:positionId forKey:@"RoleId"];
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,UPDATE_EVENT];
            [self changeEventDateWithWebservices:strURL withParameters:params];
        }
    }
    
}

#pragma mark - Consume Webservice



-(void)changeEventDateWithWebservices:(NSString *)strURL withParameters:(NSDictionary *)params {
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /*
     {
     "Name":"Xitij Patel",
     "Phone":9978923080,
     "EmailId":"dddddd@live.com",
     "UserId":699
     }
     */
    
    
    NSLog(@"---->>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSLog(@">> %@",strURL);
    
    [manager POST:strURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        
        [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([_delegate respondsToSelector:@selector(backFromAddEvent)]) {
            
            [_delegate backFromAddEvent];
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
                
                for (NSDictionary *dict in regionArr) {
                    
                    if ([regionId isEqualToString:[dict objectForKey:@"Region"]]) {
                        
                        strRegion = [dict objectForKey:@"RegionId"];
                    }
                }
                [self.txtRegion setText:strRegion];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self fetchDataFromWebServices:[NSString stringWithFormat:@"%@%@regionid=0",BASE_URL,FETCH_BRANCHES] for:@"branch"];
                    
                });
            }
            else if ([selection isEqualToString:@"branch"]) {
                
                branchArr = [[dictionary objectForKey:@"data"] objectForKey:@"Branches"];
                if (branchId != nil) {
                    
                    NSArray *idArr = [branchId componentsSeparatedByString:@","];
                    strBranch = [[NSString alloc]init];
                    for (NSString *strID in idArr) {
                        for (NSDictionary *dict in branchArr) {
                            
                            if ([strID isEqualToString:[dict objectForKey:@"BranchId"]]) {
                                
                                
                                strBranch = [strBranch stringByAppendingString:@","];
                                strBranch =  [strBranch stringByAppendingString:[dict objectForKey:@"BranchName"]];
                                
                            }
                        }
                        
                    }
                    strBranch = [strBranch substringFromIndex:1];
                    [self.txtBranch setText:strBranch];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self fetchDataFromWebServices:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_POSITION] for:@"position"];
                });
            }
            else if ([selection isEqualToString:@"position"]) {
                
                positionArr = [[dictionary objectForKey:@"data"] objectForKey:@"Position"];
                
                if (positionId != nil) {
                    
                    NSArray *idArr = [positionId componentsSeparatedByString:@","];
                    strPosition = [[NSString alloc]init];
                    for (NSString *strID in idArr) {
                        for (NSDictionary *dict in positionArr) {
                            
                            if ([strID isEqualToString:[dict objectForKey:@"PositionId"]]) {
                                
                                
                                strPosition = [strPosition stringByAppendingString:@","];
                                strPosition =  [strPosition stringByAppendingString:[dict objectForKey:@"PositionName"]];
                                
                            }
                        }
                        
                    }
                    strPosition = [strPosition substringFromIndex:1];
                    [self.txtPosition setText:strPosition];
                }
                
                [self hideHud];
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

#pragma mark - UIViewcontroller Custom Delegate methods

-(void)backFromSelectionviewControllerForType:(NSString *)selectiontype withString:(NSString *)selection withId:(NSString *)selectionId {
    
    if ([selectiontype isEqualToString:@"region"]) {
        
        regionId = [NSString stringWithString:selectionId];
        strRegion = [NSString stringWithString:selection];
        [self.txtRegion setText:strRegion];
        
        branchId = nil;
        strBranch = nil;
        [self.txtBranch setText:@""];
    }
    else if ([selectiontype isEqualToString:@"branch"]) {
        
        branchId = [NSString stringWithString:selectionId];
        strBranch = [NSString stringWithString:selection];
        [self.txtBranch setText:strBranch];
    }
    else if ([selectiontype isEqualToString:@"position"]) {
        
        positionId = [NSString stringWithString:selectionId];
        strPosition = [NSString stringWithString:selection];
        [self.txtPosition setText:strPosition];
    }
    
    
}

- (IBAction)btnDelete:(id)sender {
    
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Sales Tracker" message:@"Are you sure want to delete this event?" delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alerView setTag:2];
    [alerView show];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView.tag == 2) {
        
        if (buttonIndex == 1) {
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[self.eventDict objectForKey:@"Id"] forKey:@"Id"];
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,DELETE_EVENT];
            
            [self changeEventDateWithWebservices:strURL withParameters:params];
        }
    }
}

@end
