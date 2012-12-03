//
//  Repo.h
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 11/5/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Repo : NSManagedObject

@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * url;

@end
