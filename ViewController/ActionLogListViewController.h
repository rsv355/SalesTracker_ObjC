//
//  ActionLogListViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionLogListViewController : UIViewController

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnAddActionLog;
- (IBAction)btnAddActionLog:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewPending;
@property (weak, nonatomic) IBOutlet UIView *viewRejected;
@property (weak, nonatomic) IBOutlet UIView *viewCompleted;
@property (weak, nonatomic) IBOutlet UIView *viewProcessing;
@end
