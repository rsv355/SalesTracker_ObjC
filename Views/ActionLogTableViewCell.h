//
//  ActionLogTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionLogTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblActionLogName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdatedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblActionLogUserName;

@property (weak, nonatomic) IBOutlet UIButton *btnRemarks;


@property (weak, nonatomic) IBOutlet UILabel *lblDetailTitle;


// Fetch Remark

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarkDate;

@end
