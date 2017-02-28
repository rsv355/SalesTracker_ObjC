//
//  EmployeeViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 17/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *Title_View;

@property (strong, nonatomic) IBOutlet UITableView *EmployeeTableView;

- (IBAction)Button_back:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Btn_back;

- (IBAction)btn_addEmployee:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_addEmployee;

@property (strong, nonatomic) IBOutlet UIButton *btn_Delete;
- (IBAction)btn_Delete:(id)sender;

- (IBAction)btnSelectRegion:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectRegion;

@property (weak, nonatomic) IBOutlet UIView *RegionDropDownView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RegionDropdownHeightConstrint;




@end
