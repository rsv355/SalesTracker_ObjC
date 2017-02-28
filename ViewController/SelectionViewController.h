//
//  SelectionViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionViewControllerDelegate <NSObject>

@required
-(void)backFromSelectionviewControllerForType:(NSString *)selectiontype withString:(NSString *)selection withId:(NSString *)selectionId;

@end

@interface SelectionViewController : UIViewController

@property (strong, nonatomic) id<SelectionViewControllerDelegate> delegate;

- (IBAction)btnClose:(id)sender;

- (IBAction)btnOK:(id)sender;

@property (strong, nonatomic) NSString *strSelection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArr;

@property (strong, nonatomic)NSString *strSelectedId;

@end
