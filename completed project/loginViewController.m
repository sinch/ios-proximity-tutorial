//
//  loginViewController.m
//  SinchMultiPeer
//
//  Created by Zachary Brown on 31/03/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import "loginViewController.h"
#import <Parse/Parse.h>

@implementation loginViewController {
    BOOL loggedIn;
}
- (void)viewWillAppear:(BOOL)animated {
    _usernameField.delegate = self;
    _passwordField.delegate = self;
}
- (IBAction)login:(id)sender {
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error) {
            loggedIn = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@, Please try again", [error userInfo][@"error"]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            NSLog(@"Logged in");
            _usernameField.text = @"";
            _passwordField.text = @"";
            loggedIn = YES;
            [self performSegueWithIdentifier:@"loggedIn" sender:@"logIn"];
            loggedIn = NO;
        }
    }];
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"loggedIn"]) {
    if (loggedIn) {
        return YES;
    } else {
        return NO;
    }
    } else {
        return YES;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    return YES;
}
@end
