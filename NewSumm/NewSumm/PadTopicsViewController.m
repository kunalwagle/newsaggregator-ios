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
#import "Article.h"
#import "UIView+Toast.h"
#import "PadContainerViewController.h"
#import "UtilityMethods.h"


@interface PadTopicsViewController ()

@end

@implementation PadTopicsViewController

@synthesize topics;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loggedIn];
    self.loginClicked = NO;
    self.loginButton.layer.cornerRadius = 5;
    self.topicTable.tableFooterView = [UIView new];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UtilityMethods getBackgroundColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loggedIn)
                  forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.topicTable;
    tableViewController.refreshControl = self.refreshControl;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    BOOL clicked = self.loginClicked;
    [self loggedIn];
    self.loginClicked = clicked;
    
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
                    if (self.refreshControl) {
                        self.refreshControl.attributedTitle = [UtilityMethods getRefreshControlTimeStamp];
                        [self.refreshControl endRefreshing];
                    }
                    [_activityIndicator setHidden:YES];
                    [self setLoginItemsHidden];
                    [_topicTable reloadData];
                    
                });
            } else {
                NSLog(@"Error: %@", error);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (self.refreshControl) {
                        self.refreshControl.attributedTitle = [UtilityMethods getRefreshControlTimeStamp];
                        [self.refreshControl endRefreshing];
                    }
                    [_activityIndicator setHidden:YES];
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"Something went wrong there. Sorry about that"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    
                    [alert addAction:ok];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }); 
            }
        }];
    } else {
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
        [self showLoginItems];
    }
}

-(void)setLoginItemsHidden {
    [_loginLabel setHidden:YES];
    [_loginButton setHidden:YES];
    
    [_topicTable setHidden:NO];
    [_container setHidden:NO];
}

-(void)showLoginItems {
    [_loginLabel setHidden:NO];
    [_loginButton setHidden:NO];
    [_topicTable setHidden:YES];
    [_container setHidden:YES];
}

- (IBAction)login:(id)sender {
    self.loginClicked = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];;
    [loginViewController setDelegate:self];
    [self presentViewController:loginViewController animated:YES completion:nil];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath   {
    UIViewController *vc = [self.childViewControllers objectAtIndex:0];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    [self performSegueWithIdentifier:@"embed" sender:self];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"My Topics";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"embed"]) {
        NSIndexPath *indexPath = [_topicTable indexPathForSelectedRow];
        if (indexPath) {
            PadContainerViewController *vc = (PadContainerViewController *)[segue destinationViewController];
            NSMutableArray *articles = [[NSMutableArray alloc] init];
            NSDictionary *chosenArticle = [[topics objectAtIndex:[indexPath row]] objectForKey:@"labelHolder"];
            NSArray *array = [chosenArticle objectForKey:@"clusters"];
            for (NSDictionary *dictionary in array) {
                NSArray *arts = [dictionary objectForKey:@"articles"];
                if (arts && [arts count] > 0) {
                    [articles addObject:[[Article alloc] initWithDictionary:dictionary]];
                }
            }
            
            self.navigationItem.title = chosenArticle[@"label"];
            
            vc.articles = articles;
            vc.topicId = chosenArticle[@"_id"];
            vc.topicName = chosenArticle[@"label"];
            vc.defaultSources = [[topics objectAtIndex:[indexPath row]] objectForKey:@"sources"];
        }
    }
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
