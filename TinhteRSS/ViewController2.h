//
//  ViewController2.h
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/17/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController2 : UIViewController{
    NSUserDefaults * userDefaults;
    IBOutlet UIWebView *contentWebView;
}
- (IBAction)Share:(id)sender;
//@property (strong, nonatomic) IBOutlet UIWebView *contentViewWeb;
- (IBAction)back:(id)sender;


@property (nonatomic, strong) NSString *recipeUrl;
@property (nonatomic, strong) NSString *recipeImage;
@property (nonatomic, strong) NSString *recipeTitles;
@property (nonatomic, strong) NSString *recipeContent;
@end
