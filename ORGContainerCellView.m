//
//  ORGContainerCellView.m
//  HorizontalCollectionViews
//
//  Created by James Clark on 4/22/13.
//  Copyright (c) 2013 OrgSync, LLC. All rights reserved.
//

#import "ORGContainerCellView.h"
#import "ORGArticleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+tintImage.h"

@interface ORGContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIColor *selectedColor, *deselectedColor, *selectedTintColor, *deselectedTintColor;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;

@end


@implementation ORGContainerCellView

- (void)awakeFromNib {
    
    deselectedColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    selectedColor = [UIColor colorWithRed:187.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    
    selectedTintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    deselectedTintColor = [UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(191.0, 70.0);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"ORGArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ORGArticleCollectionViewCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    self.timeArr = [[NSArray alloc] initWithObjects:@"All \nday", @"08:00 AM", @"08:30 AM",@"09:00 AM", @"09:30 AM",@"10:00 AM", @"10:30 AM",@"11:00 AM", @"11:30 AM",@"12:00 PM", @"12:30 PM",@"01:00 PM", @"01:30 PM",@"02:00 PM", @"02:30 PM",@"03:00 PM", @"03:30 PM",@"04:00 PM", @"04:30 PM",@"05:00 PM", @"05:30 PM",@"06:00 PM", @"06:30 PM",@"07:00 PM", @"07:30 PM",@"08:00 PM",  nil];

    [super awakeFromNib];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData :(NSInteger)objIndex{
    
    self.lblTimeHeader.text = [self.timeArr objectAtIndex:objIndex];
    _collectionData = collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ORGArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ORGArticleCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-mm-yyyy"];
    
    if ([self checkPastDate]) {
        
        cell.btnB.hidden = YES;
        cell.btnO.hidden = YES;
        cell.btnX.hidden = YES;
    }
    else {
        cell.btnB.hidden = NO;
        cell.btnO.hidden = NO;
        cell.btnX.hidden = NO;
    }
    
    cell.backgroundColor  = [UIColor whiteColor];

    cell.articleTitle.text = [cellData objectForKey:@"AgentName"];

    cell.lblStartTime.text = [self convertTimeinto12Hours:[cellData objectForKey:@"StartTime"]];
    
    cell.lblEndTime.text = [self convertTimeinto12Hours:[cellData objectForKey:@"EndTime"]];
    
    if ([[cellData objectForKey:@"Status"] isEqualToString:@"B"]) {
        
        [cell.btnB setBackgroundColor:selectedColor];
        [cell.btnO setBackgroundColor:deselectedColor];
        [cell.btnX setBackgroundColor:deselectedColor];
        
        [cell.btnO setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        [cell.btnX setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        
    }
    else if ([[cellData objectForKey:@"Status"] isEqualToString:@"O"]) {
        
        [cell.btnB setBackgroundColor:deselectedColor];
        [cell.btnO setBackgroundColor:selectedColor];
        [cell.btnX setBackgroundColor:deselectedColor];
        
        [cell.btnO setImageTintColor:selectedTintColor forState:UIControlStateNormal];
        [cell.btnX setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        
    }
    else if ([[cellData objectForKey:@"Status"] isEqualToString:@"X"]) {
        
        [cell.btnB setBackgroundColor:deselectedColor];
        [cell.btnO setBackgroundColor:deselectedColor];
        [cell.btnX setBackgroundColor:selectedColor];
        
        [cell.btnO setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        [cell.btnX setImageTintColor:selectedTintColor forState:UIControlStateNormal];
        
    }
    else {
        [cell.btnB setBackgroundColor:deselectedColor];
        [cell.btnO setBackgroundColor:deselectedColor];
        [cell.btnX setBackgroundColor:deselectedColor];
        
        [cell.btnO setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
        [cell.btnX setImageTintColor:deselectedTintColor forState:UIControlStateNormal];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
}

-(NSString *)convertTimeinto12Hours:(NSString *)strTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
  
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    [dateFormatter setDateFormat:@"HH:mm a"];
  
    return [dateFormatter stringFromDate:date];

}

-(BOOL)checkPastDate {
    
    BOOL isTrue = NO;

    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];

    NSDate* enteredDate = [df dateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"strDate"]];
    NSDate * today = [NSDate date];
    
    NSComparisonResult result = [today compare:enteredDate];
    
    switch (result)
    {
        case NSOrderedAscending:
            NSLog(@"Future Date");
            isTrue = YES;
            break;
        case NSOrderedDescending:
            NSLog(@"Earlier Date");
            break;
        case NSOrderedSame:
            NSLog(@"Today/Null Date Passed"); //Not sure why This is case when null/wrong date is passed
            break;
    }
    return isTrue;
}

@end
