//
//  TopicViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface PhoneTopicViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *leadArticle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *subscribe;
@property NSMutableArray *articles;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSString *topicName;
@property NSString *topicId;
@property NSInteger chosenArticle;

@end
