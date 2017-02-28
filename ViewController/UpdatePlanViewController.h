//
//  UpdatePlanViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateViewControllerDelegate <NSObject>

@required

-(void)updateSelectedPlan:(NSMutableDictionary *)planDict ForDay:(NSString *)strPlanDate withAction:(NSString *)actionType;

@end


@interface UpdatePlanViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewStatusHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDialogueHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewStatus;
@property (strong,nonatomic) id<UpdateViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerVerticalViewConstraint;

- (IBAction)btnDelete:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnupdate;

@property (weak, nonatomic) IBOutlet UITextField *txtFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (strong, nonatomic) IBOutlet UITextField *txtRemark;

@property (strong, nonatomic) NSDictionary *planDict;

@property (strong, nonatomic) IBOutlet UIButton *btnB;
@property (strong, nonatomic) IBOutlet UIButton *btnO;
@property (strong, nonatomic) IBOutlet UIButton *btnX;
- (IBAction)btnStatus:(id)sender;
@end
