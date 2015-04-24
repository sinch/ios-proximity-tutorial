//
//  incomingCall.m
//  SinchMultiPeer
//
//  Created by Zachary Brown on 4/04/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import "incomingCall.h"

@implementation incomingCall
- (IBAction)answerCall:(id)sender {
    //delegate answer method
    [self.delegate answer];
    
    NSLog(@"Answer");
}
- (IBAction)declineCall:(id)sender {
    //delegate answer method
    [self.delegate decline];
}

@end
