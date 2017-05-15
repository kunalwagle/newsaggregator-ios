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
#import "PhoneNewsOutletCollectionViewCell.h"

@interface TopicSettingsViewController ()

@end

@implementation TopicSettingsViewController

@synthesize outletCollectionView;
@synthesize dailyDigest;
@synthesize save;
@synthesize unsubscribe;
@synthesize outlets;
@synthesize selectedOutlets;
@synthesize digest;

- (void)viewDidLoad {
    [super viewDidLoad];
    outlets = @[@"associated-press", @"the-guardian-uk", @"independent", @"reuters", @"business-insider-uk", @"daily-mail", @"espn-cric-info", @"metro", @"mirror", @"newsweek", @"the-telegraph", @"the-times-of-india"];
    self.navigationItem.title = _topicName;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:-10.0f];
    [flowLayout setMinimumLineSpacing:15.0f];
    if ([UtilityMethods isIPad]) {
        [flowLayout setItemSize:CGSizeMake(150, 180)];
        [outletCollectionView registerNib:[UINib nibWithNibName:@"NewsOutletCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    } else {
        [flowLayout setItemSize:CGSizeMake(100, 120)];
        [outletCollectionView registerNib:[UINib nibWithNibName:@"PhoneNewsOutletCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    [outletCollectionView.collectionViewLayout invalidateLayout];
    outletCollectionView.collectionViewLayout = flowLayout;
    [outletCollectionView setAllowsMultipleSelection:YES];
    // Register cell classes
    
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
    NSString *topic = [outlets objectAtIndex:[indexPath row]];
    BOOL selected = [selectedOutlets containsObject:topic];
    if (![UtilityMethods isIPad]) {
        PhoneNewsOutletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.imageView.image = [UIImage imageNamed:topic];
        cell.label.text = [UtilityMethods getPublicationName:topic];
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
        cell.imageView.layer.masksToBounds = YES;
        [cell setSelected:selected];
        if (selected) {
            cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.141 blue:0.212 alpha:1.0];
        }
        return cell;
    }
    NewsOutletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:topic];
    cell.label.text = [UtilityMethods getPublicationName:topic];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
    cell.imageView.layer.masksToBounds = YES;
    if (selected) {
        cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.141 blue:0.212 alpha:1.0];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *topic = [outlets objectAtIndex:[indexPath row]];
    BOOL selected = [selectedOutlets containsObject:topic];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (!selected) {
        cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.141 blue:0.212 alpha:1.0];
        [selectedOutlets addObject:topic];
    } else {
        cell.backgroundColor = [UIColor clearColor];
        [selectedOutlets removeObject:topic];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (IBAction)save:(id)sender {
    
}

- (IBAction)unsubscribe:(id)sender {
}
@end
