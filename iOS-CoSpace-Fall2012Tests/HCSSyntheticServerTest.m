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
#import "Repo.h"
#import <CoreData/CoreData.h>

@interface HCSSyntheticServerTest ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchRequest *fetchRequest;

@end

@implementation HCSSyntheticServerTest

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchRequest = _fetchRequest;

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
    //NSLog(@"Checking for repo from user %@",[repoDict valueForKeyPath:@"owner.login"]);
    NSError *fetchError=nil;
    NSArray *existingRepos = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:&fetchError];
    
    STAssertEquals((uint) 0, (uint) [existingRepos count], @"Shouldn't have any repos in new store");

    
    [[NetworkManager sharedManager] setMainContext:self.managedObjectContext];
    [[NetworkManager sharedManager] startInitialFetch];
    
    while ([[[NetworkManager sharedManager] fetchQueue] operationCount] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    NSArray *foundRepos = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:&fetchError];

    
    STAssertEquals((uint) 11, (uint) [foundRepos count], @"Should have added 11 repos");
    
    STAssertEqualObjects(@"bithai", [[foundRepos objectAtIndex:0] login], @"Element 0 incorrect");
    STAssertEqualObjects(@"bobtodd", [[foundRepos objectAtIndex:1] login], @"Element 1 incorrect");
    STAssertEqualObjects(@"thedug", [[foundRepos objectAtIndex:10] login], @"Element 10 incorrect");


}

#pragma mark - Test Core Data Stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iOS-CoSpace-Fall2012" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
        
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(NSFetchRequest *) fetchRequest {
    if (_fetchRequest != nil) {
        return _fetchRequest;
    }

    _fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Repo class])];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"login" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [_fetchRequest setSortDescriptors:sortDescriptors];
    
    return _fetchRequest;
}

@end
