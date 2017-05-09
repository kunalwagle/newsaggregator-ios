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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *text = [[article summaries] objectAtIndex:0];
    self.navigationItem.title = @"";
    articleText = @"";
    for (NSDictionary *dictionary in text) {
        articleText = [articleText stringByAppendingString:[NSString stringWithFormat:@"%@\n", dictionary[@"sentence"]]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch ([indexPath row]) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
            UILabel *title = [cell viewWithTag:99];
            title.text = [[[article articles] objectAtIndex:0] objectForKey:@"title"];
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
            UIImageView *imageView = [cell viewWithTag:100];
            imageView.image = [article image];
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
            UILabel *label = [cell viewWithTag:101];
            label.text = articleText;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath row]) {
        case 0: {
            NSString *title = [[[article articles] objectAtIndex:0] objectForKey:@"title"];
            CGSize size = [title sizeWithAttributes:
                           @{NSFontAttributeName: [UIFont systemFontOfSize:22.0f]}];
            return ceilf(size.height)+10;
        }
        case 1:
            return 260;
        default: {
            CGSize size = [articleText sizeWithAttributes:
                           @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];
            return ceilf(size.height)+10;
        }
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
