//
//  HCSDetailViewController.m
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 12/2/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import "HCSDetailViewController.h"
#import "Repo.h"

@interface HCSDetailViewController ()

@end

@implementation HCSDetailViewController

@synthesize detailItem = _detailItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.detailItem url]]];
        [self.webView loadRequest:req];
    }
}

#pragma mark - ScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.webView;
}

#pragma mark - WebView

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

@end
