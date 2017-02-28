//
//  CommonWebViewViewController.m
//  SalesTracker
//
//  Created by Webmyne on 29/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "CommonWebViewViewController.h"
#import "App_Constant.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface CommonWebViewViewController ()<UIWebViewDelegate>

@end

@implementation CommonWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lblHeader.text = self.strHeader;
    
    if ([self.strWebviewType isEqualToString:WEBVIEW_TYPE_URL]) {
       
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"-------------->>%@",_strURL);
        NSURL *url = [NSURL URLWithString:self.strURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    else {
       
        NSLog(@"---->>%@",_strURL);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath =  [paths objectAtIndex:0];
        NSString *fileLoc = [NSString stringWithFormat:@"%@/%@",basePath,self.strURL];
        NSLog(@"FILE LOC ---- >>%d",[[NSFileManager defaultManager] fileExistsAtPath:fileLoc]);
        
        NSURL *url = [NSURL fileURLWithPath:fileLoc];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.view makeToast:@"There is an error"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
