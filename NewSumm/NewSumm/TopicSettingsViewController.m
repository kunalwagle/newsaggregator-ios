//
//  TopicSettingsViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 14/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "TopicSettingsViewController.h"
#import "NewsOutletCollectionViewCell.h"
#import "UtilityMethods.h"

@interface TopicSettingsViewController ()

@end

@implementation TopicSettingsViewController

@synthesize outletCollectionView;
@synthesize dailyDigest;
@synthesize save;
@synthesize unsubscribe;
@synthesize outlets;

- (void)viewDidLoad {
    [super viewDidLoad];
    outlets = @[@"associated-press", @"the-guardian-uk", @"independent", @"reuters", @"business-insider-uk", @"daily-mail", @"espn-cric-info", @"metro", @"mirror", @"newsweek", @"the-telegraph", @"the-times-of-india"];
    self.navigationItem.title = _topicName;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:-10.0f];
    [flowLayout setMinimumLineSpacing:15.0f];
    [flowLayout setItemSize:CGSizeMake(150, 180)];
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    
    [outletCollectionView.collectionViewLayout invalidateLayout];
    outletCollectionView.collectionViewLayout = flowLayout;
    [outletCollectionView setAllowsMultipleSelection:YES];
    // Register cell classes
    [outletCollectionView registerNib:[UINib nibWithNibName:@"NewsOutletCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [outlets count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NewsOutletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[outlets objectAtIndex:[indexPath row]]];
    cell.label.text = [UtilityMethods getPublicationName:[outlets objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsOutletCollectionViewCell *cell = (NewsOutletCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NewsOutletCollectionViewCell *cell = (NewsOutletCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.141 blue:0.212 alpha:1.0];
}

- (IBAction)save:(id)sender {
    
}

- (IBAction)unsubscribe:(id)sender {
}
@end
