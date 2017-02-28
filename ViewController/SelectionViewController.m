//
//  SelectionViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 21/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelectionTableViewCell.h"

@interface SelectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    SelectionTableViewCell *cell;
    NSMutableArray *selectedArr,*selectedIdArr,*selectAllArray;
    NSString *strName, *strID;
    NSMutableDictionary * selectAllDict;
}
@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewHeightConstraints.constant = 17*53;
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    
    selectAllDict=[[NSMutableDictionary alloc]init];
    [selectAllDict setObject:@"0" forKey:@"Region"];
    [selectAllDict setObject:@"Select All" forKey:@"RegionId"];
    
    
    selectedArr = [[NSMutableArray alloc] init];
    selectedIdArr = [[NSMutableArray alloc] init];
    selectAllArray = [[NSMutableArray alloc] init];
    
    
    NSLog(@"data array %@",_dataArr);
    
    if ([_strSelection isEqualToString:@"region"]) {
        
        [selectAllArray addObject:selectAllDict];
        
        for (int i=0; i<_dataArr.count; i++) {
            [selectAllArray addObject:[_dataArr objectAtIndex:i]];
        }
        
        _dataArr=selectAllArray;
        NSLog(@"data array %@",_dataArr);
        
        
        
        self.lblTitle.text = @"Select Region";
        [self.tableView setAllowsSelection:YES];
        [self.tableView setAllowsMultipleSelection:NO];
    }
    else if ([_strSelection isEqualToString:@"branch"]) {
        
        self.lblTitle.text = @"Select Branch";
        [self.tableView setAllowsMultipleSelection:YES];
    }
    else if ([_strSelection isEqualToString:@"position"]) {
        
        self.lblTitle.text = @"Select Position";
        [self.tableView setAllowsMultipleSelection:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(SelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.btnSelection.layer.borderWidth = 1.0f;
    cell.btnSelection.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    if ([_strSelection isEqualToString:@"region"]) {
        for (NSString *string in [_strSelectedId componentsSeparatedByString:@","]) {
            
            if ([string isEqualToString:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Region"]]) {
                [selectedIdArr addObject:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Region"]];
                
                [selectedArr addObject:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"RegionId"]];
                [cell setSelected:YES];
                
                [cell.btnSelection setImage:[UIImage imageNamed:@"ic_radio.png"] forState:UIControlStateNormal];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
        
        cell.btnSelection.layer.cornerRadius = 9.0f;
        [cell.btnSelectionTitle setText:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"RegionId"]];
    }
    else {
        
        cell.btnSelection.layer.cornerRadius = 2.0f;
        
        if ([_strSelection isEqualToString:@"position"]) {
            
            for (NSString *string in [_strSelectedId componentsSeparatedByString:@","]) {
                
                if ([string isEqualToString:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionId"]]) {
                    [selectedIdArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionId"]];
                    
                    [selectedArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionName"]];
                    [cell setSelected:YES];
                    
                    [cell.btnSelection setImage:[UIImage imageNamed:@"ic_checked.png"] forState:UIControlStateNormal];
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
            }
            [cell.btnSelectionTitle setText:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionName"]];
        }
        else {
            for (NSString *string in [_strSelectedId componentsSeparatedByString:@","]) {
                
                if ([string isEqualToString:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchId"]]) {
                    [selectedIdArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchId"]];
                    
                    [selectedArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"]];
                    [cell setSelected:YES];
                    
                    [cell.btnSelection setImage:[UIImage imageNamed:@"ic_checked.png"] forState:UIControlStateNormal];
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
            }
            
            [cell.btnSelectionTitle setText:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"]];
        }
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([_strSelection isEqualToString:@"region"]) {
        
        
        [selectedArr addObject:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"RegionId"]];
        [selectedIdArr addObject:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Region"]];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.btnSelection setImage:[UIImage imageNamed:@"ic_radio.png"] forState:UIControlStateNormal];
        
        
        
        
    }
    else if ([_strSelection isEqualToString:@"branch"]) {
        
        [selectedArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"]];
        [selectedIdArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchId"]];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.btnSelection setImage:[UIImage imageNamed:@"ic_checked.png"] forState:UIControlStateNormal];
    }
    else if ([_strSelection isEqualToString:@"position"]) {
        
        [selectedArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionName"]];
        [selectedIdArr addObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionId"]];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.btnSelection setImage:[UIImage imageNamed:@"ic_checked.png"] forState:UIControlStateNormal];
    }
    
    NSLog(@"SELECTED STRING ----->> %@",selectedArr);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_strSelection isEqualToString:@"region"]) {
        
        
        
        [selectedArr removeAllObjects];
        [selectedIdArr removeAllObjects];
        [selectedArr removeObject:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"RegionId"]];
        [selectedIdArr removeObject:[[_dataArr objectAtIndex:indexPath.row] objectForKey:@"Region"]];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [cell.btnSelection setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        
    }
    
    else if ([_strSelection isEqualToString:@"branch"]) {
        
        [selectedArr removeObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"]];
        [selectedIdArr removeObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchId"]];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.btnSelection setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    else if ([_strSelection isEqualToString:@"position"]) {
        
        [selectedArr removeObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionName"]];
        [selectedIdArr removeObject:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"PositionId"]];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.btnSelection setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    
    NSLog(@"DE-SELECTED STRING ----->> %@",selectedArr);
}

- (IBAction)btnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnOK:(id)sender {
    
    NSString *selName = [[NSString alloc] init];
    NSString *selId = [[NSString alloc] init];
    
    for (int i = 0; i<[selectedArr count]; i++) {
        
        if (i != 0) {
            selName = [selName stringByAppendingString:@","];
            selId = [selId stringByAppendingString:@","];
        }
        
        selName = [selName stringByAppendingString:[selectedArr objectAtIndex:i]];
        
        selId = [selId stringByAppendingString:[selectedIdArr objectAtIndex:i]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([_delegate respondsToSelector:@selector(backFromSelectionviewControllerForType:withString:withId:)]) {
        
        [_delegate backFromSelectionviewControllerForType:self.strSelection withString:selName withId:selId];
        
    }
}
@end
