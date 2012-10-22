//
//  NSObject+OberserveNotificationsTests.m
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 11/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import <OCMock/OCMock.h>

#import "NSObject+OberserveNotificationsTests.h"

@implementation MSATestObject

- (NSArray *)registerNotificationNamesAndSelectors
{
    return nil;
}

- (void)fooNotice:(NSNotification *)notification
{
    NSLog(@"[%@] received notification: %@", self, notification);
}

- (void)barNotice:(NSNotification *)notification
{
    NSLog(@"[%@] received notification: %@", self, notification);
}

@end

@implementation NSObject_OberserveNotificationsTests

- (void)setUp
{
    _notificationsReceived = 0;
    
    [super setUp];
}

- (NSArray *)notificationNames
{
    return [NSArray arrayWithObjects:@"fooNotice", @"barNotice", nil];
}

- (NSArray *)notificationSelectors
{
    return [NSArray arrayWithObjects:NSStringFromSelector(@selector(fooNotice:)), NSStringFromSelector(@selector(barNotice:)), nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    NSLog(@"[%@] Received notification: %@", self, notification);
    
    _notificationsReceived += 1;
}

- (void)verifiyNotifications:(id)object
{
    [object verify];
}

- (id)fixtureNSObjectObserveNotification
{
    MSATestObject *object = [[MSATestObject alloc] init];
    
    id mockTestObject = [OCMockObject partialMockForObject:object];
    
    [[mockTestObject expect] fooNotice:[OCMArg any]];
    [[mockTestObject expect] barNotice:[OCMArg any]];
    
    NSArray *names     = [self notificationNames];
    NSArray *selectors = [self notificationSelectors];
    
    int count = [names count];
    
    NSMutableArray *notifications = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i += 1)
    {
        NSDictionary *notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [names objectAtIndex:i], NSObjectNotificationObserverNameKey,
                                          [selectors objectAtIndex:i],  NSObjectNotificationObserverSelectorKey
                                          , nil];
        
        [notifications addObject:notificationDict];
    }
    
    
    [[[mockTestObject stub] andReturn:notifications] registerNotificationNamesAndSelectors];
    
    return mockTestObject;
}

- (void)testRegisterNotifcationCenterObservers
{
    id mockTestObject = [self fixtureNSObjectObserveNotification];
        
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSArray *notificationNames = [self notificationNames];
    
    for (NSString *notificationName in notificationNames)
    {
        [notificationCenter addObserver:self
                               selector:@selector(notificationReceived:)
                                   name:notificationName
                                 object:nil];

    }
    
    [mockTestObject registerNotifcationCenterObservers];
    
    for (NSString *notificationName in notificationNames)
    {
        NSNotification *notification = [NSNotification notificationWithName:notificationName object:mockTestObject];
        
        [notificationCenter performSelector:@selector(postNotification:)
                                   onThread:[NSThread mainThread]
                                 withObject:notification
                              waitUntilDone:YES];
    }
    
    [self performSelector:@selector(verifiyNotifications:)
                 onThread:[NSThread mainThread]
               withObject:mockTestObject
            waitUntilDone:YES];
}

@end
