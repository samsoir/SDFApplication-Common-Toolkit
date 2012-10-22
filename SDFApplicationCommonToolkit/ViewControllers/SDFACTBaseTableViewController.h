//
//  MSABaseTableViewController.h
//  Sitterati
//
//  Created by Sam de Freyssinet on 28/09/2012.
//  Copyright (c) 2012 Sittercity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDFACTBaseViewController.h"
#import "NSObject+ObserveNotifications.h"

#ifndef SDFApplicationCommonToolkit_MSABaseTableViewController_h
#define SDFApplicationCommonToolkit_MSABaseTableViewController_h

#define kSDFACTBaseTableViewControllerAnimationDuration 0.5f

extern NSString *const SDFACTNotificationObserverNameKey;
extern NSString *const SDFACTNotificationObserverSelectorKey;
extern NSString *const SDFACTBaseTableViewControllerKVODataSourceKey;

@interface SDFACTBaseTableViewController : SDFACTBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView            *_tableView;
    UIView                 *_emptyTableView;
    NSMutableArray         *_dataSource;
    
    int8_t                  _segmentedResultThreshold;
    BOOL                    _segmentedResults;
    UITableViewStyle        _tableViewStyle;    
}

@property (nonatomic, retain) UITableView    *tableView;
@property (nonatomic, retain) UIView         *emptyTableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic) int8_t                  segmentedResultThreshold;
@property (nonatomic, readonly) BOOL          segmentedResults;
@property (nonatomic) UITableViewStyle        tableViewStyle;

#pragma mark - SDFACTBaseTableViewController Lifecycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil style:(UITableViewStyle)style segmentedResultThreshold:(uint8_t)segmentedResultThreshold;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil style:(UITableViewStyle)style;

#pragma mark - SDFACTBaseTableViewController Display Methods

- (void)initializeTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (BOOL)shouldDisplayEmptyView;
- (void)tableViewShouldUpdate;

- (void)addEmptyTableView:(BOOL)animated;
- (void)removeEmptyView:(BOOL)animated;
- (void)displayEmptyTableView:(BOOL)display animated:(BOOL)animated;

@end

@interface SDFACTBaseTableViewController(UITableViewDataSource)

- (void)reloadTableViewData;
- (SEL)segmentationCollationSelector;
- (NSMutableArray *)prepareForSegmentation:(NSMutableArray *)dataSource segmentedThreshold:(uint8_t)segmentedThreshold collationStringSelector:(SEL)selector;
- (NSMutableArray *)loadDataFromSource;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style reuseIdentifer:(NSString *)reuseIdentifier;

@end

@interface SDFACTBaseTableViewController(UITableViewDelegate)

@end

#endif
