//
//  TopicCollectionViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicLayoutDelegate.h"

@interface TopicCollectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, MosaicLayoutDelegate>

@property NSMutableArray *articles;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSString *topicName;
@property NSString *topicId;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
