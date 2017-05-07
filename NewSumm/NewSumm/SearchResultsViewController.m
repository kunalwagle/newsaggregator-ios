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

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

@synthesize searchTerm;
@synthesize searchField;
@synthesize searchButton;
@synthesize searchResultGrid;
@synthesize searchResultCount;
@synthesize searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    [searchResultGrid registerNib:[UINib nibWithNibName:@"LargePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    [self doSearch];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSearch {
    [WikipediaSearch performSearch:searchTerm withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NULL error:&jsonError];
            searchResults = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                [searchResults addObject:[[WikipediaArticle alloc] initWithDictionary:dictionary]];
            }
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
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NULL;
}

@end
