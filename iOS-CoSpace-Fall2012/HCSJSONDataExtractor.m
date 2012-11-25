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
        [retVal addObject:[repoDict valueForKeyPath:@"owner.login"]];
    }
    return [NSArray arrayWithArray:retVal];
}

@end
