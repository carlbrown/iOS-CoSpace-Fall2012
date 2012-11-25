//
//  BaseFetchOperation.h
//  TPApp
//
//  Created by Carl Brown on 11/8/12.
//
//

#import <UIKit/UIKit.h>

@protocol FetchNotifierDelegate;

@interface BaseFetchOperation : NSOperation <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURL *urlToFetch;
@property (nonatomic, strong) NSMutableData *fetchedData;
@property (nonatomic, assign, getter=isDone) BOOL done;
@property (nonatomic, assign) NSURLConnection *connection;
@property (nonatomic, retain) NSHTTPURLResponse *response;

@property (nonatomic, unsafe_unretained) NSObject<FetchNotifierDelegate> *delegate;

-(void) finish;

@end

@protocol FetchNotifierDelegate <NSObject>
-(void) fetchDidFailWithError:(NSError *) error;
-(void) incrementActiveFetches;
-(void) decrementActiveFetches;
@end
