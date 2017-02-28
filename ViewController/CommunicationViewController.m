//
//  CommunicationViewController.m
//  SalesTracker
//
//  Created by Masum Chauhan on 20/10/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "CommunicationViewController.h"
#import "EventTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SalesTracker_AppURL.h"
#import "CommonWebViewViewController.h"
#import "App_Constant.h"

#define FILE_SUFFIX @"SalesTracker_"

@interface CommunicationViewController ()
{
    EventTableViewCell *cell;
    MBProgressHUD *hud;
    NSArray *CommunicationArr;
}
@end

@implementation CommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchCommunicationFromWebServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CommunicationArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if ( [[CommunicationArr objectAtIndex:indexPath.row] objectForKey:@"Title"] != [NSNull null]) {
        cell.lblCommunicationTitle.text = [[CommunicationArr objectAtIndex:indexPath.row] objectForKey:@"Title"];

    }
    
    cell.btndownloadCommunicationAttachment.tag = indexPath.row;
    [cell.btndownloadCommunicationAttachment addTarget:(id)self action:@selector(btndownloadCommunicationAttachment:) forControlEvents:UIControlEventTouchDown];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

-(void)btndownloadCommunicationAttachment :(id)sender {
    
    NSString *strAttachment = [[[CommunicationArr objectAtIndex:[sender tag]] objectForKey:@"Attachment"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *strAttachmentName = [FILE_SUFFIX stringByAppendingString:strAttachment];
    
    if ([self fileExistWithName:strAttachmentName]) {
        
        NSLog(@"EXIST ::%@",strAttachmentName);
        [self showInWebview:strAttachmentName withName:[[CommunicationArr objectAtIndex:[sender tag]] objectForKey:@"Title"]];
        //show in webview
    }
    else {
        NSLog(@"DO not EXIST ::");
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@%@",FILE_DOWNLOAD_BASE_URL,COMMUNICATION_DOWNLOAD_URL,strAttachment];
        
        [self downloadFileFromURL:strURL fileName:strAttachmentName];
    }
}

-(BOOL)fileExistWithName:(NSString *)fileName {
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   
    NSString *basePath =  [paths objectAtIndex:0];
//    NSString *fileLoc = [basePath stringByAppendingString:@"/pdf.pdf"];
    
    NSString *fileLocation = [NSString stringWithFormat:@"%@/%@",basePath,fileName];
    NSLog(@"FILE LOC ---- >>%d",[[NSFileManager defaultManager] fileExistsAtPath:fileLocation]);
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileLocation];
    
    return isExist;

}

-(void)downloadFileFromURL:(NSString *)strURL fileName:(NSString *)fileName {
    NSLog(@"DOWNLOAD >> %@",strURL);
    
    [self showHud];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSLog(@"Downloading Started");
//        NSString *urlToDownload = @"http://www.pdf995.com/samples/pdf.pdf";
       
        NSURL  *url = [NSURL URLWithString:strURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !");
                
            
               // [self hideHud];
                //    [self showInWebview:documentsDirectory withName:fileName];
                
            [self.view makeToast:@"File Saved, Click again to View!"];
                
            });
            [self hideHud];
        }
        
    });
}


-(void)showInWebview:(NSString *)url withName:(NSString *)fileName {
    
    CommonWebViewViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"COMMON_WEBVIEW"];
    
    viewController.strHeader = fileName;
    viewController.strURL = url;
    viewController.strWebviewType = WEBVIEW_TYPE_FILEPATH;
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Consume Web services

-(void)fetchCommunicationFromWebServices {
    
    [self showHud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_COMMUNCATION]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,FETCH_COMMUNCATION] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (responsDict != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self parseDataResponseObject:responsDict];
            });
        }
        
        else {
            [self hideHud];
            [self.view makeToast:@"Login Incorrect!!"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR------>> %@",error);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}

-(void)parseDataResponseObject:(NSDictionary *)dictionary {

    if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self hideHud];
        CommunicationArr = [dictionary objectForKey:@"Communication"];
        [self.tableView reloadData];
    }
    else if ([[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseCode"] integerValue] == 0){
          [self hideHud];
        [self.view makeToast:[[dictionary objectForKey:@"Response"] objectForKey:@"ResponseMsg"] ];
    }
}


#pragma mark -MBProgressHUD methods

-(void)showHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.delegate = (id)self;
                       
                   });
}

-(void)hideHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       [hud hide:YES];
                       //[hud removeFromSuperview];
                       
                   });
}


@end
