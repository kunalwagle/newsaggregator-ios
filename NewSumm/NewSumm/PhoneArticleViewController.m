//
//  PhoneArticleViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 09/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PhoneArticleViewController.h"
#import "UtilityMethods.h"
#import "SourceTableViewController.h"
#import "WebViewController.h"

@interface PhoneArticleViewController ()

@end

@implementation PhoneArticleViewController

@synthesize article;
@synthesize topicName;
@synthesize articleText;
@synthesize tv;
@synthesize sources;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view;
    sources = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in article.articles) {
        [sources addObject:[dictionary objectForKey:@"source"]];
    }
    [self updateSources];
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
    if (section == 2) {
        return [articleText count];
    } else if (section == 3) {
        return [[article articles] count];
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
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
            NSString *string = [articleText objectAtIndex:[indexPath row]];
            UILabel *label = [cell viewWithTag:101];
            if (_summaryAnalysis) {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                NSString *sourceString = [NSString stringWithFormat:@"[%@]", [sources componentsJoinedByString:@","]];
                NSArray *sentences = [[article summaryMap] objectForKey:sourceString];
                NSDictionary *sentence = [sentences objectAtIndex:[indexPath row]];
                if (sentence[@"relatedNodes"] && [sentence[@"relatedNodes"] count]>0) {
                    label.text = string;
                } else {
                    NSMutableAttributedString *s =
                    [[NSMutableAttributedString alloc] initWithString:string];
                
                    [s addAttribute:NSBackgroundColorAttributeName
                              value:[UtilityMethods getColour:sentence[@"source"]]
                          range:NSMakeRange(0, s.length)];
                    [s addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, s.length)];
                    label.attributedText = s;
                }
            } else {
                label.text = string;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        }
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"source" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            NSDictionary *dictionary = [[article articles] objectAtIndex:[indexPath row]];
            NSString *source = dictionary[@"source"];
            UILabel *textLabel = [cell viewWithTag:103];
            UIImageView *imageView = [cell viewWithTag:102];
            UILabel *detailTextLabel = [cell viewWithTag:104];
            UISwitch *toggle = [cell viewWithTag:105];
            detailTextLabel.text = @"Click to view article";
            BOOL on = [sources indexOfObject:source] != NSNotFound;
            if (on && [sources count] == 1) {
                toggle.enabled = NO;
                [toggle removeTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            } else {
                toggle.enabled = YES;
                [toggle addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            }
            toggle.on = on;
            toggle.tag = 105 + [indexPath row];
            textLabel.text = dictionary[@"title"];
            UIImage *image = [UIImage imageNamed:source];
            imageView.image = image;
            imageView.layer.cornerRadius = imageView.frame.size.width / 2;
            imageView.layer.masksToBounds = YES;
            break;
        }
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return @"Summary Sources";
    } else {
        return @"";
    }
}

-(void)switchChanged:(UISwitch*)toggle {
    NSInteger rowChanged = toggle.tag - 105;
    NSString *source = [[article.articles objectAtIndex:rowChanged] objectForKey:@"source"];
    if (toggle.isOn) {
        if ([sources indexOfObject:source] == NSNotFound) {
            [sources addObject:source];
        }
    } else {
        [sources removeObject:source];
    }
    [self updateSources];
}

-(void)updateSources {
    [sources sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *sourceString = [NSString stringWithFormat:@"[%@]", [sources componentsJoinedByString:@","]];
    NSArray *text = [[article summaryMap] objectForKey:sourceString];
    self.navigationItem.title = @"";
    articleText = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in text) {
        [articleText addObject:dictionary[@"sentence"]];
    }
    [tv reloadData];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] < 2) {
        return nil;
    }
    if ([indexPath section] == 2) {
        if (!_summaryAnalysis) {
            return nil;
        }
    }
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 2) {
        _chosenSentence = [indexPath row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"showSources" sender:self];
    } else if ([indexPath section] == 3) {
        _chosenLink = [indexPath row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"showArticle" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSources"]) {
        SourceTableViewController *vc = (SourceTableViewController*)[segue destinationViewController];
        NSString *sourceString = [NSString stringWithFormat:@"[%@]", [sources componentsJoinedByString:@","]];
        NSArray *sentences = [[article summaryMap] objectForKey:sourceString];
        NSDictionary *sentence = [sentences objectAtIndex:_chosenSentence];
        vc.sentence = sentence;
    } else if ([[segue identifier] isEqualToString:@"showArticle"]) {
        NSDictionary *art = [[article articles] objectAtIndex:_chosenLink];
        WebViewController *vc = (WebViewController*) [segue destinationViewController];
        vc.url = art[@"articleUrl"];
        vc.source = art[@"source"];
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

- (IBAction)summaryAnalysisButtonClicked:(id)sender {
    if (_summaryAnalysis) {
        [_summaryAnalysisButton setTitle:@"Show Summary Analysis" forState:UIControlStateNormal];
    } else {
        [_summaryAnalysisButton setTitle:@"Hide Summary Analysis" forState:UIControlStateNormal];
    }
    _summaryAnalysis = !_summaryAnalysis;
    [tv reloadData];
}
@end
