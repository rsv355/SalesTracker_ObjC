//
//  AddEventViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackFromAddEventViewControllerDelegate <NSObject>

@required
-(void)backFromAddEvent;

@end
@interface AddEventViewController : UIViewController

@property (strong,nonatomic) id<BackFromAddEventViewControllerDelegate> delegate;

@property (strong, nonatomic) NSDictionary *eventDict;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;

@property (strong, nonatomic) IBOutlet UITextField *txtEventName;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UITextField *txtRegion;
@property (strong, nonatomic) IBOutlet UITextField *txtBranch;
@property (strong, nonatomic) IBOutlet UITextField *txtPosition;
@property (strong, nonatomic) IBOutlet UITextField *txtDecription;


@property (strong, nonatomic) IBOutlet UIButton *btnRegion;
@property (strong, nonatomic) IBOutlet UIButton *btnBranch;
@property (strong, nonatomic) IBOutlet UIButton *btnPosition;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;

@property (strong, nonatomic) IBOutlet UIButton *btnAddEvent;
- (IBAction)btnAddEvent:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)btnDelete:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewRegionHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBranchHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewPositionHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceToScrollConstraints;
@end
