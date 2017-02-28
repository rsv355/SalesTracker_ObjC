//
//  AddEmployeeViewController.h
//  SalesTracker
//
//  Created by Masum Chauhan on 17/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addEmployeeViewController <NSObject>

-(void)updateNewEmployeeInList;


@end

@interface AddEmployeeViewController : UIViewController

@property (strong,nonatomic) id<addEmployeeViewController> delegate;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SelectRegionHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *SelectRegionView;


@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property(nonatomic, readwrite)NSInteger strAddEmployeeMode;
@property (strong, nonatomic) IBOutlet UILabel *lbl_EmployeeProfile;

@property (nonatomic, strong)NSDictionary *employeeInfoDict;


@property (strong, nonatomic) IBOutlet UITextField *txt_EmployeeId;
@property (strong, nonatomic) IBOutlet UITextField *txt_EmployeeName;
@property (strong, nonatomic) IBOutlet UITextField *txt_SelectPosition;
@property (strong, nonatomic) IBOutlet UITextField *txt_PhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txt_EmailAdress;
@property (weak, nonatomic) IBOutlet UITextField *txtSelectRegion;




- (IBAction)Btn_SelectPosition:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Btn_SelectPosition;

@property (weak, nonatomic) IBOutlet UIButton *BtnSelectRegion;
- (IBAction)BtnSelectRegion:(id)sender;


- (IBAction)Btn_Back:(id)sender;

- (IBAction)Btn_Delete:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Delete;

@property (weak, nonatomic) IBOutlet UIButton *Btn_Edit;

- (IBAction)Btn_Edit:(id)sender;

@end
