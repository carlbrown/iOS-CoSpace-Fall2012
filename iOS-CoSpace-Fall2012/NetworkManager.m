//
//  NetworkManager.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"
#import "HCSAppDelegate.h"
#import "RepoFetchOperation.h"

#define kBaseAPIURL @"https://api.github.com/"
#define kForkFetchURLPath @"/repos/carlbrown/iOS-CoSpace-Fall2012/forks"

static NetworkManager __strong *sharedManager = nil;

@interface NetworkManager ()
@property (nonatomic, strong) NSString *baseURLString;
@property (nonatomic, strong) NSString *forkFetchURLPath;
@property (nonatomic, strong) NSOperationQueue *fetchQueue;
@property (nonatomic, weak) NSManagedObjectContext *mainContext;
@property (nonatomic, assign, getter = isNetworkOnline) BOOL networkOnline;
@property (nonatomic, strong) Reachability *hostReach;
@property (atomic, readwrite) NSUInteger activeFetches;

-(NSURL *) baseURL;
-(NSURL *) urlForRelativePath:(NSString *) relativePath;

@end


@implementation NetworkManager

+ (NetworkManager *)sharedManager {
    static dispatch_once_t pred; dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
        [sharedManager setFetchQueue:[[NSOperationQueue alloc] init]];
        [sharedManager setBaseURLString:kBaseAPIURL];
        [sharedManager setForkFetchURLPath:kForkFetchURLPath];
        [sharedManager setMainContext:[(HCSAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext]];
        //Assume the network is up to start with
        [sharedManager setNetworkOnline:YES];
        [[NSNotificationCenter defaultCenter]
         addObserver: sharedManager
         selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        
        [sharedManager setHostReach:[Reachability reachabilityWithHostname:[[NSURL URLWithString:kBaseAPIURL] host]]];

        
        [sharedManager reactToReachability:[sharedManager hostReach]];
        [sharedManager setActiveFetches:0];
    });
    return sharedManager;
}


-(NSURL *) baseURL {
    return [NSURL URLWithString:self.baseURLString];
}

-(NSURL *) urlForRelativePath:(NSString *) relativePath {
    return [NSURL URLWithString:relativePath relativeToURL:self.baseURL];
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self reactToReachability:curReach];
}

-(void) reactToReachability:(Reachability *) reachability {
    NSParameterAssert([reachability isKindOfClass: [Reachability class]]);
    
    self.hostReach = reachability;
    if ([self.hostReach currentReachabilityStatus]==NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Offiline" message:@"Please try connecting to the Internet" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        [self startInitialFetch];
    }
}

-(void) queuePageFetchForRelativePath:(NSString *) relativePath {
    RepoFetchOperation *repoFetchOperation = [[RepoFetchOperation alloc] init];
    [repoFetchOperation setUrlToFetch:[self urlForRelativePath:relativePath]];
    [repoFetchOperation setMainContext:self.mainContext];
    [repoFetchOperation setDelegate:self];
    [self.fetchQueue addOperation:repoFetchOperation];
}

-(void) startInitialFetch {
    [self queuePageFetchForRelativePath:self.forkFetchURLPath];
}

-(void) fetchDidFailWithError:(NSError *) error {
    //Don't give the user an error if the network is already offline
    if (self.isNetworkOnline) {
        UIAlertView *networkAlertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[[error userInfo] description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [networkAlertView show];
        [self setNetworkOnline:NO];
    }
    
}

-(void) incrementActiveFetches {
    self.activeFetches++;
    if (![[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

-(void) decrementActiveFetches {
    if (self.activeFetches > 1) {
        self.activeFetches--;
        return;
    }
    self.activeFetches=0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
