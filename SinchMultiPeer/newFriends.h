//
//  newFriends.h
//  SinchMultiPeer
//
//  Created by Zachary Brown on 31/03/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <Sinch/Sinch.h>
#import "callScreen.h"
#import "incomingCall.h"
@interface newFriends : UITableViewController <UITableViewDataSource, UITableViewDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, SINCallClientDelegate, SINCallDelegate, callScreenDelegate, IncomingCallDelegate>

@end
