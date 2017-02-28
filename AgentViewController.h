//
//  AgentViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)btnSearch:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBack:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *btnAddAgent;

- (IBAction)btnAddAgent:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnSearchWidthContraint;

@property (weak, nonatomic) IBOutlet UITextField *txtSearchAgent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraints;
@end
