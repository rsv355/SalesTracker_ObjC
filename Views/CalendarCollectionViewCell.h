//
//  CalendarCollectionViewCell.h
//  SalesTracker
//
//  Created by Masum Chauhan on 14/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *eventView;

// For DayView
@property (weak, nonatomic) IBOutlet UILabel *lblDayTime;
@end
