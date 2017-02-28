//
//  SelectFilterViewController.h
//  SalesTracker
//
//  Created by Webmyne on 22/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectFilterViewControllerDelegate <NSObject>

@required
-(void)backFromSelectFilterviewControllerForType:(NSInteger)filtertype withIndexpath:(NSInteger)selection;

@end

@interface SelectFilterViewController : UIViewController

@property (strong,nonatomic) id<SelectFilterViewControllerDelegate> delegate;
- (IBAction)btnClose:(id)sender;

- (IBAction)btnOK:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *strSelection;

@property (strong, nonatomic) NSArray *dataArr;

@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, assign)NSInteger filterIndex;

@end
