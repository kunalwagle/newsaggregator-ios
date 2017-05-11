//
//  PadArticleViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 10/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PadArticleViewController.h"

@interface PadArticleViewController ()

@end

@implementation PadArticleViewController

@synthesize articleTableView;
@synthesize sourceTableView;
@synthesize article;
@synthesize articleText;
@synthesize topicName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *text = [[article summaries] objectAtIndex:0];
    self.navigationItem.title = @"";
    articleText = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in text) {
        [articleText addObject:dictionary[@"sentence"]];
    }
    articleTableView.estimatedRowHeight = 260;
    articleTableView.rowHeight = UITableViewAutomaticDimension;
    sourceTableView.estimatedRowHeight = 260;
    sourceTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [articleTableView reloadData];
    [sourceTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == articleTableView) {
        return 3;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == articleTableView) {
        if (section == 2) {
            return [articleText count];
        }
        return 1;
    }
    return [[article articles] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == sourceTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"source" forIndexPath:indexPath];
        NSDictionary *dictionary = [[article articles] objectAtIndex:[indexPath row]];
        UILabel *textLabel = [cell viewWithTag:103];
        UILabel *detailTextLabel = [cell viewWithTag:104];
        UIImageView *imageView = [cell viewWithTag:102];
        textLabel.text = dictionary[@"title"];
        detailTextLabel.text = dictionary[@"articleUrl"];
        UIImage *image = [UIImage imageNamed:dictionary[@"source"]];
        imageView.image = image;
        imageView.layer.cornerRadius = 50;
        imageView.layer.masksToBounds = YES;
        return cell;
    }
    switch ([indexPath section]) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
            UILabel *title = [cell viewWithTag:99];
            title.text = [[[article articles] objectAtIndex:0] objectForKey:@"title"];
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            UIImageView *imageView = [cell viewWithTag:100];
            UIImage *image = [article image];
            CGFloat aspect = image.size.width / image.size.height;
            NSLayoutConstraint *aspectConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:imageView
                                                                                attribute:NSLayoutAttributeHeight
                                                                               multiplier:aspect
                                                                                 constant:0.0];
            aspectConstraint.priority = 999;
            [imageView setImage:image];
            [cell.contentView addConstraint:aspectConstraint];
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
            UILabel *label = [cell viewWithTag:101];
            label.text = [articleText objectAtIndex:[indexPath row]];
            break;
        }
    }
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == sourceTableView) {
        return @"Summary Sources";
    } else {
        return @"";
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
