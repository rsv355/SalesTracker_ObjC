//
//  ActionLogDetailsViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemarkDelegate <NSObject>

@required

-(void)updateActionLogRemark;

@end


@interface ActionLogDetailsViewController : UIViewController

@property (strong,nonatomic) id<RemarkDelegate> delegate;

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraints;
- (IBAction)btnAddRemark:(id)sender;

@property(strong, nonatomic) NSDictionary *actionLogDict;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

- (IBAction)btnReopenAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIButton *btnApprove;


@end
