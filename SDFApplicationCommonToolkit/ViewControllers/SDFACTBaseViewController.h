//
//  SDFACTBaseViewController.h
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 10/22/12.
//  Copyright (c) 2012 Maison de Freyssinet All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+ObserveNotifications.h"

@interface SDFACTBaseViewController : UIViewController <NSObjectOberservesNotifications>

#pragma mark - Notification Badge Methods

- (void)setTabBarNotificationBadgeNumber:(NSNumber *)number;

@end
