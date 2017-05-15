//
//  MyTopicsViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "MyTopicsViewController.h"
#import "Login.h"
#import "LoginViewController.h"
#import "TopicSearch.h"
#import "Article.h"
#import "PhoneTopicViewController.h"

@interface MyTopicsViewController ()

@end

@implementation MyTopicsViewController

@synthesize topics;

- (void)viewDidLoad {
    [super viewDidLoad];
    _activityIndicator.hidden = YES;
    [self loggedIn];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self loggedIn];
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
    [_activityIndicator setHidden:YES];
    [_tv setHidden:NO];
}

-(void)showLoginItems {
    [_loginLabel setHidden:NO];
    [_loginButton setHidden:NO];
    [_activityIndicator setHidden:YES];
    [_tv setHidden:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [topics count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:100];
    UILabel *label = [cell viewWithTag:101];
    NSDictionary *topic = [[topics objectAtIndex:[indexPath row]] objectForKey:@"labelHolder"];
    label.text = topic[@"label"];
    imageView.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        NSError *error = nil;
        NSString *imageUrl = [topic[@"articles"] objectAtIndex:0][@"imageUrl"];
        if (imageUrl && ![imageUrl isKindOfClass:[NSNull class]])  {
            
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
            UIImage *image = [UIImage imageWithData:imageData];
            NSLog(@"Finished asynchrously attempting download");
            if (error)
                NSLog(@"Download error: %@", error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    imageView.image = image;
                } else {
                    imageView.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
            });
        }
    });
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self getTopic:[indexPath row]];
}

- (void)getTopic:(NSInteger)topicId {
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    _articles = [[NSMutableArray alloc] init];
    _chosenArticle = [[topics objectAtIndex:topicId] objectForKey:@"labelHolder"];
    _defaultSources = [[topics objectAtIndex:topicId] objectForKey:@"sources"];
    NSArray *array = [_chosenArticle objectForKey:@"clusters"];
    for (NSDictionary *dictionary in array) {
        NSArray *arts = [dictionary objectForKey:@"articles"];
        if (arts && [arts count] > 0) {
            [_articles addObject:[[Article alloc] initWithDictionary:dictionary]];
        }
    }
    
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
    [self performSegueWithIdentifier:@"showTopic" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showTopic"]) {
        PhoneTopicViewController *vc = (PhoneTopicViewController *)[segue destinationViewController];
        vc.topicId = _chosenArticle[@"_id"];
        vc.topicName = _chosenArticle[@"label"];
        vc.articles = _articles;
        vc.defaultSources = _defaultSources;
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

- (IBAction)login:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];;
    [loginViewController setDelegate:self];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end
