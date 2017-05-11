//
//  PhoneArticleViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 09/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface PhoneArticleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property Article *article;
@property NSString *topicName;
@property NSMutableArray *articleText;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@end
