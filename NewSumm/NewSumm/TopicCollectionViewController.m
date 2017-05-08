//
//  TopicCollectionViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "TopicCollectionViewController.h"
#import "LargePanelCollectionViewCell.h"
#import "ExtraLargePanel.h"
#import "TopicSearch.h"
#import "MosaicLayout.h"
#import "Article.h"

@interface TopicCollectionViewController ()

@end

@implementation TopicCollectionViewController

@synthesize topicName;
@synthesize topicId;
@synthesize activityIndicator;
@synthesize articles;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [(MosaicLayout *)_collectionView.collectionViewLayout setDelegate:self];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ExtraLargePanel" bundle:nil] forCellWithReuseIdentifier:@"extraLargePanel"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LargePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    self.navigationItem.title = topicName;
    // Do any additional setup after loading the view.
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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!articles) {
        articles = [[NSMutableArray alloc] init];
    }
    return [articles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        ExtraLargePanel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"extraLargePanel" forIndexPath:indexPath];
        Article *article = [articles objectAtIndex:[indexPath row]+1];
        NSDictionary *source = [[article articles] objectAtIndex:0];
        cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
        cell.title.text = source[@"title"];
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
    
    LargePanelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largePanel" forIndexPath:indexPath];
    Article *article = [articles objectAtIndex:[indexPath row]+1];
    NSDictionary *source = [[article articles] objectAtIndex:0];
    cell.image.image = [UIImage imageNamed:@"default-thumbnail.jpg"];
    cell.title.text = source[@"title"];
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

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        return 300;
    }
    return 150;
}

-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0 && [indexPath row] == 0) {
        return YES;
    }
    return NO;
}

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView {
    if ([articles count] == 0) {
        return 0;
    }
    return 4;
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

@end
