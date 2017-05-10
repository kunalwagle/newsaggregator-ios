//
//  PadArticleViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 10/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface PadArticleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *articleTableView;
@property (weak, nonatomic) IBOutlet UITableView *sourceTableView;
@property Article *article;
@property NSString *topicName;
@property NSString *articleText;

@end