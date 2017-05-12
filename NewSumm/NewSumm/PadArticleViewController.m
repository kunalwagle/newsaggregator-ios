//
//  PadArticleViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 10/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "PadArticleViewController.h"
#import "UtilityMethods.h"
#import "SourceTableViewController.h"
#import "WebViewController.h"

@interface PadArticleViewController ()

@end

@implementation PadArticleViewController

@synthesize articleTableView;
@synthesize sourceTableView;
@synthesize article;
@synthesize articleText;
@synthesize topicName;
@synthesize sources;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sources = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in article.articles) {
        [sources addObject:[dictionary objectForKey:@"source"]];
    }
    [self updateSources];
    articleTableView.estimatedRowHeight = 260;
    articleTableView.rowHeight = UITableViewAutomaticDimension;
    sourceTableView.estimatedRowHeight = 260;
    sourceTableView.rowHeight = UITableViewAutomaticDimension;
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
    [articleTableView reloadData];
    [sourceTableView reloadData];
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
        toggle.onTintColor = [UtilityMethods getColour:source];
        toggle.on = on;
        toggle.tag = 105 + [indexPath row];
        textLabel.text = dictionary[@"title"];
        UIImage *image = [UIImage imageNamed:source];
        imageView.image = image;
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==articleTableView && [indexPath section] != 2) {
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
        _chosenSentence = indexPath;
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
        UINavigationController *navController = [segue destinationViewController];
        SourceTableViewController *vc = (SourceTableViewController*)[navController viewControllers][0];
        NSString *sourceString = [NSString stringWithFormat:@"[%@]", [sources componentsJoinedByString:@","]];
        NSArray *sentences = [[article summaryMap] objectForKey:sourceString];
        NSDictionary *sentence = [sentences objectAtIndex:[_chosenSentence row]];
        vc.sentence = sentence;
        CGRect selectedCellRect = [articleTableView rectForRowAtIndexPath:_chosenSentence];
        selectedCellRect.size.width = selectedCellRect.size.width/6;
        navController.popoverPresentationController.sourceRect = selectedCellRect;
    } else if ([[segue identifier] isEqualToString:@"showArticle"]) {
        NSDictionary *art = [[article articles] objectAtIndex:_chosenLink];
        WebViewController *vc = (WebViewController*) [segue destinationViewController];
        vc.url = art[@"articleUrl"];
        vc.source = art[@"source"];
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

- (IBAction)summaryAnalysis:(id)sender {
    if (_summaryAnalysis) {
        [_summaryAnalysisButton setTitle:@"Show Summary Analysis" forState:UIControlStateNormal];
    } else {
        [_summaryAnalysisButton setTitle:@"Hide Summary Analysis" forState:UIControlStateNormal];
    }
    _summaryAnalysis = !_summaryAnalysis;
    [articleTableView reloadData];
    [sourceTableView reloadData];
}
@end
