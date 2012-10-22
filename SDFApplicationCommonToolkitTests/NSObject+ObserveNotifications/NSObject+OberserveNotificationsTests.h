//
//  NSObject+OberserveNotificationsTests.h
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 11/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+ObserveNotifications.h"

@interface MSATestObject : NSObject <NSObjectOberservesNotifications>

- (void)fooNotice:(NSNotification *)notification;
- (void)barNotice:(NSNotification *)notification;

@end

@interface NSObject_OberserveNotificationsTests : SenTestCase {
    
    uint8_t _notificationsReceived;
    
}

@end
