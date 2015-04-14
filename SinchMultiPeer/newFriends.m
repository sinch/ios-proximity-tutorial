//
//  newFriends.m
//  SinchMultiPeer
//
//  Created by Zachary Brown on 31/03/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import "newFriends.h"
#import <Parse/Parse.h>
#import "friend.h"

@interface newFriends ()
@property (nonatomic, retain) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic, retain) MCSession *session;
@property (nonatomic, retain) MCPeerID *peerId;
@property (nonatomic, retain) MCBrowserViewController *browserViewController;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, weak) callScreen *theNewCallScreen;
@property (nonatomic, weak) incomingCall *theIncomingCallScreen;
@property (nonatomic, weak) NSString *remoteUserId;
@end
@implementation newFriends {
    id<SINClient> _client;
    id<SINCall> _call;
}
- (void)answer {;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _theNewCallScreen = (callScreen *)[storyboard instantiateViewControllerWithIdentifier:@"callScreen"];
    [_theNewCallScreen setDelegate:self];
    [self presentViewController:_theNewCallScreen animated:YES completion:nil];
    _theNewCallScreen.statusLabel.text = @"Connected";
    _theNewCallScreen.nameOfFriendLabel.text = _remoteUserId;
}
- (void)decline {
    [_call hangup];
}
- (void)hangUp {
    [_call hangup];
    if (_call == nil) {
        NSLog(@"Call = nil");
    }
    [_theNewCallScreen dismissViewControllerAnimated:YES completion:nil];
}
//allah akbard
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friends count];
}
- (IBAction)lout:(id)sender {
    [PFUser logOut];
    if ([PFUser currentUser]==nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [PFUser logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    call.delegate = self;
    _call = call;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _theIncomingCallScreen = (incomingCall *)[storyboard instantiateViewControllerWithIdentifier:@"incomingCall"];
    [self presentViewController:_theIncomingCallScreen animated:YES completion:nil];
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:call.remoteUserId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        _remoteUserId = object[@"name"];
    }];
    _theIncomingCallScreen.nameLabel.text = _remoteUserId;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    friend *myFriend = _friends[indexPath.row];
    UILabel *label = (UILabel*)[cell viewWithTag:1001];
    label.text = [NSString stringWithFormat:@"%@, %i", myFriend.name, myFriend.age];
    return cell;
    
}

//
- (void)viewDidLoad {
    _friends = [[NSMutableArray alloc] init];
    friend *friendz = [[friend alloc] init];
    friendz.name = @"zac";
    friendz.age = 12;
    [_friends addObject:friendz];
    [self setUpConnection];

    [self setupSinch];
    
}


- (void)setupSinch {
    _client = [Sinch clientWithApplicationKey:@"de420ee2-a973-499e-9650-c7bbbf867081"
                applicationSecret:@"Vzc1hkh/f0aRa6GOuNZrrg=="
                              environmentHost:@"sandbox.sinch.com"
                                       userId:_username];
    _client.callClient.delegate = self;
    [_client setSupportCalling:YES];
    [_client start];
    [_client startListeningOnActiveConnection];
}
- (IBAction)findFriends:(id)sender {
    [self presentViewController:self.browserViewController animated:YES completion:nil];
}

- (void)setUpConnection {
    PFUser *user = [PFUser currentUser];
    NSString *screenName = [user objectForKey:@"screenName"];
    _username = [user objectForKey:@"username"];
    NSString *age = [NSString stringWithFormat:@"%@", [user objectForKey:@"age"]];
    NSString *displayName = [NSString stringWithFormat:@"%@, %@", screenName, age];
    _peerId = [[MCPeerID alloc] initWithDisplayName:displayName];
    NSLog(@"PeerId = %@", _peerId);
    self.session = [[MCSession alloc] initWithPeer:self.peerId];
    self.session.delegate = self;
    
    self.browserViewController = [[MCBrowserViewController alloc] initWithServiceType:@"sinchMulti" session:self.session];
    self.browserViewController.delegate = self;
    
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"sinchMulti" discoveryInfo:nil session:self.session];
    [self.advertiserAssistant start];
}


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        [self sendUsername:peerID];
    }
}
- (void)sendUsername:(MCPeerID *)peerID {
    NSLog(@"PeerID = %@", peerID);
    PFUser *user = [PFUser currentUser];
    NSString *username = user.username;
    NSData *data = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:peerID];
    NSError *error = nil;
    if (![self.session sendData:data toPeers:array withMode:MCSessionSendDataReliable error:&error]) {
        NSLog(@"Error = %@", error);
    }
}
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSData *localData = data;
    NSString *username = [[NSString alloc] initWithData:localData encoding:NSUTF8StringEncoding];
    [self createFriend:username];
    //create sinch chat with username
}
- (void)createFriend:(NSString *)username {
    friend *newFriend = [[friend alloc] init];
    newFriend.username = username;
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"User"];
    [query whereKey:@"username" equalTo:newFriend.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            newFriend.name = [object objectForKey:@"screenName"];
            newFriend.age = [[object objectForKey:@"age"] intValue];
        }
    }];
    [_friends addObject:newFriend];
}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.browserViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.browserViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    friend *friendToCall = [_friends objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _theNewCallScreen = (callScreen *)[storyboard instantiateViewControllerWithIdentifier:@"callScreen"];
    [_theNewCallScreen setDelegate:self];
    [self presentViewController:_theNewCallScreen animated:YES completion:nil];
    _theNewCallScreen.statusLabel.text = @"Calling...";
    _theNewCallScreen.nameOfFriendLabel.text = friendToCall.name;
    [self placeCall:friendToCall.username];
    
}
- (void)placeCall:(NSString *)username {
    _call = [_client.callClient callUserWithId:@"zac"];
    _call.delegate = self;
}
- (void)callDidProgress:(id<SINCall>)call {
    
}
- (void)callDidEnd:(id<SINCall>)call {
    if (_theNewCallScreen != nil) {
        [_theNewCallScreen dismissViewControllerAnimated:YES completion:nil];
    } else {
        return;
    }
}
- (void)callDidEstablish:(id<SINCall>)call {
    _theNewCallScreen.statusLabel.text = @"Connected";
}

@end
