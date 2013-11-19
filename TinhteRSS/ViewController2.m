//
//  ViewController2.m
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/17/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import "ViewController2.h"
#import <FacebookSDK/FacebookSDK.h>


@interface ViewController2 ()

@end

@implementation ViewController2
@synthesize recipeUrl;
@synthesize recipeImage;
@synthesize recipeTitles;
@synthesize recipeContent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSURL *websiteUrl = [NSURL URLWithString:recipeUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [contentWebView loadRequest:urlRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Share:(id)sender {
    NSString *linkURL = recipeUrl;
    NSString *pictureURL = recipeImage;
    
    // Prepare the native share dialog parameters
    FBShareDialogParams *shareParams = [[FBShareDialogParams alloc] init];
    shareParams.link = [NSURL URLWithString:linkURL];
    shareParams.name = recipeTitles;
    shareParams.caption= @"Cộng Đồng Khoa Học Công Nghệ Tinh Tế tinhte.vn";
    shareParams.picture= [NSURL URLWithString:pictureURL];
    shareParams.description = recipeContent;
    
    if ([FBDialogs canPresentShareDialogWithParams:shareParams]){
        
        [FBDialogs presentShareDialogWithParams:shareParams
                                    clientState:nil
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                            if(error) {
                                                NSLog(@"Error publishing story.");
                                            } else if (results[@"completionGesture"] && [results[@"completionGesture"] isEqualToString:@"cancel"]) {
                                                NSLog(@"User canceled story publishing.");
                                            } else {
                                                NSLog(@"Story published.");
                                            }
                                        }];
        
    }else {
        
        // Prepare the web dialog parameters
        NSDictionary *params = @{
                                 @"name" : shareParams.name,
                                 @"caption" : shareParams.caption,
                                 @"description" : shareParams.description,
                                 @"picture" : pictureURL,
                                 @"link" : linkURL
                                 };
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 NSLog(@"Error publishing story.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     NSLog(@"User canceled story publishing.");
                 } else {
                     NSLog(@"Story published.");
                 }
             }}];
        
    }

}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
