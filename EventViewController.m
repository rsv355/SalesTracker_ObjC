//
//  EventViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "EventViewController.h"
#import "EventTableViewCell.h"
#import "UIButton+tintImage.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "AddEventViewController.h"


@interface EventViewController () <BackFromAddEventViewControllerDelegate>
{
    EventTableViewCell *cell;
    MBProgressHUD *hud;
    NSArray *eventArr;
    NSDateFormatter *dateFormatter;
}
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btnAddEvent setImageTintColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setShadowFor:self.btnAddEvent];
    self.btnAddEvent.layer.cornerRadius = 30.0f;
    
    dateFormatter = [[NSDateFormatter alloc]init];
    
    [self fetchEventListFromWebServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [eventArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ([[eventArr objectAtIndex:indexPath.row] objectForKey:@"Title"] != [NSNull null]) {
        
        [cell.lblEventName setText:[[eventArr objectAtIndex:indexPath.row] objectForKey:@"Title"]];
    }
    if ([[eventArr objectAtIndex:indexPath.row] objectForKey:@"Description"] != [NSNull null]) {
        
        [cell.lblEventDescription setText:[[eventArr objectAtIndex:indexPath.row] objectForKey:@"Description"]];
    }
    if ([[eventArr objectAtIndex:indexPath.row] objectForKey:@"EventsAuthor"] != [NSNull null]) {
        
        [cell.lblEventCreator setText:[NSString stringWithFormat:@"Event Creator : %@",[[eventArr objectAtIndex:indexPath.row] objectForKey:@"EventsAuthor"]]];
    }
    if ([[eventArr objectAtIndex:indexPath.row] objectForKey:@"EventDate"] != [NSNull null]) {
    
        
        NSString *getDate = [[eventArr objectAtIndex:indexPath.row] objectForKey:@"EventDate"];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:getDate];
        
        [dateFormatter setDateFormat:@"MMM"];
        cell.lblEventMonth.text = [dateFormatter stringFromDate:date];
        
        [dateFormatter setDateFormat:@"dd"];
        cell.lblEventDate.text = [dateFormatter stringFromDate:date];

    }

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddEventViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_EVENT"];
    viewController.delegate  = (id)self;
    viewController.eventDict = [eventArr objectAtIndex:indexPath.row];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddEvent:(id)sender {
    
    AddEventViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_EVENT"];
    viewController.delegate = (id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Consume Webservice

-(void) fetchEventListFromWebServices {

    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_EVENTS]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_EVENTS] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            
            if ([dictionary objectForKey:@"Events"] != [NSNull null]) {
                
                    eventArr = [dictionary objectForKey:@"Events"] ;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView reloadData];
                    });
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

-(void)backFromAddEvent {
    [self viewDidLoad];
}

@end
