//
//  BaseFetchOperation.m
//  TPApp
//
//  Created by Carl Brown on 11/8/12.
//
//

#import "BaseFetchOperation.h"

@implementation BaseFetchOperation

@synthesize urlToFetch = _urlForJSONData;
@synthesize fetchedData = _jsonData;
@synthesize done = _done;
@synthesize connection = _connection;
@synthesize response = _response;
@synthesize delegate = _delegate;

- (void)main {
    if ([self isCancelled]) {
        return;
    }
    if (!_urlForJSONData) {
        NSLog(@"Cannot start without a URL");
        return;
    }
    
    [self setFetchedData:[NSMutableData data]]; //Initialize
    NSURLRequest *request = [NSURLRequest requestWithURL:[self urlToFetch]];
    
    if (self.delegate) {
        [self.delegate incrementActiveFetches];
    }
    
    [self setConnection:[NSURLConnection connectionWithRequest:request delegate:self]];
    
    CFRunLoopRun();
}

-(void) finish {
    [self setDone:YES];
    if (self.delegate) {
        [self.delegate decrementActiveFetches];
    }
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([self isCancelled]) {
        [[self connection] cancel];
        [self finish];
        return;
    }
    
    [self setResponse:(NSHTTPURLResponse *) response];
    [self setFetchedData:[NSMutableData data]]; //truncate
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if ([self isCancelled]) {
        [[self connection] cancel];
        [self finish];
        return;
    }
    [self.fetchedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error connecting: %@",[error localizedDescription]);
    if (self.delegate) {
        [self.delegate fetchDidFailWithError:error];
    }
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    if (self.response.statusCode==200) {
        NSLog(@"Fetch Operation to URL '%@' succeeded with body: '%@'",self.urlToFetch.absoluteString,[NSString stringWithUTF8String:self.fetchedData.bytes]);
    } else {
        NSLog(@"Fetch Operation to URL '%@' failed with code %d and body: '%@'",self.urlToFetch.absoluteString,self.response.statusCode,[NSString stringWithUTF8String:self.fetchedData.bytes]);
    }
    
    [self finish];
}

@end
