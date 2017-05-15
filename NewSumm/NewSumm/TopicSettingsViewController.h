//
//  TopicSettingsViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 14/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTopicsViewController.h"

@interface TopicSettingsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *outletCollectionView;
@property (weak, nonatomic) IBOutlet UISwitch *dailyDigest;
- (IBAction)save:(id)sender;
- (IBAction)unsubscribe:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIButton *unsubscribe;
@property NSArray *outlets;
@property NSString *topicName;
@property NSMutableArray *selectedOutlets;
@property NSString *topicId;
@property id<LoginDelegate> delegate;
@property BOOL digest;

@end
