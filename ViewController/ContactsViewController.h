//
//  ContactsViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentControlHeightConstraints;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraints;
- (IBAction)btnSearch:(id)sender;
@end
