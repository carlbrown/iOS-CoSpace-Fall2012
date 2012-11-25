//
//  HCSJSONParsingManager.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSJSONParsingManager.h"

#import "HCSJSONDataExtractor.h"

@implementation HCSJSONParsingManager

-(NSArray *) parsedArrayFromJSONData:(NSData *) dataForJSONParsing {
    NSError *parseError=nil;

    NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:dataForJSONParsing options:NSJSONReadingMutableContainers error:&parseError];
    if (!parsedJSONArray) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parse Error" message:[parseError description] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return nil;
    }
    
    HCSJSONDataExtractor *extractor = [[HCSJSONDataExtractor alloc] init];
    
    return [NSArray arrayWithArray:[extractor arrayExtractedFromJSONArray:parsedJSONArray]];
}

@end
