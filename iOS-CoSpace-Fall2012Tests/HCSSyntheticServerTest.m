//
//  HCSSyntheticServerTest.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSSyntheticServerTest.h"
#import "PDBackgroundHTTPServer.h"
#import "NetworkManager.h"
#import "NetworkManager+Tests.h"

@implementation HCSSyntheticServerTest
- (void)setUp
{
    [super setUp];
    self.testServer = [[PDBackgroundHTTPServer alloc] init];
    NSString *testDataDirectory=[[[NSBundle bundleForClass:[self class]] pathForResource:@"example"
                                                                                  ofType:@"json"] stringByDeletingLastPathComponent];
    [self.testServer startServerWithDocumentRoot:testDataDirectory];
    STAssertTrue(([self.testServer port] > 0), @"should have a port assigned");
    
    [[NetworkManager sharedManager] setBaseURLString:[NSString stringWithFormat:@"http://localhost:%u/",[self.testServer port]]];
    [[NetworkManager sharedManager] setForkFetchURLPath:@"example.json"];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [self.testServer setShouldStop:YES];
    
    [super tearDown];
}

-(void) testFetchForks {
    [[NetworkManager sharedManager] startInitialFetch];
    
    while ([[[NetworkManager sharedManager] fetchQueue] operationCount] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}


@end
