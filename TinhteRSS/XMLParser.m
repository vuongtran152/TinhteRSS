//
//  XMLParser.m
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import "XMLParser.h"
#import "DescriptionParser.h"

@implementation XMLParser

// check connection

-(BOOL)haveConnection{
    NSLog(@"checkConnection:");
    connection = YES;
    NSURL *link = [[NSURL alloc] initWithString:@"http://www.tinhte.vn/rss"];
    NSError *error = NULL;
    XMLString = [[NSString alloc] initWithContentsOfURL:link encoding:NSUTF8StringEncoding error:&error];
    if(error!=NULL)
    {
        connection = NO;
    }
    NSLog(@"%i",connection);
    return connection;
}

// parse RSS

-(BOOL)parse{
    NSLog(@"parse:");
    if (![self haveDataSaved]) {
        if ([self haveConnection]) {
            XMLdata = [XMLString  dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            return [self parserXML];
        }
        return NO;
    }
    if ([self haveConnection]&&[self haveNewRSS]) {
        NSLog(@"have new RSS");
        [self parserXML];
        return [self parserXML];
    }
    else{
        [self loadData];
    }
    return YES;
}

// check new RSS

-(BOOL)haveNewRSS
{
    NSLog(@"HaveNewRSS:");
    XMLdata = [XMLString  dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *publicDate = [[NSString alloc] initWithData:XMLdata encoding:NSASCIIStringEncoding];
    publicDate =[publicDate substringWithRange:NSMakeRange(500,31)];
    uDefaults = [NSUserDefaults standardUserDefaults];
    NSString *oldPublicDate = [uDefaults objectForKey:@"publicDate"];
    NSLog(@"%i",!([publicDate isEqualToString:oldPublicDate]));
    return  !([publicDate isEqualToString:oldPublicDate]);
}

// check datasaved

-(BOOL)haveDataSaved{
    NSLog(@"haveDataSaved:");
    uDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%i",[[uDefaults objectForKey:@"haveData"] isEqualToString:@"YES"]);
    return  [[uDefaults objectForKey:@"haveData"] isEqualToString:@"YES"];
}

 
// save title, image, content, link to userdefaults

-(void)saveData{
    NSLog(@"saveData:");
    [uDefaults setObject:titles forKey:@"Keytitles"];
    [uDefaults setObject:images forKey:@"Keyimages"];
    [uDefaults setObject:links forKey:@"Keylinks"];
    [uDefaults setObject:contents forKey:@"Keycontents"];
    NSString *haveData = @"YES";
    [uDefaults setObject:haveData forKey:@"haveData"];
    [uDefaults synchronize];
}

// load title, image, content, link from userdefaults

-(void)loadData{
    titles = [uDefaults objectForKey:@"Keytitles"];
    images = [uDefaults objectForKey:@"Keyimages"];
    links = [uDefaults objectForKey:@"Keylinks"];
    contents = [uDefaults objectForKey:@"Keycontents"];
}


// parse RSS

-(BOOL)parserXML{

    NSLog(@"parserXML:");
    titleParse = NO;
    imageParse = NO;
    descriptionParse = NO;
    itemParse = NO;
    titles = [[NSMutableArray alloc] init];
    descriptions = [[NSMutableArray alloc] init];
    
    // save publicDate
    
     NSString *publicDate = [[NSString alloc] initWithData:XMLdata encoding:NSASCIIStringEncoding];
     publicDate =[publicDate substringWithRange:NSMakeRange(500,31)];
     [uDefaults setObject:publicDate forKey:@"publicDate"];
     [uDefaults synchronize];
    
    //-----------------------//
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XMLdata];
    [parser setDelegate:self];
    BOOL isParsed = [parser parse];
    [self fixRSS];
    [self saveData];
    return isParsed;
}



// delegate NSXMLParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"title"]) {
        titleParse = YES;
    }
    if ([elementName isEqualToString:@"description"]) {
        descriptionParse = YES;
    }
    if ([elementName isEqualToString:@"item"]) {
        itemParse = YES;
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (titleParse&&itemParse) {
        [titles addObject:string];
    }
    if (descriptionParse&&itemParse) {
        [descriptions addObject:string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"title"]) {
        titleParse = NO;
    }
    if ([elementName isEqualToString:@"description"]) {
        descriptionParse = NO;
    }
    if ([elementName isEqualToString:@"item"]) {
        itemParse = NO;
    }
}

//  fix Rss UTF8

-(void)fixRSS{
    
    // DescriptionParse
    @autoreleasepool
    {
    DescriptionParser *parser = [[DescriptionParser alloc] init];
    // image
    
    NSMutableArray *imageTM = [[NSMutableArray alloc] init];
     
    
    for(int i = 0;i<descriptions.count;i++){
        [parser parserDescription:[descriptions objectAtIndex:i]];
        NSString *sImage = [parser getimage];
        [imageTM addObject:sImage];
    }
        images = imageTM;
    
    // content
    NSMutableArray *contentTM = [[NSMutableArray alloc] init];
    for(int i = 0;i<descriptions.count;i++){
        [parser parserDescription:[descriptions objectAtIndex:i]];
        NSString *sContent = [parser getcontent];
        [contentTM addObject:sContent];
    }
    // link
    NSMutableArray *linkTM = [[NSMutableArray alloc] init];
    for(int i = 0;i<descriptions.count;i++){
        [parser parserDescription:[descriptions objectAtIndex:i]];
        NSString *sContent = [parser getLink];
        [linkTM addObject:sContent];
    }


    
    // fix title
    NSMutableArray *titleTMP = [[NSMutableArray alloc] init];
    NSString *t1 = @"";
    for(int i =0; i<titles.count;i++){
        NSString *t2 = [titles objectAtIndex:i];
        t1 = [NSString stringWithFormat:@"%@%@",t1,t2];
        if ([self endTitle:t2]==YES) {
            
            [titleTMP addObject:t1];
            t1=@"";
        }
    }
    titles = titleTMP;
    contents = contentTM;
    links = linkTM;
    }
}

// endTitle in fix title

-(BOOL)endTitle:(NSString *)string{
    NSString *xml = [[NSString alloc] initWithData:XMLdata encoding:NSUTF8StringEncoding];
    NSRange range = [xml rangeOfString:string];
    range.location = range.location + range.length;
    range.length = 8;
    NSString *endTitle = [xml substringWithRange:range];
    if ([endTitle isEqualToString:@"</title>"]) {
        return YES;
    }
    return  NO;
}

// return data

-(NSMutableArray *) arrayTitle{
    return titles;
}

-(NSMutableArray *) arrrayImage{
    return images;
}
-(NSMutableArray *) arrayContent{
    return contents;
}

-(NSMutableArray *) arrayLink{
    return links;
}

@end
