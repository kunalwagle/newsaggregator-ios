//
//  PhoneArticleViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 09/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PhoneArticleViewController.h"

@interface PhoneArticleViewController ()

@end

@implementation PhoneArticleViewController

@synthesize article;
@synthesize topicName;
@synthesize articleText;
@synthesize tv;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *text = [[article summaries] objectAtIndex:0];
    self.navigationItem.title = @"";
    articleText = @"";
    for (NSDictionary *dictionary in text) {
        articleText = [articleText stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", dictionary[@"sentence"]]];
    }
    tv.estimatedRowHeight = 260;
    tv.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [tv reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return [[article articles] count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([indexPath section] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"source" forIndexPath:indexPath];
        NSDictionary *dictionary = [[article articles] objectAtIndex:[indexPath row]];
        cell.textLabel.text = dictionary[@"title"];
        cell.detailTextLabel.text = dictionary[@"articleUrl"];
        UIImage *image = [UIImage imageNamed:dictionary[@"source"]];
        cell.imageView.image = image;
        cell.imageView.layer.cornerRadius = image.size.width / 2;
        cell.imageView.layer.masksToBounds = YES;
        return cell;
    }
    switch ([indexPath row]) {
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
            label.text = articleText;
            break;
        }
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Summary Sources";
    } else {
        return @"";
    }
}



//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch ([indexPath row]) {
//        case 0: {
//            NSString *title = [[[article articles] objectAtIndex:0] objectForKey:@"title"];
//            CGSize size = [title sizeWithAttributes:
//                           @{NSFontAttributeName: [UIFont systemFontOfSize:22.0f]}];
//            return ceilf(size.height)+10;
//        }
//        case 1:
//            return 260;
//        default: {
//            CGSize size = [articleText sizeWithAttributes:
//                           @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];
//            return ceilf(size.height)+10;
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
