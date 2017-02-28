//
//  MonthViewCalendarViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarCollectionViewCell.h"

@protocol MonthViewControllerDelegate <NSObject>

@required

-(void)updateCalendar:(NSInteger )selction;

@end

@interface MonthViewCalendarViewController : UIViewController

@property (strong,nonatomic) id<MonthViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIView *viewBranch;
@property (weak, nonatomic) IBOutlet UIView *viewMarketer;
@property (weak, nonatomic) IBOutlet UIView *viewHOS;
@property (weak, nonatomic) IBOutlet UIButton *btnBranch;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectMarketer;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectHOS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *branchViewHeightContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnUserHeightConstraints;
@end
