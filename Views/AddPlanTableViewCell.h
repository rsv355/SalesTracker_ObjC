//
//  AddPlanTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 17/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddPlanTableViewCell : UITableViewCell


//ADD PLAN
@property (strong, nonatomic) IBOutlet UILabel *lblAgentName;
@property (strong, nonatomic) IBOutlet UILabel *lblAgentTier;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPlan;
@property (strong, nonatomic) IBOutlet UILabel *lblActualPlan;
@property (strong, nonatomic) IBOutlet UILabel *lblAditionalPlan;

//ADD MAPPING
@property (strong, nonatomic) IBOutlet UITextField *txtMapping;
@property (weak, nonatomic) IBOutlet UITextField *txtMappingVisit;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteMapping;


// ADD RECRUITMENT
@property (strong, nonatomic) IBOutlet UITextField *txtRecruitmentAgentName;
@property (strong, nonatomic) IBOutlet UILabel *txtRecruitmentLevel;
@property (strong, nonatomic) IBOutlet UIButton *btnRecruitmentLEvel;
@property (strong, nonatomic) IBOutlet UITextField *txtRecruitmentRemark;

@property (strong, nonatomic) IBOutlet UIButton *btnDeleteRecruitment;

@end
