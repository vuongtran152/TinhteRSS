//
//  DescriptionParser.h
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DescriptionParser : NSObject <NSXMLParserDelegate> {

    BOOL imageParse;
    BOOL descriptionParse;
    BOOL parsed;
    NSString *content;
    NSString *images;
    NSString *titleInImg;
    NSString *altInImg;
    NSString *classInImg;
    NSString *linkNew;
}
-(void)parserDescription:(NSString *)description;
-(NSString *) getimage;
-(NSString *) getcontent;
-(NSString *) getLink;
-(void)clear;
-(BOOL) isParsed;
@end
