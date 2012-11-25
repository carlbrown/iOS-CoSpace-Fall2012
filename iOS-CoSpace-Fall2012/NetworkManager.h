//
//  NetworkManager.h
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoFetchOperation.h"

@interface NetworkManager : NSObject <FetchNotifierDelegate>

+ (NetworkManager *)sharedManager;

-(void) startInitialFetch;

@end
