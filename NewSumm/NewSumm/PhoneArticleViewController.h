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
@property NSMutableArray *sources;
@property (weak, nonatomic) IBOutlet UIButton *summaryAnalysisButton;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property BOOL summaryAnalysis;
@property NSInteger chosenSentence;
@property NSInteger chosenLink;
- (IBAction)summaryAnalysisButtonClicked:(id)sender;

@end
