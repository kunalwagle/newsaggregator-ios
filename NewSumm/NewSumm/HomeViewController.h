//
//  ViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 04/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)searchClicked:(id)sender;


@end

