//
//  SearchResultsViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikipediaArticle.h"

@interface SearchResultsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSString *searchTerm;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *searchResultCount;
@property (weak, nonatomic) IBOutlet UICollectionView *searchResultGrid;
@property NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property WikipediaArticle *chosenArticle;
- (IBAction)search:(id)sender;

@end
