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
#import "UtilityMethods.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [UtilityMethods getCollectionViewFlowLayout];
    [searchResultGrid.collectionViewLayout invalidateLayout];
    searchResultGrid.collectionViewLayout = flowLayout;
    
    [searchResultGrid registerNib:[UINib nibWithNibName:@"LargePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    [self doSearch];
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
    [WikipediaSearch performSearch:searchTerm withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            searchResults = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                [searchResults addObject:[[WikipediaArticle alloc] initWithDictionary:dictionary]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                searchResultCount.text = [NSString stringWithFormat:@"Your search returned %lu results", searchResults.count];
                [activityIndicator stopAnimating];
                [searchResultGrid reloadData];
            });

        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}


#pragma Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"iPhoneTopic"]) {
        PhoneTopicViewController *vc = (PhoneTopicViewController *)[segue destinationViewController];
        vc.topicId = chosenArticle._id;
        vc.topicName = chosenArticle.title;
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
    NSString *extract = article.extract;
    cell.text.text = extract;
    cell.text.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
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
                } else {
                    cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
            });
        }
        
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    chosenArticle = [searchResults objectAtIndex:[indexPath section]];
    [self performSegueWithIdentifier:@"iPhoneTopic" sender:self];
}

@end
