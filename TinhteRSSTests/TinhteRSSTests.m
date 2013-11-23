//
//  TinhteRSSTests.m
//  TinhteRSSTests
//
//  Created by Tran Cong Vuong on 11/15/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DescriptionParser.h"
#import "XMLParser.h"

@interface TinhteRSSTests : XCTestCase

@end

@implementation TinhteRSSTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testXmlParser {
    XMLParser *parser = [[XMLParser alloc] init];
    [parser parse];
    
    // have connection //
    if ([parser haveConnection]) {
        XCTAssertNotNil([parser arrayContent], @"have connection and Content not nil!");
    }
    // have no connection //
    else{
        if ([parser haveDataSaved]) {
            XCTAssertNotNil([parser arrayContent], @"have no connection and have data saved and Content not nil!");
        }
        else
            XCTAssertNil([parser arrayContent], @"have no connection and have no data saved and Content is nil!");
    }
}
@end
