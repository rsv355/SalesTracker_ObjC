//
//  ContactsTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 20/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell

//-------BRANCH

@property (weak, nonatomic) IBOutlet UIButton *btnBranchChecked;
@property (weak, nonatomic) IBOutlet UILabel *lblBranchTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBranchName;

@property (weak, nonatomic) IBOutlet UIButton *btnSendBranchMail;
@property (weak, nonatomic) IBOutlet UIButton *btnBranchCall;

//-------DEPARTMENT

@property (weak, nonatomic) IBOutlet UILabel *lblDepartmentTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnDepartmentCall;
@property (weak, nonatomic) IBOutlet UIButton *btnDepartmentMail;


@end
