//
//  DashboardViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 19/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardCollectionViewCell.h"

@interface DashboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)btnLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@end
