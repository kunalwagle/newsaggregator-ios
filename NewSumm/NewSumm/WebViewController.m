//
//  WebViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 12/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "WebViewController.h"
#import "UtilityMethods.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [UtilityMethods getPublicationName:_source];
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
