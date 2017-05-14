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

@interface PadTopicsViewController ()

@end

@implementation PadTopicsViewController

@synthesize topics;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loggedIn];
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
                    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
                    self.pageViewController.dataSource = self;
                    self.pageViewController.delegate = self;
                    
                    TopicCollectionViewController *startingViewController = [self viewControllerAtIndex:0];
                    NSArray *viewControllers = @[startingViewController];
                    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                    
                    // Change the size of page view controller
                    self.pageViewController.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height - 120);
                    
                    [self addChildViewController:_pageViewController];
                    [self.view addSubview:_pageViewController.view];
                    [self.pageViewController didMoveToParentViewController:self];
                    UIViewController* vc = self.pageViewController.viewControllers[0];
                    self.navigationItem.title = vc.navigationItem.title;
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

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TopicCollectionViewController*) viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TopicCollectionViewController*) viewController).index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.topics count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (TopicCollectionViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.topics count] == 0) || (index >= [self.topics count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TopicCollectionViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageContentController"];
    
    pageContentViewController.index = index;
    
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    NSDictionary *chosenArticle = [topics objectAtIndex:index];
    NSArray *array = [chosenArticle objectForKey:@"clusters"];
    for (NSDictionary *dictionary in array) {
        NSArray *arts = [dictionary objectForKey:@"articles"];
        if (arts && [arts count] > 0) {
            [articles addObject:[[Article alloc] initWithDictionary:dictionary]];
        }
    }

    pageContentViewController.articles = articles;
    pageContentViewController.topicId = chosenArticle[@"_id"];
    pageContentViewController.topicName = chosenArticle[@"label"];
    
    return pageContentViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    // .viewControllers[0] is always (in my case at least) the 'current' viewController.
    UIViewController* vc = self.pageViewController.viewControllers[0];
    self.navigationItem.title = vc.navigationItem.title;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.topics count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
