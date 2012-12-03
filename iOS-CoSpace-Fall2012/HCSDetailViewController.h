//
//  HCSDetailViewController.h
//  iOS-CoSpace-Fall2012
//
//  Created by Carl Brown on 12/2/12.
//  Copyright (c) 2012 PDAgent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Repo;

@interface HCSDetailViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) Repo *detailItem;

@end
