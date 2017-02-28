//
//  EventViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEvent;
- (IBAction)btnAddEvent:(id)sender;
@end
