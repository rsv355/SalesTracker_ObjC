//
//  SelectionTableViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *btnSelectionTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSelection;

@property (weak, nonatomic) IBOutlet UILabel *lblFilterTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectFilter;

@end
