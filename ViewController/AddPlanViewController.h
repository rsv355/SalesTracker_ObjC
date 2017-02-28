//
//  AddPlanViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 17/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPlanViewControllerDelegate <NSObject>

@required

-(void)backFromAddPlanViewController;

@end


@interface AddPlanViewController : UIViewController

@property (strong,nonatomic) id<AddPlanViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnAddPlan:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@end
