//
//  HCSJSONParsingTest.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSJSONParsingTest.h"
#import "HCSJSONParsingManager.h"

@implementation HCSJSONParsingTest

-(void) testJSONParsing {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"example"
                                                                                                       ofType:@"json"]];
    HCSJSONParsingManager *jsonMgr = [[HCSJSONParsingManager alloc] init];
    NSArray *ownerNames = [jsonMgr parsedArrayFromJSONData:jsonData];
    STAssertEquals((uint) 11, (uint) [ownerNames count], @"Should have added 11 repos");
    STAssertEqualObjects(@"mjhaller", [ownerNames objectAtIndex:0], @"Element 0 incorrect");
    STAssertEqualObjects(@"smmcbride", [ownerNames objectAtIndex:1], @"Element 1 incorrect");
    STAssertEqualObjects(@"danshort", [ownerNames objectAtIndex:10], @"Element 10 incorrect");

}

@end
