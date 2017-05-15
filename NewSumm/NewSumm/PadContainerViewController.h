//
//  PadContainerViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 15/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PadContainerViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *articles;
@property NSUInteger index;
@property NSString *topicName;
@property NSString *topicId;
@property NSInteger chosenArticle;

@end
