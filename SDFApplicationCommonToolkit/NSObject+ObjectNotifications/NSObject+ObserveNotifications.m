//
//  NSObject+ObserveNotifications.m
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 22/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet, Inc. All rights reserved.
//

#import "NSObject+ObserveNotifications.h"

NSString *const NSObjectNotificationObserverNameKey     = @"net.reyssi.def.SDFApplicationCommonToolkit:NSObjectNotificationObserverNameKey";
NSString *const NSObjectNotificationObserverSelectorKey = @"net.reyssi.def.SDFApplicationCommonToolkit:NSObjectNotificationObserverSelectorKey";

@implementation NSObject (ObserveNotifications)

- (void)initializeObservers:(NSString **)observers selectors:(SEL *)selectors size:(uint16_t)size
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    for (int i = 0; i < size; i += 1)
    {
        NSString *notification = observers[i];
        SEL selector           = selectors[i];
        
        [notificationCenter addObserver:self
                               selector:selector
                                   name:notification
                                 object:nil];
    }
}

- (void)deinializeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Registers the notification observers supplied by
// registerNotificationNamesAndSelectors
- (void)registerNotifcationCenterObservers
{
    id<NSObjectOberservesNotifications> notificationSelf = (id<NSObjectOberservesNotifications>)self;
    
    NSArray *registerNotifications = [notificationSelf registerNotificationNamesAndSelectors];
    
    if (registerNotifications == nil)
    {
        return;
    }
    
    NSDictionary **notificationsDict;
    
    NSRange arrayRange = NSMakeRange(0, [registerNotifications count]);
    
    notificationsDict  = malloc(sizeof(NSDictionary*) * arrayRange.length);
    
    if (notificationsDict == NULL)
    {
        return;
    }
    
    [registerNotifications getObjects:notificationsDict range:arrayRange];
    
    NSString *notifcationNames[arrayRange.length];
    SEL       notificationSelectors[arrayRange.length];
    
    for (int i = 0; i < arrayRange.length; i += 1)
    {
        NSDictionary *notificationDict = notificationsDict[i];
        
        notifcationNames[i]      = [notificationDict objectForKey:NSObjectNotificationObserverNameKey];
        notificationSelectors[i] = NSSelectorFromString([notificationDict objectForKey:NSObjectNotificationObserverSelectorKey]);
    }
    
    [notificationSelf initializeObservers:notifcationNames selectors:notificationSelectors size:arrayRange.length];
    
    free(notificationsDict);
}

@end
