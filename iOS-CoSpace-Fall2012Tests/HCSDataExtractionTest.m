//
//  HCSDataExtractionTest.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSDataExtractionTest.h"
#import "HCSJSONDataExtractor.h"

@implementation HCSDataExtractionTest

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/// This method is only used to pre-parse the JSON file into an NSData that gets written to the project
/*-(void) freezeJSONData {
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"example" ofType:@"json"]];

    NSError *parseError=nil;
    
    NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self applicationDocumentsDirectory] path]]) {
        NSError *mkDirError=nil;

        [[NSFileManager defaultManager] createDirectoryAtURL:[self applicationDocumentsDirectory] withIntermediateDirectories:YES attributes:nil error:&mkDirError];
    }
    
    NSURL *dataFile = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"exampleJSONData.plist"];
    
    NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:parsedJSONArray];
    
    NSError *writeError = nil;
    
    if ([dataToSave writeToURL:dataFile options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"Created data file at: %@ - you should copy this into the project and check it in.",dataFile);
    } else {
        NSLog(@"There was an error writing to %@:%@",dataFile,writeError);
    }
    
}*/

-(void) testDataExtraction {
    //Get the data back from the file where we "froze" it
    NSData *frozenData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"exampleJSONData" ofType:@"plist"]];
    NSArray *parsedJSONArray = [NSKeyedUnarchiver unarchiveObjectWithData:frozenData];

    //extract the parts from it we want to test
    HCSJSONDataExtractor *extractor = [[HCSJSONDataExtractor alloc] init];
    NSArray *ownerNames = [extractor arrayExtractedFromJSONArray:parsedJSONArray];
    
    //Make sure the data is correct
    STAssertEquals((uint) 11, (uint) [ownerNames count], @"Should have added 11 repos");
    STAssertEqualObjects(@"mjhaller", [ownerNames objectAtIndex:0], @"Element 0 incorrect");
    STAssertEqualObjects(@"smmcbride", [ownerNames objectAtIndex:1], @"Element 1 incorrect");
    STAssertEqualObjects(@"danshort", [ownerNames objectAtIndex:10], @"Element 10 incorrect");


}

@end
