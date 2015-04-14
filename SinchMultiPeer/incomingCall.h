//
//  incomingCall.h
//  SinchMultiPeer
//
//  Created by Zachary Brown on 4/04/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IncomingCallDelegate <NSObject>

- (void)answer;
- (void)decline;
@end


@interface incomingCall : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomingCallLabel;

@property (nonatomic, weak) id<IncomingCallDelegate> delegate;
@end
