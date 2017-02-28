//
//  SelectRegionViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 02/02/17.
//  Copyright © 2017 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectRegionViewControllerDelegate <NSObject>

@required
-(void)backFromSelectRegionviewControllerForType:(NSString*)Regionid :(NSString *)regionName;

@end

@interface SelectRegionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,atomic)NSMutableArray * dataArr;
@property (nonatomic, assign)NSInteger selectedIndex;


@property (strong,nonatomic) id<SelectRegionViewControllerDelegate> delegate;

- (IBAction)btnClose:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@end
