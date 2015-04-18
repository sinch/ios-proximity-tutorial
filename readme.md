

© Zac Brown 2015

Sinch(website link) is the easiest way to integrate real-time instant messaging and voice communication into your iOS, Android and Web applications. Not only does it allow app to app communications, there’s also the option to send SMS’s and make voice calls from within an application to cellular networks. Sinch can easily be added to your project using the SDK for your platform or the Sinch API, Sinch is also now fully compatible with 64-bit architecture on iOS! 

Today’s project will be to integrate Sinch into an iOS application which will match users with other users nearby using Apple’s multipeer connectivity framework. This will be achieved by exchanging userId’s once a connection is established between two devices and then allowing those two users to call eachother anywhere and at any time using Sinch! This application will also utilise Parse as a means of managing users and storing some basic data.

To complete this tutorial you will need some basic objective-c language knowledge, it's very in-depth and we hope that beginners and intermediate developers are all able to complete this tutorial.

Just for some quick insight, here’s the basic concepts behind the multipeer connectivity framework. This framework utilises pre-existing Wi-Fi networks and bluetooth to connect one iOS device to another. The platform itself has provisions for the transfer of various file types and also has the ability to stream data from one device to another. Apples AirDrop platform is presumably built on none other than the multi peer framework!

To get started download the starter project(link to gitgub repo) which contains all the storyboards and view controllers to complete this tutorial, along the way you may be required to add a few classes though. Once you’ve opened the project in Xcode, navigate to www.parse.com. You will need to sign up for a free account, create a project, download the iOS SDK(link to download page) and then use the quick start guide to acquire your APP ID and Client ID. Once you’ve got those head over to the Xcode project. 

Please note that this projects storyboards are made to suit an iPhone 5S however size classes can be added to make it universal. We recommend using the iPhone 5S simulator to avoid unecessary display issues. 

First add the Parse framework from your downloads folder (or from wherever you may have saved it) to your project, it's best to select 'copy items if needed' when adding third party frameworks. You will now need to add some local frameworks to ensure the Parse framework has the resources to work properly. In the left hand column of xcode, navigate to the project settings and down the bottom of the page you will find a section labelled Linked Frameworks and Libraries. Click the plus symbol and add these frameworks…	

* AudioToolbox.framework
* CFNetwork.framework
* CoreGraphics.framework
* CoreLocation.framework
* MobileCoreServices.framework
* QuartzCore.framework
* Security.framework
* StoreKit.framework
* SystemConfiguration.framework
* libz.dylib
* libsqlite3.dylib

You’re now ready to start coding, navigate over to the AppDelegate.m file. Below ‘#import “AppDelegate.h” you want to import the Parse framework so that you can start using it, add this code.

```objective-c

			#import <Parse.Parse.h>
			
```
That will import the framework and now you can use it in the Appdelegate, now navigate to the method didFinishLaunchingWithOptions and add this code which I’ll explain below.

```objective-c
		
		[Parse setApplicationId:@"YOUR-PARSE-APP-ID" clientKey:@"PARSE-CLIENT-KEY"];
		
```

This code simply initialises parse with your individual application ID’s, make sure they’re correct or else you’re going to have some trouble! The didFinishLaunchingWithOptions is your first and best chance at initialising these third party frameworks.

Now navigate to loginViewController.m where we will get to work on implementing Parse login. Once again import the parse framework into the file. Add this code to the login method already in place (the IBAction method is connected to the login button) to allow your users to log in, don’t worry we will make a sign up screen next!
```objective-c

	@implementation loginViewController {
    BOOL loggedIn; 
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
            loggedIn = YES;
            [self performSegueWithIdentifier:@"loggedIn" sender:nil];
        }
    }];}
	- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (loggedIn) {
        return YES;
    } else {
        return NO;
    	}
	}
	@end

	
```
Here you can see I’ve added a loggedIn BOOL to the instance variables of the class which is used to determine wether the login was successful when shouldPerformSegueWithIdentifier is called. Besides that I’ve just followed Parse’s login protocol as outlined in their docs, as this is a tutorial I will briefly explain what’s going on. 

For simplicity I’ve created some local NSStrings which relate to the text from the two textField properties as outlined in the .h file. From those I’ve called PFUser login, inputted the two variables and then used a block to determine the outcome. This is all very simple and Xcode autocompletes the majority of the method. In the block, if there’s an error we set loggedIn to no and display an alert but if it’s successful we set loggedIn to YES and go ahead and call for a segue. 

Moving on!

At the moment users can login and be presented with the newFriends view controller but it isn't currently possible for them to sign up, it's time to back-track and add some sign-up functionality. 

Head on over to signUpViewController.m and once again import the parse framework.
```objective-c

	#import <Parse/Parse.h>
	
```

Now we will add some methods that are very similar to what we did in the login view controller, once again I’ve created some local NSString’s that are local copies of the text extracted from the username, password, screen name and age textfields.
```objective-c

	@implementation signUpViewController{
    BOOL signedUp; 
    }
	- (IBAction)signUp:(id)sender {
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    int age = [_ageField.text intValue];
    NSString *screenName = _screenName.text;
    
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
            [self performSegueWithIdentifier:@"signedUp" sender:nil];
        }
    }];}
	- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (signedUp) {
        return YES;
    } else {
        return NO;
    	}
	}
	@end
	
```
It’s good practice to run the code in the iOS simulator after each new feature is added to ensure you don’t have any bugs in the code. It’s much easier to track them after you’ve added a new feature or you could end up finishing a project and spending a great deal of time looking for the bugs!

After testing this you will already recognise a small issue, although there’s nothing wrong with the code you will see that there is no way to dismiss the keyboard when attempting to press the login/signup buttons and the buttons aren't visible unless they keyboard is dismissed. It’s pretty simple to fix this, keep in mind that simple problems like this can make or a break an app!

Add this method into both the loginViewController and signupViewController implementation files.
```objective-c

	- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
	}
	
```

Go ahead and test this, you will find that it won’t work but there’s an easy fix to this! You need to set the delegate of the text fields to self, this is an example from the login view controller.

```objective-c

	- (void)viewWillAppear:(BOOL)animated {
    _usernameField.delegate = self;
    _passwordField.delegate = self;
	}
	
```
I chose to put the logic within the viewWillAppear method as it’s a given that the method will execute. Delegates are very important and it’s important to be familiar with them prior to starting the implementation of parse into our project later on in the tutorial. 

Now go ahead and do the same in the signup view controller, keep in mind that there's four text field's that need to have their delegates set. 

Although we can login and signup at this point, there isn’t much else we can do. So, now it’s time to get to work. First we will find some friends using the multi-peer framework and then we will work out how to connect with them using the Sinch SDK. 

Before we get to work take a quick look at the storyboard, it's like our roadmap! From our login/signup view controllers you will see a navigation controller, embedded in our navigation controller is our view controller titled 'Chats' which is connected to the newFriends class. Both our multipeer and sinch frameworks will be implemented here. From there we have two view controllers, our call screen and our incoming call screen. Those should be pretty self explanatory, they're both connected to their respctive classes.  

The first step to adding multi peer connectivity is to add the framework, this can be done in the same place we added all of those frameworks earlier on. Once you’ve done that head over to newFriends.m and import the framework, like this
```objective-c

	#import <MultipeerConnectivity/MultipeerConnectivity.h>
	
```

First we need to create some properties in the interface section of newFriends.m as you can see here

```objective-c

	@interface newFriends ()
	@property (nonatomic, retain) MCAdvertiserAssistant *advertiserAssistant;
	@property (nonatomic, retain) MCSession *session;
	@property (nonatomic, retain) MCPeerID *peerId;
	@property (nonatomic, retain) MCBrowserViewController *browserViewController;
	@end
	
```
	
Here’s a quick run-down of what each property is used for
MCAdvertiserAssistant
Makes your device visible to others whilst also managing incoming connections.

MCSession
Enables and manages connections between your device and your peer’s device.

MCPeerID
A reference for a peer in a session.

MCBrowserViewController
A view controller provided by apple which will present a list of nearby users.

At this point you will need to head over to the newFriend.h file and set this class as a delegate for the MCBrowserViewController and MCSession. This can be achieved by modifying the following line from this 
```objective-c
	
	@interface newFriends : UITableViewController
	
```

To this
```objective-c
	
	@interface newFriends : UITableViewController <MCBrowserViewControllerDelegate, MCSessionDelegate>
	
```
	
Easy! (all we're doing is saying that the newFriends class conforms to the delegate protocol)

Now you will see a heap of new warnings to let us know that we haven’t yet implemented the delegate methods, don’t worry as that’s our next step.

Here’s all the delegate methods we need to implement with a brief description of each below.

```objective-c

	- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{  
	
	}
	
```
	

Called when the users device changes state, either connects/disconnects 				from a peer or when a peer connects to the user

```objective-c
	
	- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:	(MCPeerID *)peerID { 
	
	}
	
```
	
Called when the device receives data from a peer

```objective-c

	- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
	
	}
	
```

Called when the device receives a stream from a peer.

```objective-c

	- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
	
	}
	
```

Called when the device receives something from a peer

```objective-c
	
	- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString 	*)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError 	*)error { 
	
	}
```
Called when the device has finished receiving a resource

```objective-c
	
	- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
	}
	
```

Called when the user chooses a peer to connect to


```objective-c
	
	- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController { 
	
	}
	
```

Called when the user cancels the MCBrowserViewController


Whilst still in newFriends.m add this method above the delegate methods.

```objective-c 

	- (void)setUpConnection {
    PFUser *user = [PFUser currentUser];
    NSString *screenName = [user objectForKey:@"screenName"];
    _username = [user objectForKey:@"username"];
    NSString *age = [NSString stringWithFormat:@"%@", [user objectForKey:@"age"]];
    NSString *displayName = [NSString stringWithFormat:@"%@, %@", screenName, age];
    _peerId = [[MCPeerID alloc] initWithDisplayName:displayName];
    NSLog(@"PeerId = %@", _peerId);
	}
	
```

Here we get the current PFUser object from parse and from that we get the screenName as set by the user when s, instead of displaying the device name we can display the users name which is far more personalised and can be changed as different users login. We then set the peerId display name equal to our screenName variable.

We now need to go ahead and create a session, add this code to the bottom of the method we created above.
```objective-c

	  self.session = [[MCSession alloc] initWithPeer:self.peerId];
    		 self.session.delegate = self;
    		 
  ```

Here we’re simply using the session property we created in the @interface of the file, allocating and calling initWithPeer and using the peerId we previously created. Then we go ahead and set the delegate equal to self so that we’re able to get information from the session.

There’s one last step to finish off this method, we need to put everything together and create a browserViewController. Here’s how simple it is!
```objective-c
	
		self.browserViewController = [[MCBrowserViewController alloc] 							initWithServiceType:@"sinchMulti" session:self.session];
       self.browserViewController.delegate = self;
       
```
We’ve allocated and called initWithService, we’ve used the name sinchMulti for this project, then we’ve simply gone ahead and set the session equal to the session we created earlier. Once again we’ve set the delegate to self so we can be informed of what’s going on.

Although now we can find other users there’s one thing we’ve forgotten, it isn’t much fun if people can’t find us is it? Let’s go ahead and make our device discoverable, for this we need to use the advertiserAssistant. Once again we’re going to add it on to the bottom of the setUpConnection method.
```objective-c
	
	self.advertiserAssistant = [[MCAdvertiserAssistant alloc] 						initWithServiceType:@"sinchMulti" discoveryInfo:nil session:self.session];
    [self.advertiserAssistant start];
   
```
 
This is some really simple code, once again we’re allocating and calling initWithService which we did earlier, we’ve set the discoverInfo to nil and yet again we’ve associated our session we already created with the advertiserAssistant. The last line of code is probably the easiest part of this tutorial and I think it’s pretty self explanatory :P

The finished setUpConnection method should look like this.

```objective-c
	
		- (void)setUpConnection {
    PFUser *user = [PFUser currentUser];
    NSString *screenName = [user objectForKey:@"screenName"];
    _peerId = [[MCPeerID alloc] initWithDisplayName:screenName];
    
    self.session = [[MCSession alloc] initWithPeer:self.peerId];
    self.session.delegate = self;
    
    self.browserViewController = [[MCBrowserViewController alloc] initWithServiceType:@"sinchMulti" session:self.session];
    self.browserViewController.delegate = self;

	self.advertiserAssistant = [[MCAdvertiserAssistant alloc] 						initWithServiceType:@"sinchMulti" discoveryInfo:nil 	session:self.session];
    [self.advertiserAssistant start];
	}
	
```

This code is looking pretty good, there’s only one small problem. Can you see it? If you said this code isn’t being executed because nowhere in the code has it been called you’re correct! It’s best to call this method from viewDidLoad, as I mentioned earlier it’s a given that this method is going to be called.
		```objective-c
		
		- (void)viewDidLoad {
    			[self setUpConnection];
    			
		}
		
```

As you can probably see there's an error relating to the username property not being declared, go ahead and declare it in the @interface of newFriends.m, make it of type NSString and weak/nonatomic. This property will be used throughout the software so it's best to have it globally accessible. 

We’ve made some good progress but currently there’s no way to present the browserViewController, we’ve included a + bar button in the template file and connected an action to it. In the method simply include this code to present the browserViewController when the button is triggered.

```objective-c
	- (IBAction)findFriends:(id)sender {
    [self presentViewController:self.browserViewController animated:YES completion:nil];
    
	}

```

Now we’ve established a connection between the device we need a way to exchange usernames and then connect the two devices using sinch. First we will send the two usernames and have iOS handle the data and create a conversation for us.

With the multiplier framework we can send three types of data. Messages which are short pieces of text, streams that allow data such audio or video to be continuously sent real-time and resources which are local images, movies or documents. For the purpose of this tutorial we will be sending a message, contained in this message will be each users username. Although we could solely use the multipeer framework to chat, once you were to move out of range from the other device your connection would be lost and you’d have no way to connect with them :( That’s why we’re using Sinch.

If you go ahead and hit the + button you should be presented with the browserViewController, you may also notice that there’s no way to get back to the original view. This can easily be fixed by adding in the dismissViewController method into the two delegate methods of browserViewController in the newFriends.m file. Make sure to add this line of code to both methods.

```objective-c

	[self.browserViewController dismissViewControllerAnimated:YES completion:nil];
```

There’s two delegate methods here, one that is called when the browserViewController is canceled and one when the user presses the done button. Initially the done button is disabled and only enabled when the user connects to another device. 

We’re now going to head over and do some minor editing to the delegate method didChangeState.

```objective-c

	- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        [self sendUsername:peerID];
    }
}

```

What we’re doing here is seeing if the change to state is a connection being made, if it is then we want to call the method sendUsername and pass along the PeerId of that user. Go ahead and declare the sendUsername method, make it return void and of course make it take a single MCPeerID variable.

```objective-c

	- (void)sendUsername:(MCPeerID *)peerID {
			
	}
```

Now let’s add some logic to the method. Just to be clear, we want to send out own username from parse so that the recipient is then able to connect and send us message through sinch and vice versa. Add this code…

```objective-c

    PFUser *user = [PFUser currentUser];
    NSString *username = user.username;
    NSData *data = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:peerID];
    NSError *error = nil;
    if (![self.session sendData:data toPeers:array withMode:MCSessionSendDataReliable error:&error]) {
        NSLog(@"Error = %@", error);
    }
```

First we create an instance of PFUser (parse) and get a reference to the current user, from this we get the username and store it in a local NSString. We then create a NSData object and store the username in it. From this we create a mutable array, store the peerID of the intended recipient in it and the call the sendData method. Notice we’ve opted for MCSessionSendDataReliable for the mode, this simply means it will take a little longer to transmit the data but there’s little chance of the data being lost in transit! We’re only transmitting a few bytes of data so there isn’t much to worry about. Now that we’re transmitting data, we need to make sure that we’re also equipped to receive any data sent out way.









As we’re making this app we can expect the only data that’s going to be sent our way is a single userId although keep in mind some applications could have many different variables being transmitted. There’s a delegate method already in our .m file that we can use to manage received data. Head over to the didReceiveData delegate method and we will work from there.

```objective-c 

			- (void)session:(MCSession *)session didReceiveData:(NSData *)data 					fromPeer:(MCPeerID *)peerID {

			}
```

Now add this logic into the method.

```objective-c

			NSData *localData = data;
    			NSString *username = [[NSString alloc] initWithData:localData 						encoding:NSUTF8StringEncoding];
			[self createFriend:username];
```

As you can see we’ve added yet another method, createFriend which is used to fetch extra details from parse and create a friend using those objects. Here’s the createFriend method. Although you may think at this point, what friend object? Ahh, the one we’re about to create, create a new class of type NSObject and name it friend. Add these three properties in the .h file.

```objective-c

			@property (nonatomic, weak) NSString *name;
			@property (nonatomic, weak) NSString *username;
			@property (nonatomic) int age;
```

Now we’re ready to go back and create the createFriend method which utilises our new class, remember to #import the new class or else you might have a bit of trouble.
```objective-c

			- (void)createFriend:(NSString *)username {
    				friend *newFriend = [[friend alloc] init];
    				newFriend.username = username;
    				PFQuery *query = [[PFQuery alloc] initWithClassName:@"User"];
    				[query whereKey:@"username" equalTo:newFriend.username];
    				[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, 						NSError *error) {
        	if (!error) {
            		newFriend.name = [object objectForKey:@"screenName"];
            		newFriend.age = [[object objectForKey:@"age"] intValue];
        }
    }];
	}
```

First we create an instance of friend, then we set the username property on the friend object, at the current point in time that’s the only variable we know the valuable of. We then go on to create a query, Why? Well we’ve got the username so we’re now able to get the rest of that users information directly from parse. We do this by specifying that we want the username key to be equal to our friends username. We then call getFirstObjectInBackgroundWithBlock, it’s expected that there’s only going to one object matching our query parameters so it makes sense to only get the first. In our block we check whether there’s an error, if not we go ahead and assign the rest of the variables for the friend object. This is all very good but there’s one thing missing… Do you know what it is? Well we have no place to keep our friends of course, let’s create a mutable array to hold our friends. We can create a property like this at the top of our .m file in the @interface section.

```objective-c  

		@interface newFriends ()
				..
	  @property (nonatomic, retain) NSMutableArray *friends;
	  @end
```
	  
Now we must use the viewDidLoad method to allocated the memory and initiate the object so it’s ready for use, if we don’t then we won’t have many friends sticking around. The best place to do this is in the viewDidLoad method.

```objective-c

		- (void)viewDidLoad {
   				
    	_friends = [[NSMutableArray alloc] init];
		}
```
	
Now the easy bit, at the end of the createFriend method add this easy one liner!

```objective-c

	[_friends addObject:newFriend];
```

Now that we’ve got some friends it’s time to make them visible! As you can already see we’ve got a table view which has prototype cells that are made to do the job, all we have to do is set delegates and present the data to our table view. Firstly in newFriends.h we need to set the delegates, modify the @interface line to match this.

```objective-c

		@interface newFriends : UITableViewController <UITableViewDataSource, 				UITableViewDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate>
```
		
As you can see we’ve made two additions, we’ve set this class as the Data source and the delegate for our table view. Now we can move over and start modifying the .m counterpart. 

We need to implement two delegate methods to feed data to the view controller. First we can implement numberOfRowsInSection, for this we simply need to return the number of rows we will need in the table view which will be determined by the number of friends we’ve got.

```objective-c

		- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:				(NSInteger)section
			{
    				return [_friends count];
			}
```
			
That’s the simple part! Next we’ve got to implement the delegate method cellForRowAtIndexPath. This method is called to set up each individual cell. Implement it like so!
```objective-c

		- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:			(NSIndexPath *)indexPath
	{
    		static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    		UITableViewCell *cell = [tableView 										dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 				reuseIdentifier:simpleTableIdentifier];
    }
    friend *myFriend = _friends[indexPath.row];
    UILabel *label = (UILabel*)[cell viewWithTag:1001];
    label.text = [NSString stringWithFormat:@"%@, %i", myFriend.name, myFriend.age];
    return cell;
	}
```

Everything that’s being done here is pretty standard objective c, take note that we’re bringing a ‘friend’ object into memory from the friends array. We’re able to access the specific friend object by its index in the friends array, we’re using indexPath.row to access each index.

add frameworks for sinch 
Set delegates on call screen and import framework in .h file

By now we’ve got friends in our friends array, we’re able to display them and now we need to work on making contact. We will be doing this with Sinch, the first thing to do is sign up for Sinch if you don’t already have an account. Once you’ve got an account simply access the dashboard and create a new project, make sure that once you’ve created the project you take note of the specific project keys. Now head over and download the latest version of the Sinch framework, there’s the option to use Cocoapods but today we’re going to be downloading the files and manually adding them to the xcode project.

Once you’ve downloaded the framework, import it into your project and make sure that ‘Copy files if needed’ is ticked. Before Sinch will happily work we have to make one small mod to the build settings. In the project settings navigate to build settings and in the search box type ‘other linker’ and you should be presented with the field ‘Other linker flags’. You simply want to add ‘-ObjC -Xlinker -lc++’ to the field, please note this isn’t required when using cocoapods. 

Now we’re ready to get to work implementing Sinch into our project. First we need to establish where the implementation for Sinch should be made. In this project it makes the most sense to put all of the Sinch methods in the newFriends class and the have it act as a delegate to other classes. The two other classes that are going to delegate back to newFriends are callView and incomingCall. First we need to implement all of the delegate methods for Sinch into the newFriends.m file but once again before we do it’s essential to #import <Sinch/Sinch.h>.

Now we need to initiate the Sinch client, in viewDidLoad call [self setupSinch]; and create a method named setupSinch which returns void. Before we go any further create an instance variable of type id as outlined below.

```objective-c

		id<SINClient>_client;
```

Now we can finish off the setupSinch method.

```objective-c

	- (void)setupSinch {
    		_client = [Sinch clientWithApplicationKey:@“application-id"
                applicationSecret:@“application-secret"
                              environmentHost:@"sandbox.sinch.com"
                                       userId:_username];
    		_client.callClient.delegate = self;
    		[_client setSupportCalling:YES];
    		[_client start];
    		[_client startListeningOnActiveConnection];
	}
```

This is standard client implementation for sinch, first we set _client equal to our application and application secret keys which can be obtained from the Sinch dashboard. For testing purposes all apps will be in the environmentHost of sandbox.sinch.com.
We also set the client userId equal to the _username property. This property is set when we call setupConnection in viewDidLoad, refer back to that method if you don’t understand. Next we set the delegate and then set support calling to YES, if we we were going to allow instant messaging within our app we would call [_client setSupportMessaging:YES];. We would then start the client and begin listening for incoming calls!

Now that we’ve moved on to the implementation of Sinch, let’s work out the easiest way to work through the problems in front of us. Here’s the functionality we need to add…

* Making calls to selected user
* Answering calls from other users
* Declining calls from other users

Let’s first work on making calls, to do this we’re going to allow users to select a user from the friends table view. From there a segue will occur and the user will be presented with the callScreen view controller. From there we will need to set some properties before the view controller is presented and then set some delegates so that our users are able to hang up. 

To allow users to select a friend from the table view controller we need to implement the delegate method didSelectRowAtIndexPath. Before we go ahead and implement the delegate method it’s best to plan out what needs to be done in plain english for a better understanding. First when the user selects the table view cell, a method will be called to present the callScreen view controller with the status set as calling. From the newFriends view controller we will then have to call some Sinch delegate methods, first we will have to create a callUser method and then we will have to check wether the callDidEstablish method is called and if it is then we will want to change the status of the call. Before moving forward let’s import the callScreen view controller as we’re going to need to access that when performing segues, we also need to create an instance variable for the call!

```objective-c

	#import "callScreen.h"
			…
	@implementation newFriends {
	
    id<SINClient>_client;
    id<SINCall>_call;
	}
```

Notice that we just added the _call variable to our project, this will be our go to reference when making calls. Now it’s time to implement didSelectRowAtIndex.
```objective-c

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    friend *friendToCall = [_friends objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    callScreen *newCall = (callScreen *)[storyboard instantiateViewControllerWithIdentifier:@"callScreen"];
    [self presentViewController:newCall animated:YES completion:nil];
    newCall.statusLabel.text = @"Calling...";
    newCall.nameOfFriendLabel.text = friendToCall.name;
    
    [self placeCall:friendToCall.username];
	}
```
Most of this should make sense but i’ll briefly summarise it for those that don’t. Firstly we get a friend object from the _friends array by using the array index which should align with indexPath.row. We then create a reference to our storyboard, create an instance of our newCall view controller and instantiate it with the view controller ID from our storyboard. We then present and set up our view controller. You will see a new method at the bottom, that should be throwing an error at the moment so let’s create that method and clear that error.

```objective-c

	- (void)placeCall:(NSString *)username {
    		_call = [_client.callClient callUserWithId:username];
    		_call.delegate = self;
	}
```
This is a really simple method and all pretty self explanatory, but once we make this call what happens? How do we know if we’re connected or not? Well, lucky for us there’s three delegate methods we can use to establish what’s happening! These three methods are callDidProgress, callDidEstablish and callDidEnd. Go ahead and add all of these methods to the newFriends.m file.

```objective-c

	- (void)callDidProgress:(id<SINCall>)call {
    
	}
	- (void)callDidEnd:(id<SINCall>)call {
    
	}
	- (void)callDidEstablish:(id<SINCall>)call {
    
	}
```

Call did progress is where you could play a ring tone or update the UI, feel free to do that as we won’t be delving into anything of that sort today! We will however make some modifications to the other two delegate methods. First we need to work out a way to access the instance of callScreen from anywhere within our code, how do we do this? The best/easiest way would be to make a property for callScreen. Go ahead and make a property in newFriends.m for callScreen, make it weak!
```objective-c

	@property (nonatomic, weak) callScreen *theNewCallScreen;
```

Now we need to go back to didSelectRowAtIndexPath and use the property instead of local variable to declare the callScreen view controller. 
```objective-c

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    friend *friendToCall = [_friends objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _theNewCallScreen = (callScreen *)[storyboard instantiateViewControllerWithIdentifier:@"callScreen"];
    [self presentViewController:_theNewCallScreen animated:YES completion:nil];
    _theNewCallScreen.statusLabel.text = @"Calling...";
    _theNewCallScreen.nameOfFriendLabel.text = friendToCall.name;
    
    [self placeCall:friendToCall.username];
    
	}
```

Now we’re ready to head back over and start working with callDidEstablish. 
```objective-c

	- (void)callDidEstablish:(id<SINCall>)call {
    _theNewCallScreen.statusLabel.text = @"Connected";
	}
```
Here we’re simply changing the status when the call is connected, easy stuff!

Now let’s work with callDidEnd. There’s two occasions when this method could be called, when the other user ends the call or when this particular user ends the call. Let’s work on the first scenario.
```objective-c

	- (void)callDidEnd:(id<SINCall>)call {
    if (_theNewCallScreen != nil) {
        [_theNewCallScreen dismissViewControllerAnimated:YES completion:nil];
    		}
	}
```

Here we’re saying that if the newCall view controller does NOT equal nil then go ahead and dismiss it. Now we need to figure out what to do if the local users decides to end the call. Go ahead and add an ‘else’ condition that simply calls return. Why? Well if the newCall screen already equals nil there isn’t much point trying to dismiss it again. 

Now let’s figure out what to do if the user decides to hang up in the callScreen view controller. Here it makes the most sense to use a delegate method. Head over to callScreen.m and let’s start modifying the hangUp method which we’ve already connected to the button in your storyboard.


In the hangUp method call hangUp on self.delegate like this…
```objective-c

	[self.delegate hangUp];
```
Of course at this point there will be a number of errors, not to worry it’s a work in progress. 

Now in the callScreen.h we need to finish implementing the delegate. Make a property of type id, weak and named delegate. 
```objective-c

	@property (nonatomic, weak)  id<callScreenDelegate>delegate;
```

Once again an error will appear as we haven’t yet implemented the callScreenDelegate protocol, go ahead and declare the protocol below the #import in callScreen.h with the single hangUp method.

```objective-c

	@protocol callScreenDelegate <NSObject>

		- (void)hangUp;

	@end
```
Now we need to modify the @interface line in newFriends.h to declare that this class conforms to the callScreenDelegate protocol. 

```objective-c

	@interface newFriends : UITableViewController <UITableViewDataSource, 				UITableViewDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, 					SINCallClientDelegate, SINCallDelegate, callScreenDelegate>
```

Head over to the .m counterpart and implement the hangUp method. There’s two things that this method will need to achieve, firstly it will need to call hangup with Sinch and secondly it’ll need to dismiss the callScreen view controller. Here’s what the hangUp method should look like in newFriends.m.

```objective-c

	- (void)hangUp {
    		[_call hangup];
    		[_theNewCallScreen dismissViewControllerAnimated:YES completion:nil];
	}
```
Hanging up the call is easy as! From there we simply call dismissViewController on theNewCallScreen so that we’re back to our table view controller. 

As amazing as all this is, there’s one thing that we can’t do and it severely limited our application. Now it’s time to put the icing on the cake by allowing users to answer calls. Add the following method to newFriends.m
```objective-c

		- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call 	{
    
	}
```
Before we implement the rest of the code to make the magic happen there’s some groundwork to cover. For this we will need to #import incomingCall.h, we’ve been nice enough to create the class and connect it to the relevant storyboard for you already!

When there’s an incoming call we’re going to present the incomingCall view controller, from there the user will be given the option to either answer or decline the call. The answer and decline function will once again be implemented using delegates, if a user chooses to answer a call we will go ahead and present the callScreen!

Within didReceiveIncomingCall let’s add the necessary code to present the incomingCall screen. 
```objective-c

	- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    			_theIncomingCallScreen = (incomingCall *)[storyboard 								instantiateViewControllerWithIdentifier:@"incomingCall"];
    			[self presentViewController:_theIncomingCallScreen animated:YES 					completion:nil];
		}
```

We’ve done this all before so no explanation necessary. At the top of this method we want to set our call delegate and set the call property equal to our incoming call, add this above the storyboard declaration. 

```objective-c

		call.delegate = self;
    		_call = call;
```

We can currently access the remoteUserId from the call object, but do we want to present the username or the persons name? Well it makes more sense to present the persons name if you ask me. Let’s use parse to find the corresponding name of a user given the username. Here’s the code to add in to the bottom of the didReceiveIncomingCall method. As you can see we haven’t previously declared remoteUserId so go ahead and create a property in the .m file of type NSString to store the name of the user that’s calling us.

```objective-c

		PFQuery *query = [PFQuery queryWithClassName:@"User"];
    		[query whereKey:@"username" equalTo:call.remoteUserId];
    		[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        _remoteUserId = object[@"name"];
    		}];
    		_theIncomingCallScreen.nameLabel.text = _remoteUserId;
 ```
On the bottom line you can see we’re setting the name label on our incoming call screen view controller. 

Now we’ve only got to implement the delegate methods to either accept or decline an incoming call. Head over to incomingCall.m and find the answer and decline methods. In the respective methods add these two calls to self.delegate.
```objective-c

	[self.delegate answerCall];
	[self.delegate declineCall];
```

Of course we haven’t yet implemented our protocol and delegate so we need to do that in our incomingCall.h file.
```objective-c

	@protocol IncomingCallDelegate <NSObject>
	- (void)answer;
	- (void)decline;
	@end
```

Now add the delegate property to match the protocol in the @interface section of incomingCall.h
```objective-c

	@property (nonatomic, weak) id<IncomingCallDelegate> delegate;
```

We now need to make newFriends conform to the protocol, once again modify the @interface in newFriends.h.
```objective-c

	@interface newFriends : UITableViewController <UITableViewDataSource, 			UITableViewDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, 			SINCallClientDelegate, SINCallDelegate, callScreenDelegate, IncomingCallDelegate>
```

Now navigate to the .h file and implement both the answer and decline methods.
```objective-c

	- (void)answer {;
    		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    		_theNewCallScreen = (callScreen *)[storyboard 								instantiateViewControllerWithIdentifier:@"callScreen"];
    		[_theNewCallScreen setDelegate:self];
    		[self presentViewController:_theNewCallScreen animated:YES completion:nil];
    		_theNewCallScreen.statusLabel.text = @"Connected";
    		_theNewCallScreen.nameOfFriendLabel.text = _remoteUserId;
	}
	- (void)decline {
    		[_call hangup];
	}
```	
Once again we’ve done all this before so if you have any trouble working out what’s going on the best idea is to head back all look over past explanations. 

That’s all for now folks!


There’s heaps that you can add to this project and I encourage you to do so. 
	
	
© Zac Brown 2015








