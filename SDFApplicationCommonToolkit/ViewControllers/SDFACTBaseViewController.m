//
//  SDFACTBaseViewController.m
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 10/22/12.
//  Copyright (c) 2012 Maison de Freyssinet All rights reserved.
//

#import "SDFACTBaseViewController.h"

@implementation SDFACTBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self registerNotifcationCenterObservers];        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [self deinializeObservers];
    
    [super dealloc];
}

#pragma mark - Notification Badge Methods

- (void)setTabBarNotificationBadgeNumber:(NSNumber *)number
{
    NSString *badgeValue = [number stringValue];
    [self.tabBarItem setBadgeValue:badgeValue];
}

- (NSArray *)registerNotificationNamesAndSelectors
{
    return [NSArray array];
}

@end