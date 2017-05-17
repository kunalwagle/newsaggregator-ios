//
//  SettingsViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 14/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "SettingsViewController.h"
#import "Login.h"
#import "LoginViewController.h"
#import "TopicSettingsViewController.h"
#import "UIView+Toast.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize topics;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginClicked = NO;
    self.loginButton.layer.cornerRadius = 5;
    self.logout.layer.cornerRadius = 5;
    self.tv.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self loggedIn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loggedIn {
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn) {
        if (self.loginClicked) {
            [self.view makeToast:@"Succesfully logged in" duration:5.0 position:CSToastPositionTop];
        }
        self.loginClicked = NO;
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
                    [_tv reloadData];
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
    [_logout setHidden:NO];
    [_activityIndicator setHidden:YES];
    [_tv setHidden:NO];
}

-(void)showLoginItems {
    [_loginLabel setHidden:NO];
    [_loginButton setHidden:NO];
    [_logout setHidden:YES];
    [_activityIndicator setHidden:YES];
    [_tv setHidden:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [topics count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:101];
    label.text = [[[topics objectAtIndex:[indexPath row]] objectForKey:@"labelHolder"] objectForKey:@"label"];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select a topic to alter settings or unsubscribe";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (IBAction)login:(id)sender {
    self.loginClicked = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];;
    [loginViewController setDelegate:self];
    [self presentViewController:loginViewController animated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showSettings"]) {
        TopicSettingsViewController *vc = (TopicSettingsViewController*)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tv indexPathForSelectedRow];
        vc.topicName = [[[topics objectAtIndex:[indexPath row]] objectForKey:@"labelHolder"] objectForKey:@"label"];
        vc.selectedOutlets = [[[topics objectAtIndex:[indexPath row]] objectForKey:@"sources"] mutableCopy];
        vc.topicId = [[[topics objectAtIndex:[indexPath row]] objectForKey:@"labelHolder"] objectForKey:@"id"];
        vc.digest = [[[topics objectAtIndex:[indexPath row]] objectForKey:@"digests"] boolValue];
        vc.delegate = self;
        [self.tv deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (IBAction)logout:(id)sender {
    [self.view makeToast:@"Succesfully logged out" duration:3.0 position:CSToastPositionTop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self viewDidLoad];
    [self viewWillAppear:YES];

}

@end
