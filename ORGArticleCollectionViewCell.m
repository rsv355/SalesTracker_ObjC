//
//  ORGArticleCollectionViewCell.m
//  HorizontalCollectionViews
//
//  Created by James Clark on 4/23/13.
//  Copyright (c) 2013 OrgSync, LLC. All rights reserved.
//

#import "ORGArticleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ORGArticleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.containerView.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0] CGColor];
    self.containerView.layer.borderWidth = 1.0;
//    self.articleImage.layer.borderColor = [UIColor darkGrayColor].CGColor
//    ;
//
//    self.articleImage.layer.borderWidth = 2.0f;

}


@end
