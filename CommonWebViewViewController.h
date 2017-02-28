//
//  CommonWebViewViewController.h
//  SalesTracker
//
//  Created by Webmyne on 29/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebViewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)btnBack:(id)sender;

@property (strong, nonatomic) NSString *strURL;
@property (strong, nonatomic) NSString *strHeader;
@property (strong, nonatomic) NSString *strWebviewType;

@end
