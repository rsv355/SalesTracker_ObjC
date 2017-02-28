//
//  SalesVisitPlanViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateCalendarViewDelegate <NSObject>

@required

-(void)updateCalendarView;

@end

@interface SalesVisitPlanViewController : UIViewController

@property (strong, nonatomic) id<UpdateCalendarViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (weak, nonatomic) IBOutlet UIView *viewCalendar;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlClicked:(id)sender;
- (IBAction)btnAddPlan:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnAddPlan;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
