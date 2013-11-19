//
//  XMLParser.h
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    BOOL titleParse;
    BOOL imageParse;
    BOOL descriptionParse;
    BOOL itemParse;
    BOOL connection;
    NSMutableArray *titles;
    NSMutableArray *descriptions;
    NSMutableArray *images;
    NSMutableArray * contents;
    NSMutableArray * links;
    NSUserDefaults *uDefaults;
    NSData *XMLdata;
    NSString *XMLString;
}
-(BOOL)haveNewRSS;
-(BOOL)haveDataSaved;
-(BOOL)haveConnection;
-(BOOL)parse;
-(NSMutableArray *) arrayTitle;
-(NSMutableArray *) arrrayImage;
-(NSMutableArray *) arrayContent;
-(NSMutableArray *) arrayLink;
@end
