//
//  SelectRegionViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 02/02/17.
//  Copyright © 2017 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "SelectRegionViewController.h"
#import "SelectRegionTableViewCell.h"
#import "UIView+Toast.h"

@interface SelectRegionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *RegionId;
    NSString *RegionName;
}

@end

@implementation SelectRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"data array is>>>>%@",_dataArr);
    
    _selectedIndex=0;
    
    RegionId=[[_dataArr objectAtIndex:0] valueForKey:@"RegionId"];
    RegionName=[[_dataArr objectAtIndex:0] valueForKey:@"Region"];

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectRegionTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.btnSelectRegion.layer.borderWidth = 1.0f;
    cell.btnSelectRegion.layer.cornerRadius = 9.0f;
    cell.btnSelectRegion.layer.borderColor = [UIColor darkGrayColor].CGColor;

    
   // cell.lblRegionTitle.text=[NSString stringWithFormat:@"%d",indexPath.row];
    cell.lblRegionTitle.text=[[_dataArr objectAtIndex:indexPath.row] valueForKey:@"Region"];
    
    
    if (indexPath.row == self.selectedIndex ) {
        [cell.btnSelectRegion setImage:[UIImage imageNamed:@"ic_radio.png"] forState:UIControlStateNormal];
    }
    else {
        
        [cell.btnSelectRegion setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegionId=[[_dataArr objectAtIndex:indexPath.row] valueForKey:@"RegionId"];
    RegionName=[[_dataArr objectAtIndex:indexPath.row] valueForKey:@"Region"];

    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];

    
    NSLog(@"%@",RegionId);
    NSLog(@"%@",RegionName);

    
}

- (IBAction)btnOK:(id)sender
{
   
  //  if (RegionId.length!=0 || RegionId!=nil || RegionName.length!=0 || RegionName!=nil)
  //  {
        [_delegate backFromSelectRegionviewControllerForType:RegionId :RegionName];
        
        [self dismissViewControllerAnimated:YES completion:nil];

  //  }else{
    
   //     [self.view makeToast:@"Please Select The Region."];

  //  }
    
}

- (IBAction)btnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
