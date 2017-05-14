//
//  PadTopicsViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTopicsViewController.h"
#import "TopicCollectionViewController.h"

@interface PadTopicsViewController : UIViewController<LoginDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSArray *topics;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
