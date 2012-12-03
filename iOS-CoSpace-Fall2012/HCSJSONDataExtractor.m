//
//  HCSJSONDataExtractor.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSJSONDataExtractor.h"

@implementation HCSJSONDataExtractor

-(NSArray *) arrayExtractedFromJSONArray:(NSArray *) arrayFromJSON {
    NSMutableArray *retVal = [NSMutableArray arrayWithCapacity:[arrayFromJSON count]];
    for (NSDictionary *repoDict in arrayFromJSON) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[repoDict valueForKeyPath:@"owner.login"],@"login",[repoDict valueForKeyPath:@"html_url"],@"html_url", nil];
        [retVal addObject:dict];
    }
    return [NSArray arrayWithArray:retVal];
}

@end
