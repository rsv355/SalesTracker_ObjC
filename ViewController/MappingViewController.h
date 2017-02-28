//
//  MappingViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 17/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MappingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnUpdate:(id)sender;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablleViewHeightConstraints;

- (IBAction)btnAddMore:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMore;
@end
