//
//  NetworkManager+Tests.h
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/24/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#ifndef iOS_CoSpace_Fall2012_NetworkManager_Tests_h
#define iOS_CoSpace_Fall2012_NetworkManager_Tests_h

@interface NetworkManager ()
@property (nonatomic, strong) NSString *baseURLString;
@property (nonatomic, strong) NSString *forkFetchURLPath;
@property (nonatomic, strong) NSOperationQueue *fetchQueue;
@property (nonatomic, weak) NSManagedObjectContext *mainContext;
@end


#endif
