//
//  EventTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell


//Communication
@property (weak, nonatomic) IBOutlet UILabel *lblCommunicationTitle;
@property (weak, nonatomic) IBOutlet UIButton *btndownloadCommunicationAttachment;


//Event
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblEventCreator;

@property (strong, nonatomic) IBOutlet UILabel *lblEventDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEventMonth;


@end
