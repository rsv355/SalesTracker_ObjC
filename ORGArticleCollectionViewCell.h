//
//  ORGArticleCollectionViewCell.h
//  HorizontalCollectionViews
//
//  Created by James Clark on 4/23/13.
//  Copyright (c) 2013 OrgSync, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORGArticleCollectionViewCell : UICollectionViewCell
@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnO;
@property (weak, nonatomic) IBOutlet UIButton *btnX;
@property (strong, nonatomic) IBOutlet UILabel *lblStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEndTime;
@end
