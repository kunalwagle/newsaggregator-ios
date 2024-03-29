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
#import "Unsubscribe.h"
#import "Settings.h"

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
    [dailyDigest setOn:digest];
    save.layer.cornerRadius = 5;
    unsubscribe.layer.cornerRadius = 5;
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
        if (selected) {
            cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.141 blue:0.212 alpha:1.0];
        } else {
            cell.backgroundColor = [UIColor clearColor];
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
    } else {
        cell.backgroundColor = [UIColor clearColor];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailAddress = [defaults objectForKey:@"emailAddress"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:selectedOutlets forKey:@"sources"];
    [dictionary setValue:[NSNumber numberWithBool:[dailyDigest isOn]] forKey:@"digest"];
    [dictionary setObject:_topicId forKey:@"topicId"];
    [dictionary setObject:emailAddress forKey:@"user"];
    [Settings settings:dictionary withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Saved"
                                          message:@"Your settings were saved"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
        } else {
            NSLog(@"Error: %@", error);
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"Something went wrong there. Sorry about that"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
}

- (IBAction)unsubscribe:(id)sender {
    [Unsubscribe unsubscribe:_topicId withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate loggedIn];
            });
        }
    }];

}

@end
