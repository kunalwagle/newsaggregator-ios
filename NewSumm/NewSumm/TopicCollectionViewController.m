//
//  TopicCollectionViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "TopicCollectionViewController.h"
#import "LargeArticlePanel.h"
#import "ExtraLargePanel.h"
#import "TopicSearch.h"
#import "Article.h"
#import "UtilityMethods.h"
#import "PadArticleViewController.h"
#import "Subscribe.h"

@interface TopicCollectionViewController ()

@end

@implementation TopicCollectionViewController

@synthesize topicName;
@synthesize topicId;
@synthesize activityIndicator;
@synthesize articles;
@synthesize subscribeButton;
@synthesize isSubscribed;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
//    UICollectionViewFlowLayout *flowLayout = [UtilityMethods getCollectionViewFlowLayout];
//    [self.collectionView.collectionViewLayout invalidateLayout];
//    self.collectionView.collectionViewLayout = flowLayout;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:-10.0f];
    [flowLayout setMinimumLineSpacing:15.0f];
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    self.collectionView.collectionViewLayout = flowLayout;
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ExtraLargePanel" bundle:nil] forCellWithReuseIdentifier:@"extraLargePanel"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LargeArticlePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    self.navigationItem.title = topicName;
    
    [self checkSubscription];
    
    // Do any additional setup after loading the view.
}

- (void)checkSubscription {
    if (isSubscribed) {
        [subscribeButton setTitle:@"Unsubscribe" forState:UIControlStateNormal];
        [subscribeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!articles) {
        articles = [[NSMutableArray alloc] init];
    }
    if (section == 0) {
        return MIN([articles count], 2);
    }
    return MAX([articles count] - 2, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        ExtraLargePanel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"extraLargePanel" forIndexPath:indexPath];
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
                NSLog(@"Finished asynchrously attempting download on Topic Collection screen");
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
    }
    
    LargeArticlePanel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largePanel" forIndexPath:indexPath];
    Article *article = [articles objectAtIndex:[indexPath row]+2];
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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return CGSizeMake(480, 350);
    }
    return CGSizeMake(320, 250);
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

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)subscribe:(id)sender {
    if (!isSubscribed) {
        [Subscribe subscribe:topicId withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                isSubscribed = true;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self checkSubscription];            });
            }
        }];
    }
}
@end
