//
//  AddActionLogViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPFloatingPlaceholderTextField.h"
#import "SCRFTPRequest.h"
#import "AddAgentTableViewCell.h"

@protocol ActionLogViewControllerDelegate <NSObject>

@required

-(void)updateActionLogInList;

@end

@interface AddActionLogViewController : UIViewController <UIImagePickerControllerDelegate,SCRFTPRequestDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) id<ActionLogViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnAddBottomConstraint;

- (IBAction)btnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeightConstraint;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtAgentName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtDepatmentName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtInChargeName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtPriorityName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtFileName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtDescription;

- (IBAction)btnSelection:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnAddActionLog;
- (IBAction)btnAddActionLog:(id)sender;

- (IBAction)btnUploadFile:(id)sender;
@end
