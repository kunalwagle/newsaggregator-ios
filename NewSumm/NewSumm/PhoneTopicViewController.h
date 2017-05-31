//
//  TopicViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "MyTopicsViewController.h"

@interface PhoneTopicViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, LoginDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *leadArticle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *subscribe;
@property NSMutableArray *articles;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSString *topicName;
@property NSString *topicId;
@property NSInteger chosenArticle;
@property BOOL isSubscribed;
@property NSArray *defaultSources;
@property (weak, nonatomic) IBOutlet UILabel *noArticles;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
- (IBAction)subscribe:(id)sender;


@end
