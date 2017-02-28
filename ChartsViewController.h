//
//  ChartsViewController.h
//  SalesTracker
//
//  Created by Webmyne on 06/12/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)btnBack:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *viewRegion;
@property (weak, nonatomic) IBOutlet UIView *viewBranch;
@property (weak, nonatomic) IBOutlet UIView *viewYear;
@property (weak, nonatomic) IBOutlet UIView *viewMonth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSelectTimeHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSelectLocationHeightConstraints;

- (IBAction)btnSelection:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnYear;
@property (weak, nonatomic) IBOutlet UIButton *btnMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnRegion;
@property (weak, nonatomic) IBOutlet UIButton *btnBranch;

@property (weak, nonatomic) IBOutlet UIButton *btnShowChart;

@end
