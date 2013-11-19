//
//  DescriptionParser.m
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import "DescriptionParser.h"

@implementation DescriptionParser

-(void)parserDescription:(NSString *)description{
    @autoreleasepool {

    imageParse = NO;
    descriptionParse = NO;
    NSRange startRange = [description rangeOfString:@"<div "];
    NSRange endRange = [description rangeOfString:@"</div>"];
    
    NSRange searchRange = NSMakeRange(startRange.location , endRange.location);
    ///
    // need parse to get link and link image
    ///
    NSString *imgeAndLink =[NSString stringWithFormat:@"%@%@%@",@"<?xml version=\"1.0\"?>",[description substringWithRange:searchRange],@"</div>"]  ;
    
    NSData *dataImageAndLink = [imgeAndLink dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser * parser = [[NSXMLParser alloc]initWithData:dataImageAndLink];
    [parser setDelegate:self];
    parsed = [parser parse];
    NSString *stringRemove1 = [NSString stringWithFormat:@"<img src=\"%@\" title=\"%@\" alt=\"%@\" class=\"%@\" />",images,titleInImg,altInImg,classInImg];
    NSString *stringRemove2 = [NSString stringWithFormat:@"<img src=\"%@\" class=\"%@\" alt=\"%@\" />",images,classInImg,altInImg];
    content = [description stringByReplacingOccurrencesOfString:stringRemove1 withString:@""];
    content = [content stringByReplacingOccurrencesOfString:stringRemove2 withString:@""];
    //<img src="http://cdn.tinhte.vn/attachments/primesense_chips-jpg.1223817/" class="bbCodeImage LbImage" alt="[IMG]" />
    content = [NSString stringWithFormat:@"<!DOCTYPE html><html><body> %@ </div></body></html>",content];
    }
}

////////////// return valua

-(BOOL) isParsed{
    return parsed;
}

-(NSString *) getimage{
    return images;
}
-(NSString *) getcontent{
    return content;
}
-(NSString *) getLink{
    return linkNew;
}

/////////////

///////////start element parse delegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"img"]){
        NSString *stringTMP=[attributeDict valueForKey:@"src"];
        images = stringTMP;
        stringTMP=[attributeDict valueForKey:@"title"];
        titleInImg = stringTMP;
        stringTMP=[attributeDict valueForKey:@"alt"];
        altInImg = stringTMP;
        stringTMP=[attributeDict valueForKey:@"class"];
        classInImg = stringTMP;

    }
    if([elementName isEqualToString:@"a"]){
        linkNew = [attributeDict valueForKey:@"href"];
    }
}

-(void) clear{
    
}
@end
