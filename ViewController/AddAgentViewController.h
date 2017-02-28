//
//  AddAgentViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAgentViewControllerDelegate <NSObject>

@required

-(void)updateNewAgentInList;

@end


@interface AddAgentViewController : UIViewController 

@property (strong,nonatomic) id<AddAgentViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnEditBottomConstraint;

- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtAgentName;
@property (weak, nonatomic) IBOutlet UITextField *txtTierName;
@property (weak, nonatomic) IBOutlet UITextField *txtBranchName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtKruniaNo;
@property (weak, nonatomic) IBOutlet UITextField *txtAMGNo;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)btnUpdate:(id)sender;

@property(nonatomic, readwrite)NSInteger strAddAgentMode;
@property (nonatomic, strong)NSDictionary *agentInfoDict;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectTier;

- (IBAction)btnSelectTier:(id)sender;
- (IBAction)btnSelectBranch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectBranch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)btnDelete:(id)sender;

@end
