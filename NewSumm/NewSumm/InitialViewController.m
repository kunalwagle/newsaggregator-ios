//
//  InitialViewController.m
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "InitialViewController.h"
#import "UtilityMethods.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ([UtilityMethods isIPad]) {
        [self performSegueWithIdentifier:@"iPad" sender:self];
    } else {
        [self performSegueWithIdentifier:@"iPhone" sender:self];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
