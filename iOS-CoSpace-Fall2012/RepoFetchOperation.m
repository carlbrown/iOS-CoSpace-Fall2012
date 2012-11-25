//
//  RepoFetchOperation.m
//  SeismicJSON
//
//  Created by Carl Brown on 8/21/12.
//  Copyright (c) 2012 PDAgent, LLC. Released under MIT license ( http://opensource.org/licenses/MIT ).
//

#import "RepoFetchOperation.h"
#import "Repo.h"

@implementation RepoFetchOperation
@synthesize mainContext = _mainContext;

-(void) main {
    if (!_mainContext) {
        NSLog(@"Cannot start without a Primary Managed Object Context");
        return;
    }
    
    [super main];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    if (self.response.statusCode!=200) {
        NSLog(@"Bad HTTP response code: %d[%@]",self.response.statusCode,[NSHTTPURLResponse localizedStringForStatusCode:self.response.statusCode]);
        [self finish];
        return;
    }
    
    NSError *parseError=nil;
    
    NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:self.fetchedData options:NSJSONReadingMutableContainers error:&parseError];
    if (!parsedJSONArray) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parse Error" message:[parseError description] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:self.mainContext.persistentStoreCoordinator];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:context];
    
    for (NSDictionary *repoDict in parsedJSONArray) {
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        [newManagedObject setValue:[repoDict valueForKeyPath:@"owner.login"] forKey:@"login"];
        
    }
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    [self finish];
}

@end