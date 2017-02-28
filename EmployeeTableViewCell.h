//
//  EmployeeTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 17/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *Btn_checked;
@property (strong, nonatomic) IBOutlet UILabel *lbl_EmployeeName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_EmployeeLocation;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Call;
@property (strong, nonatomic) IBOutlet UIButton *Btn_SendMail;
@end
