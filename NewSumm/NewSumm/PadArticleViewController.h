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
@property NSMutableArray *articleText;
@property NSMutableArray *sources;
- (IBAction)summaryAnalysis:(id)sender;
@property BOOL summaryAnalysis;
@property NSIndexPath* chosenSentence;
@property NSInteger chosenLink;
@property NSArray *defaultSources;
@property (weak, nonatomic) IBOutlet UIButton *summaryAnalysisButton;

@end
