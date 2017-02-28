//
//  RemarkViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 26/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemarkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnBack:(id)sender;

@property(strong, nonatomic)NSString *actionID;
@end
