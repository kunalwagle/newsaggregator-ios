//
//  TopicCollectionViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTopicsViewController.h"

@interface TopicCollectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, LoginDelegate>

@property NSMutableArray *articles;
@property NSUInteger index;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSString *topicName;
@property NSString *topicId;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property BOOL isSubscribed;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property NSInteger chosenArticle;
@property NSArray *defaultSources;
- (IBAction)subscribe:(id)sender;

@end
