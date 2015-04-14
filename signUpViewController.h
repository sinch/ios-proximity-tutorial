//
//  signUpViewController.h
//  SinchMultiPeer
//
//  Created by Zachary Brown on 31/03/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUpViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *screenName;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@end
