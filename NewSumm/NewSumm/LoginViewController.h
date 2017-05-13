//
//  LoginViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property CGFloat animatedDistance;
- (IBAction)registerClicked:(id)sender;
- (IBAction)cancel:(id)sender;

@end
