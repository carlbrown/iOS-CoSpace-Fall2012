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

static NetworkManager __strong *sharedManager = nil;

@interface NetworkManager ()
@property (nonatomic, strong) NSString *baseURLString;
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
        [sharedManager setBaseURLString:@"https://api.github.com/"];
        [sharedManager setMainContext:[(HCSAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext]];
        //Assume the network is up to start with
        [sharedManager setNetworkOnline:YES];
        [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        [sharedManager setActiveFetches:0];
    });
    return sharedManager;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    if ([curReach currentReachabilityStatus]==NotReachable) {
        [self setNetworkOnline:NO];
    } else {
        [self setNetworkOnline:YES];
    }
}

-(NSURL *) baseURL {
    return [NSURL URLWithString:self.baseURLString];
}

-(NSURL *) urlForRelativePath:(NSString *) relativePath {
    return [NSURL URLWithString:relativePath relativeToURL:self.baseURL];
}

@end
