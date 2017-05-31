//
//  SearchResultsViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "WikipediaSearch.h"
#import "LargePanelCollectionViewCell.h"
#import "PhoneTopicViewController.h"
#import "TopicCollectionViewController.h"
#import "UtilityMethods.h"
#import "TopicSearch.h"
#import "Article.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

@synthesize searchTerm;
@synthesize searchField;
@synthesize searchButton;
@synthesize searchResultGrid;
@synthesize searchResultCount;
@synthesize searchResults;
@synthesize activityIndicator;
@synthesize chosenArticle;
@synthesize articles;
@synthesize isSubscribed;

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [UtilityMethods getCollectionViewFlowLayout];
    [searchResultGrid.collectionViewLayout invalidateLayout];
    searchResultGrid.collectionViewLayout = flowLayout;
    searchField.delegate = self;
    searchButton.layer.cornerRadius = 5;
    [searchResultGrid registerNib:[UINib nibWithNibName:@"LargePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    [self doSearch];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UtilityMethods getBackgroundColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(doSearch)
                  forControlEvents:UIControlEventValueChanged];
    [searchResultGrid addSubview:self.refreshControl];
    searchResultGrid.alwaysBounceVertical = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSearch {
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    [searchResults removeAllObjects];
    [searchResultGrid reloadData];
    [searchResultCount setHidden:YES];
    [WikipediaSearch performSearch:searchTerm withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            searchResults = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                [searchResults addObject:[[WikipediaArticle alloc] initWithDictionary:dictionary]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.refreshControl) {
                    self.refreshControl.attributedTitle = [UtilityMethods getRefreshControlTimeStamp];
                    [self.refreshControl endRefreshing];
                }
                [searchResultCount setHidden:NO];
                searchResultCount.text = [NSString stringWithFormat:@"Your search returned %lu results", (unsigned long)searchResults.count];
                [activityIndicator stopAnimating];
                [searchResultGrid reloadData];
            });

        } else {
            NSLog(@"Error: %@", error);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.refreshControl) {
                    self.refreshControl.attributedTitle = [UtilityMethods getRefreshControlTimeStamp];
                    [self.refreshControl endRefreshing];
                }
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
}

- (void)getTopic:(NSString*)topicId {
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    articles = [[NSMutableArray alloc] init];
    [TopicSearch getTopic:topicId withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            _defaultSources = [result objectForKey:@"sources"];
            NSDictionary *dict = [result objectForKey:@"labelHolder"];
            isSubscribed = [[dict objectForKey:@"subscribed"] boolValue];
            NSArray *array = [dict objectForKey:@"clusters"];
            for (NSDictionary *dictionary in array) {
                NSArray *arts = [dictionary objectForKey:@"articles"];
                if (arts && [arts count] > 0) {
                    [articles addObject:[[Article alloc] initWithDictionary:dictionary]];
                }
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [activityIndicator stopAnimating];
                [activityIndicator setHidden:YES];
                if ([UtilityMethods isIPad]) {
                    [self performSegueWithIdentifier:@"iPadTopic" sender:self];
                } else {
                    [self performSegueWithIdentifier:@"iPhoneTopic" sender:self];
                }
            });
            
        } else {
            NSLog(@"Error: %@", error);
            dispatch_sync(dispatch_get_main_queue(), ^{
            
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
}


#pragma Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"iPhoneTopic"]) {
        PhoneTopicViewController *vc = (PhoneTopicViewController *)[segue destinationViewController];
        vc.topicId = chosenArticle._id;
        vc.topicName = chosenArticle.title;
        vc.articles = articles;
        vc.isSubscribed = isSubscribed;
        vc.defaultSources = _defaultSources;
    } else if ([[segue identifier] isEqualToString:@"iPadTopic"]) {
        TopicCollectionViewController *vc = (TopicCollectionViewController*)[segue destinationViewController];
        vc.topicId = chosenArticle._id;
        vc.topicName = chosenArticle.title;
        vc.articles = articles;
        vc.isSubscribed = isSubscribed;
        vc.defaultSources = _defaultSources;
    }
}


- (IBAction)search:(id)sender {
    searchTerm = searchField.text;
    if (searchTerm.length > 0) {
        [self doSearch];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CGFloat width = self.view.frame.size.width;
    float count = width / 315.0f;
    int total = floor(count);
    NSInteger itemsRemaining = [searchResults count] - total*section;
    return MIN(itemsRemaining, total);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!searchResults) {
        searchResults = [[NSMutableArray alloc] init];
    }
    CGFloat width = self.view.frame.size.width;
    float count = floor(width / 315.0f);
    return ceil([searchResults count]/count);
}

- (LargePanelCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LargePanelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largePanel" forIndexPath:indexPath];
    NSUInteger index = ([indexPath section]*[collectionView numberOfItemsInSection:0]) + [indexPath row];
    WikipediaArticle *article = [searchResults objectAtIndex:index];
    cell.title.text = article.title;
    NSString *extract = @"WIKPEDIA Intro: ";
    extract = [extract stringByAppendingString:[[article.extract substringToIndex:100] stringByAppendingString:@"..."]];
    NSString *cellText = [NSString stringWithFormat:@"%@\r\rArticle Count: %@", extract, [article articleCount]];
    cell.text.text = cellText;
//    cell.text.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    if (!article.image) {
        cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        NSError *error = nil;
        if (article.imageUrl && article.imageUrl.length>1) {
            NSURL *url = [NSURL URLWithString:[article imageUrl]];
            NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
            UIImage *image = [UIImage imageWithData:imageData];
            NSLog(@"Finished asynchrously attempting download");
            if (error)
                NSLog(@"Download error: %@", error);
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    cell.image.image = image;
                    article.image = image;
                } else {
                    cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
                    article.image = image;
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
            });
        }
        
    });
    } else {
        cell.image.image = article.image;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    chosenArticle = [searchResults objectAtIndex:(([indexPath section]*[collectionView numberOfItemsInSection:0]) + [indexPath row])];
    [self getTopic:chosenArticle._id];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    [textField resignFirstResponder];
    return NO;
}

@end
