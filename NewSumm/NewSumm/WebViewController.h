//
//  WebViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 12/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSString *url;
@property NSString *source;

@end
