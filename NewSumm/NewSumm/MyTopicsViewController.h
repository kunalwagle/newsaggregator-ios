//
//  MyTopicsViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>
- (void)loggedIn;
@end

@interface MyTopicsViewController : UIViewController<LoginDelegate, UITableViewDelegate, UITableViewDataSource>

@property NSArray *topics;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableArray *articles;
@property NSDictionary *chosenArticle;

@end
