//
//  signUpViewController.m
//  SinchMultiPeer
//
//  Created by Zachary Brown on 31/03/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import "signUpViewController.h"
#import <Parse/Parse.h>
@implementation signUpViewController{
    BOOL signedUp;
}
- (void)viewDidLoad {
    signedUp = NO;
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    _screenName.delegate = self;
}
- (IBAction)signUp:(id)sender {
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    NSString *screenName = _screenName.text;
    int age = [_ageField.text intValue];
    
    PFUser *user = [[PFUser alloc] init];
    user.username = username;
    user.password = password;
    user[@"age"] = @(age);
    user[@"screenName"] = screenName;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            signedUp = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@, Please try again", [error userInfo][@"error"]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            signedUp = YES;
            //this
            [self clearTextFields];
            [self performSegueWithIdentifier:@"signedUp" sender:nil];
        }
    }];
}
- (void)clearTextFields {
    //this
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.screenName.text = @"";
    self.ageField.text = @"";
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (signedUp) {
        return YES;
    } else {
        return NO;
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
@end
