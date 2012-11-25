//
//  HCSSyntheticServerTest.h
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class PDBackgroundHTTPServer;

@interface HCSSyntheticServerTest : SenTestCase

@property (nonatomic, strong) PDBackgroundHTTPServer *testServer;

@end
