//
//  NSObject+ObserveNotifications.h
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 22/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NSObjectNotificationObserverNameKey;
extern NSString *const NSObjectNotificationObserverSelectorKey;

@interface NSObject (ObserveNotifications)

// Registers the notification observers supplied by
// registerNotificationNamesAndSelectors
- (void)registerNotifcationCenterObservers;

- (void)initializeObservers:(NSString **)observers selectors:(SEL *)selectors size:(uint16_t)size;

- (void)deinializeObservers;

@end

@protocol NSObjectOberservesNotifications

@required

- (void)initializeObservers:(NSString **)observers selectors:(SEL *)selectors size:(uint16_t)size;

- (void)deinializeObservers;

// Return an array of NSDictionary's containing the selector as a string
// and the notification name.
- (NSArray *)registerNotificationNamesAndSelectors;

@end