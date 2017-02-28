//
//  DayViewCalendarViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DayViewControllerDelegate <NSObject>

@required
-(void)updateCalenderView;

@end

@interface DayViewCalendarViewController : UIViewController

@property (strong, nonatomic) id<DayViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
- (IBAction)btnNext:(id)sender;
- (IBAction)btnPrevious:(id)sender;

@property (strong, nonatomic) NSString *strSelectedDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnMapping:(id)sender;
- (IBAction)btnDeleteAll:(id)sender;
- (IBAction)btnRecruitment:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRemark;
- (IBAction)btnRemark:(id)sender;
@end
