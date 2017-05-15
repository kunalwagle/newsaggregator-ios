//
//  TopicViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PhoneTopicViewController.h"
#import "LargeArticlePanel.h"
#import "ArticleTableViewCell.h"
#import "TopicSearch.h"
#import "UtilityMethods.h"
#import "PhoneArticleViewController.h"
#import "Subscribe.h"
#import "Unsubscribe.h"

@interface PhoneTopicViewController ()

@end

@implementation PhoneTopicViewController

@synthesize leadArticle;
@synthesize tableView;
@synthesize subscribe;
@synthesize articles;
@synthesize activityIndicator;
@synthesize topicId;
@synthesize topicName;
@synthesize chosenArticle;
@synthesize isSubscribed;
@synthesize subscribeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [UtilityMethods getCollectionViewFlowLayout];
    [leadArticle.collectionViewLayout invalidateLayout];
    leadArticle.collectionViewLayout = flowLayout;
    [leadArticle registerNib:[UINib nibWithNibName:@"LargeArticlePanel" bundle:nil] forCellWithReuseIdentifier:@"largePanel"];
    [tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.title = topicName;
    
    [self checkSubscription];
    
    

    // Do any additional setup after loading the view.
}

-(void)checkSubscription {
    if (isSubscribed) {
        [subscribeButton setTitle:@"Unsubscribe" forState:UIControlStateNormal];
        [subscribeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
        [subscribeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showArticle"]) {
        PhoneArticleViewController *vc = (PhoneArticleViewController*)[segue destinationViewController];
        vc.article = [articles objectAtIndex:chosenArticle];
        vc.topicName = topicName;
    }
}


#pragma table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (articles == NULL) {
        return 0;
    }
    return MAX([articles count] - 1, 0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Article *article = [articles objectAtIndex:[indexPath row]+1];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168;
}

#pragma collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [articles count]>0 ? 1 : 0;
}

- (LargeArticlePanel *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

}

-(void)selectedArticle:(NSInteger)index {
    chosenArticle = index;
    [self performSegueWithIdentifier:@"showArticle" sender:self];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedArticle:0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectedArticle:[indexPath row]+1];
}

-(IBAction)subscribe:(id)sender {
    if (!isSubscribed) {
        [Subscribe subscribe:topicId withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                isSubscribed = true;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self checkSubscription];            });
            }
        }];
    }  else {
        [Unsubscribe unsubscribe:topicId withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                isSubscribed = false;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self checkSubscription];            });
            }
        }];
    }
}

@end
