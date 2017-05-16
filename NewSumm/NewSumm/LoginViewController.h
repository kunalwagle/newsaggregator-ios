//
//  LoginViewController.h
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTopicsViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (nonatomic, weak) id<LoginDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property CGFloat animatedDistance;
- (IBAction)registerClicked:(id)sender;
- (IBAction)cancel:(id)sender;

@end
