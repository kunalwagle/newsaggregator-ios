//
//  SearchResultsViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "WikipediaSearch.h"
#import "WikipediaArticle.h"
#import "LargePanelCollectionViewCell.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:-10.0f];
    [flowLayout setMinimumLineSpacing:15.0f];
    [flowLayout setItemSize:CGSizeMake(315, 250)];
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)search:(id)sender {
    searchTerm = searchField.text;
    if (searchTerm.length > 0) {
        [self doSearch];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!searchResults) {
        searchResults = [[NSMutableArray alloc] init];
    }
    return [searchResults count];
}

- (LargePanelCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LargePanelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largePanel" forIndexPath:indexPath];
    WikipediaArticle *article = [searchResults objectAtIndex:[indexPath section]];
    cell.title.text = article.title;
    NSString *extract = article.extract;
    cell.text.text = extract;
    cell.text.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
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

@end
