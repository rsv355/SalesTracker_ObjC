//
//  RecruitmentViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecruitmentViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnUpdate:(id)sender;
- (IBAction)btnClose:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablleViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMore;
- (IBAction)btnAddMore:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;


@end
