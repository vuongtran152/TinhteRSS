//
//  ViewController.m
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "StringToMD5.h"

@interface ViewController ()
@property(nonatomic) int pagenum;
@end

@implementation ViewController
@synthesize page;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    imagesCache = [NSUserDefaults standardUserDefaults];
    self.view = logoView;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [mainView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipright:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [mainView addGestureRecognizer:swipeRight];
    newButton.hidden = YES;
    [newButton setBackgroundImage:[UIImage imageNamed:@"haveNew.png"] forState:UIControlStateNormal];
    
    [self firstLoad];
    [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(checkNew:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)firstLoad{
    NSLog(@"firstLoad!");
    xmlparser = [[XMLParser alloc] init];
    BOOL parsed = [xmlparser parse];
    _pagenum =0;
    leftImage.hidden = YES;
    if (parsed==YES) {
        titles = [xmlparser arrayTitle];
        images = [xmlparser arrrayImage];
        contents = [xmlparser arrayContent];
        links = [xmlparser arrayLink];
        [self loadPage];
        self.view = mainView;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't connect to tinhte.vn" message:@"Close this app!." delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    
    }
}

-(void) loadPage{
    @autoreleasepool {
        NSLog(@"page %i",_pagenum);
        [titleLabel setText:[titles objectAtIndex:_pagenum]];
        [contentView loadHTMLString:[contents objectAtIndex:_pagenum] baseURL:nil];
        if ([imagesCache objectForKey:[images objectAtIndex:_pagenum]]==NULL) {
            UIImage *loading = [UIImage imageNamed:@"loading.png"];
            [imageContentView setImage:loading];
            [self performSelectorInBackground:@selector(getImage:) withObject:nil];
        }
        else{
            UIImage *imgTMP = [imagesCache objectForKey:[images objectAtIndex:_pagenum]];
            [imageContentView setImage:imgTMP];
        }
    }
    
}


-(void) getImage:(id) sender{
    @autoreleasepool {
        NSString *url = [images objectAtIndex:_pagenum];
        NSString *nameImage = [[[StringToMD5 alloc] init] MD5String:url];
        NSData *getImageFLink = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/tmp/Image%@",nameImage]];
        if(getImageFLink==nil){
            getImageFLink = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:url]];
            [getImageFLink writeToFile:[NSString stringWithFormat:@"/tmp/Image%@",nameImage] atomically:NO];
        }
        if(getImageFLink!=nil){
            UIImage *imgTMP = [[UIImage alloc] initWithData:getImageFLink];
            [imageContentView setImage:imgTMP];
        }
        else{
            UIImage *imageNoConnection = [UIImage imageNamed:@"noConnectionIcon.png"];
            [imageContentView setImage:imageNoConnection];
            NSLog(@"no Image saved and not connect to server!");
        }
        if (_pagenum<images.count-1) {
            [self repairImage];
        }
    }
    
}
-(void)repairImage{
    @autoreleasepool {
        NSString *url = [images objectAtIndex:_pagenum+1];
        NSString *nameImage = [[[StringToMD5 alloc] init] MD5String:url];
        //  NSData *getImageFLink = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:url]];
        NSData *getImageFLink = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/tmp/Image%@",nameImage]];
        if(getImageFLink==nil){
            getImageFLink = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:url]];
            [getImageFLink writeToFile:[NSString stringWithFormat:@"/tmp/Image%@",nameImage] atomically:NO];
        }

    }
}

/*
 
 */


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    // the user clicked OK
    if (buttonIndex == 0)
    {
        exit(0);
    }
    else
    {
        //[self reloadData];
    }
}




- (IBAction)logoClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tinhte.vn"]];
}

- (IBAction)swipeleft:(id)sender {
    if(_pagenum+1<titles.count){
        _pagenum++;
        leftImage.hidden = NO;
        [self loadPage];
        if (_pagenum+1==titles.count) {
            rightImage.hidden = YES;
        }
    }
}
- (IBAction)swipright:(id)sender {
    if(_pagenum >0)
    {
        _pagenum--;
        rightImage.hidden = NO;
        [self loadPage];
        if (_pagenum==0) {
            leftImage.hidden = YES;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showReadmoreViewController"]) {
        ViewController2 *destViewController = segue.destinationViewController;
        destViewController.recipeUrl = [links objectAtIndex:_pagenum];
        destViewController.recipeTitles = [titles objectAtIndex:_pagenum];
        destViewController.recipeImage = [images objectAtIndex:_pagenum];
        destViewController.recipeContent = [contents objectAtIndex:_pagenum];

    }
}
-(void)checkNew:(id)sender{
    if ([xmlparser haveNewRSS]) {
        newButton.hidden = NO;
    }
}


- (IBAction)reLoad:(id)sender {
    newButton.hidden = YES;
    self.view = logoView;
    [self performSelectorInBackground:@selector(firstLoad) withObject:nil];
}
-(void) loadNew:(id) sender{
    
}
@end
