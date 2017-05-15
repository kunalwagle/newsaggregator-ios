//
//  PadContainerViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 15/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PadContainerViewController.h"
#import "UtilityMethods.h"
#import "LargeArticlePanel.h"
#import "Article.h"
#import "PadArticleViewController.h"

@interface PadContainerViewController ()

@end

@implementation PadContainerViewController

@synthesize topicName;
@synthesize topicId;
@synthesize articles;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView.collectionViewLayout invalidateLayout];
    self.collectionView.collectionViewLayout = [UtilityMethods getCollectionViewFlowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LargeArticlePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!articles) {
        articles = [[NSMutableArray alloc] init];
    }
    return [articles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LargeArticlePanel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largePanel" forIndexPath:indexPath];
    Article *article = [articles objectAtIndex:[indexPath row]];
    NSDictionary *source = [[article articles] objectAtIndex:0];
    cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
    cell.title.text = source[@"title"];
    article.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        NSError *error = nil;
        if (![source[@"imageUrl"] isKindOfClass:[NSNull class]]) {
            NSURL *url = [NSURL URLWithString:source[@"imageUrl"]];
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
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
            });
        }
        
    });
    return cell;
    
    
    // Configure the cell
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _chosenArticle = [indexPath row] + 2*[indexPath section];
    [self performSegueWithIdentifier:@"showArticle" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showArticle"]) {
        PadArticleViewController *vc = (PadArticleViewController*)[segue destinationViewController];
        vc.article = [articles objectAtIndex:_chosenArticle];
        vc.topicName = topicName;
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
