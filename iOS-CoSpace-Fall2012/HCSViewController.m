//
//  HCSViewController.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 10/22/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSViewController.h"
#import "Reachability.h"

#define kBaseAPIURL @"https://api.github.com/repos/carlbrown/iOS-CoSpace-Fall2012/forks"

@interface HCSViewController ()

@property (nonatomic, retain) Reachability *reachability;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableArray *repoArray;
@property (nonatomic, retain) NSMutableData *connectionData;

@end

@implementation HCSViewController
@synthesize tableView = _tableView;
@synthesize reachability = _reachability;
@synthesize connection = _connection;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    self.reachability = [Reachability reachabilityWithHostname:[[NSURL URLWithString:kBaseAPIURL] host]];
    
    [self reactToReachability:self.reachability];
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self reactToReachability:curReach];
}
                             
-(void) reactToReachability:(Reachability *) reachability {
    NSParameterAssert([reachability isKindOfClass: [Reachability class]]);

    self.reachability = reachability;
    if ([self.reachability currentReachabilityStatus]==NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Offiline" message:@"Please try connecting to the Internet" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        NSURLRequest *apiReq = [NSURLRequest requestWithURL:[NSURL URLWithString:kBaseAPIURL]];
        self.connection = [NSURLConnection connectionWithRequest:apiReq delegate:self];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *) response;
    if ([resp statusCode] == 200) {
        self.connectionData = [NSMutableData data];
    } else if ([resp statusCode] > 399) { //skip redirects
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[NSString stringWithFormat:@"Error %d",resp.statusCode] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSError *parseError=nil;
    
    NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:self.connectionData options:NSJSONReadingMutableContainers error:&parseError];
    if (!parsedJSONArray) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parse Error" message:[parseError description] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    self.repoArray = [NSMutableArray arrayWithCapacity:[parsedJSONArray count]];
    for (NSDictionary *repoDict in parsedJSONArray) {
        [self.repoArray addObject:[repoDict valueForKeyPath:@"owner.login"]];
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.textLabel setText:[self.repoArray objectAtIndex:indexPath.row]];
    
    return cell;
}
@end
