//
//  SelectFilterViewController.m
//  SalesTracker
//
//  Created by Webmyne on 22/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "SelectFilterViewController.h"
#import "SelectionTableViewCell.h"



@interface SelectFilterViewController ()
{
    SelectionTableViewCell *cell;
}
@end

@implementation SelectFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"self---%ld--->> %ld",_selectedIndex, _filterIndex);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnOK:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([_delegate respondsToSelector:@selector(backFromSelectFilterviewControllerForType:withIndexpath:)]) {
        
        [_delegate backFromSelectFilterviewControllerForType:_filterIndex withIndexpath:self.selectedIndex];
        
    }
}

-(void)btnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(SelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.btnSelectFilter.layer.borderWidth = 1.0f;
    cell.btnSelectFilter.layer.cornerRadius = 9.0f;
    cell.btnSelectFilter.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    if ([_strSelection isEqualToString:@"0"]) {
       
        [cell.lblFilterTitle setText:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"BranchName"]];
    }
    else {
        
        [cell.lblFilterTitle setText:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    }
    if (indexPath.row == self.selectedIndex ) {
        [cell.btnSelectFilter setImage:[UIImage imageNamed:@"ic_radio.png"] forState:UIControlStateNormal];
    }
    else {
        
        [cell.btnSelectFilter setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
}
@end
