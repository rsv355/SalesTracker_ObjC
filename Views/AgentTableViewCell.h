//
//  AgentTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnChecked;
@property (weak, nonatomic) IBOutlet UILabel *lblAgentName;
@property (weak, nonatomic) IBOutlet UILabel *lblAgentLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMail;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@end
