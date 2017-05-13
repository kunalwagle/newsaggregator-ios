//
//  PadTopicsViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PadTopicsViewController.h"
#import "Login.h"
#import "LoginViewController.h"

@interface PadTopicsViewController ()

@end

@implementation PadTopicsViewController

@synthesize topics;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loggedIn {
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn) {
        [self setLoginItemsHidden];
        NSString *emailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"emailAddress"];
        [_activityIndicator startAnimating];
        [_activityIndicator setHidden:NO];
        [Login login:emailAddress withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSError *jsonError;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
                topics = [dict objectForKey:@"topics"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self setLoginItemsHidden];
                });
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    } else {
        [self showLoginItems];
    }
}

-(void)setLoginItemsHidden {
    [_loginLabel setHidden:YES];
    [_loginButton setHidden:YES];
    [_activityIndicator setHidden:YES];
}

-(void)showLoginItems {
    [_loginLabel setHidden:NO];
    [_loginButton setHidden:NO];
    [_activityIndicator setHidden:YES];
}

- (IBAction)login:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];;
    [loginViewController setDelegate:self];
    [self presentViewController:loginViewController animated:YES completion:nil];
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
