//
//  ViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 04/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchResultsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize searchButton;
@synthesize searchField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    searchButton.layer.cornerRadius = 5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchClicked:(id)sender {
    if (searchField.text.length>0) {
        [self performSegueWithIdentifier:@"showSearchResults" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSearchResults"]) {
        SearchResultsViewController *vc = (SearchResultsViewController *) [segue destinationViewController];
        vc.searchTerm = searchField.text;
    }
}

@end
