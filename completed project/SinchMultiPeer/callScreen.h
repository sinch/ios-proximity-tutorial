//
//  callScreen.h
//  SinchMultiPeer
//
//  Created by Zachary Brown on 1/04/2015.
//  Copyright (c) 2015 Zac Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol callScreenDelegate <NSObject>

- (void)hangUp;

@end

@interface callScreen : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, weak)  id<callScreenDelegate>delegate;
@end
