//
//  ViewController.h
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController <UIAlertViewDelegate>  {

    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *imageContentView;
    IBOutlet UIWebView *contentView;
    NSMutableArray *titles;
    NSMutableArray  *images;
    NSMutableArray  *contents;
    NSMutableArray *links;
    IBOutlet UIView *mainView;
    IBOutlet UIView *logoView;
    NSUserDefaults * imagesCache;
    XMLParser *xmlparser;
    IBOutlet UIButton *newButton;
    IBOutlet UIImageView *leftImage;
    IBOutlet UIImageView *rightImage;
}
// property to hold a reference to the delegate
@property (assign) int page;
- (IBAction)swipeleft:(id)sender;
- (IBAction)swipright:(id)sender;
-(void) loadPage;
- (IBAction)logoClick:(id)sender;
- (IBAction)reLoad:(id)sender;

@end