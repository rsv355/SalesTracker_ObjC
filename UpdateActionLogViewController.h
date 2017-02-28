//
//  UpdateActionLogViewController.h
//  SalesTracker
//
//  Created by webmyne on 09/01/17.
//  Copyright © 2017 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRFTPRequest.h"



@interface UpdateActionLogViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,SCRFTPRequestDelegate>

- (IBAction)btnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtAgentName;
@property (weak, nonatomic) IBOutlet UITextField *txtDepatmentName;
@property (weak, nonatomic) IBOutlet UITextField *txtInChargeName;
@property (weak, nonatomic) IBOutlet UITextField *txtPriorityName;
@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtFileName;


- (IBAction)btnUploadFile:(id)sender;


- (IBAction)btnSelection:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdateActionLog;
- (IBAction)btnUpdateActionLog:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnStatus;

@property (strong, nonatomic) NSDictionary *actionDict;
@end
