//
//  SettingsViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 14/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTopicsViewController.h"

@interface SettingsViewController : UIViewController<LoginDelegate, UITableViewDelegate, UITableViewDataSource>

@property NSArray *topics;
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logout;
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property BOOL loginClicked;
@property UIRefreshControl *refreshControl;

@end
