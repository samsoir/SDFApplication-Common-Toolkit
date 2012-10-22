//
//  SDFACTBaseTableViewController.m
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 28/09/2012.
//  Copyright (c) 2012 Sittercity, Inc. All rights reserved.
//

#import "SDFACTBaseTableViewController.h"

NSString *const SDFACTNotificationObserverNameKey             = @"net.reyssi.def:SDFACTNotificationObserverNameKey";
NSString *const SDFACTNotificationObserverSelectorKey         = @"net.reyssi.def:SDFACTNotificationObserverSelectorKey";
NSString *const SDFACTBaseTableViewControllerKVODataSourceKey = @"dataSource";

@implementation SDFACTBaseTableViewController (Private)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:SDFACTBaseTableViewControllerKVODataSourceKey])
    {
        [self.tableView reloadData];

        if ([self.dataSource count] > 0)
        {
            [self displayEmptyTableView:NO animated:YES];
        }
        else
        {
            [self displayEmptyTableView:YES animated:YES];
        }
    }
}

@end

@implementation SDFACTBaseTableViewController

@synthesize tableView                = _tableView;
@synthesize emptyTableView           = _emptyTableView;
@synthesize dataSource               = _dataSource;

@synthesize segmentedResultThreshold = _segmentedResultThreshold;
@synthesize segmentedResults         = _segmentedResults;
@synthesize tableViewStyle           = _tableViewStyle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil style:(UITableViewStyle)style segmentedResultThreshold:(uint8_t)segmentedResultThreshold
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        _segmentedResults             = NO;
        
        self.tableViewStyle           = style;
        self.segmentedResultThreshold = segmentedResultThreshold;
        self.dataSource               = [self prepareForSegmentation:[self loadDataFromSource]
                                                  segmentedThreshold:self.segmentedResultThreshold
                                             collationStringSelector:[self segmentationCollationSelector]];
        
        [self.tableView setSectionIndexMinimumDisplayRowCount:segmentedResultThreshold];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                               forKeyPath:SDFACTBaseTableViewControllerKVODataSourceKey
                                                  options:NSKeyValueObservingOptionNew
                                                  context:nil];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil style:(UITableViewStyle)style
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:style segmentedResultThreshold:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = self.view.frame;
    
    NSLog(@"TableView Frame: %f %f   - %f x %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    [self initializeTableViewWithFrame:frame style:self.tableViewStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self tableViewShouldUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self deinializeObservers];

    [_tableView release];
    [_emptyTableView release];
    [_dataSource release];
    
    [super dealloc];
}

#pragma mark - MSABaseTableViewController Display Methods

- (void)initializeTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    frame.origin.y    = 0.0f;

    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.tableView = [tableView autorelease];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.view addSubview:tableView];
}

- (BOOL)shouldDisplayEmptyView
{
    BOOL shouldDisplayEmptyView = NO;
    
    if ([self.dataSource count] < 1 && self.emptyTableView != nil)
    {
        shouldDisplayEmptyView = YES;
    }
    
    return shouldDisplayEmptyView;
}

- (void)addEmptyTableView:(BOOL)animated
{
    __block CGRect emptyViewframe   = self.emptyTableView.frame;
    CGRect viewFrame                = self.view.frame;
    
    if (animated)
    {
        emptyViewframe.origin.y = viewFrame.size.height;
    }
    
    [self.view addSubview:self.emptyTableView];
    
    if (animated)
    {
        [UIView animateWithDuration:kSDFACTBaseTableViewControllerAnimationDuration animations:^{
            
            emptyViewframe.origin.y   = 0.0f;
            
            [self.emptyTableView setFrame:emptyViewframe];
            
        } completion:nil];
    }
}

- (void)removeEmptyView:(BOOL)animated
{
    if ( ! animated)
    {
        [self.emptyTableView removeFromSuperview];
    }
    else
    {
        [UIView animateWithDuration:kSDFACTBaseTableViewControllerAnimationDuration animations:^{
            
            CGRect emptyViewframe     = self.emptyTableView.frame;
            CGRect viewFrame          = self.view.frame;
            
            emptyViewframe.origin.y   = viewFrame.size.height;
            
            [self.emptyTableView setFrame:emptyViewframe];
            
        } completion:^(BOOL finished) {
            
            [self.emptyTableView removeFromSuperview];
        }];
    }
}

- (void)displayEmptyTableView:(BOOL)display animated:(BOOL)animated
{
    if (self.emptyTableView == nil)
    {
        return;
    }

    if ((display == NO) && [self.emptyTableView isDescendantOfView:self.view])
    {
        if ( ! [self shouldDisplayEmptyView])
        {
            [self removeEmptyView:animated];
        }
    }
    else if ((display == YES) && ! [self.emptyTableView isDescendantOfView:self.view])
    {
        if ([self shouldDisplayEmptyView])
        {
            [self addEmptyTableView:animated];            
        }
    }
}

- (void)tableViewShouldUpdate
{
    [self reloadTableViewData];
    [self displayEmptyTableView:[self shouldDisplayEmptyView] animated:YES];
}

#pragma mark - MSABaseTableViewController NSNotification Methods

@end

@implementation SDFACTBaseTableViewController(UITableViewDataSource)

- (void)reloadTableViewData
{
    self.dataSource = [self prepareForSegmentation:[self loadDataFromSource]
                                segmentedThreshold:self.segmentedResultThreshold
                           collationStringSelector:[self segmentationCollationSelector]];
    
    [self.tableView reloadData];
}

- (SEL)segmentationCollationSelector
{
    return @selector(description);
}

- (NSMutableArray *)prepareForSegmentation:(NSMutableArray *)dataSource segmentedThreshold:(uint8_t)segmentedThreshold collationStringSelector:(SEL)selector
{
    if (([dataSource count] < segmentedThreshold) || (segmentedThreshold < 1))
    {
        _segmentedResults = NO;
        return dataSource;
    }
    
    _segmentedResults = YES;
    
    UILocalizedIndexedCollation *currentCollation = [UILocalizedIndexedCollation currentCollation];
    NSUInteger sectionCount                       = [[currentCollation sectionTitles] count];
    NSMutableArray *dataSourceSorted              = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (int i = 0; i < sectionCount; i += 1)
    {
        [dataSourceSorted addObject:[NSMutableArray array]];
    }
    
    for (id dataObject in dataSource)
    {
        NSUInteger sectionIndex = [currentCollation sectionForObject:dataObject
                                             collationStringSelector:selector];
        
        NSMutableArray *section = [dataSourceSorted objectAtIndex:sectionIndex];
        [section addObject:dataObject];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (NSMutableArray *section in dataSourceSorted)
    {
        [sections addObject:[currentCollation sortedArrayFromArray:section
                                           collationStringSelector:selector]];            
    }
    
    return sections;
}

- (NSMutableArray *)loadDataFromSource
{
    return [NSMutableArray arrayWithCapacity:1];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    id object = nil;
    
    if (self.segmentedResults)
    {
        object = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        object = [self.dataSource objectAtIndex:indexPath.row];
    }
    
    return object;
}

- (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"net.reyssi.def:CellIdentifer";
    
    return CellIdentifier;
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style reuseIdentifer:(NSString *)reuseIdentifier
{
    return [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 1;
    
    if (self.segmentedResults)
    {
        numberOfSections = [self.dataSource count];
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.dataSource count];
    
    if (self.segmentedResults)
    {
        NSMutableArray *sectionData = [self.dataSource objectAtIndex:section];
        
        if (sectionData)
        {
            numberOfRows = [sectionData count];
        }
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self reusableCellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( ! cell)
    {
        cell = [self cellForIndexPath:indexPath
                                style:UITableViewCellStyleDefault
                       reuseIdentifer:cellIdentifier];
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *sectionIndexTitles = nil;
    
    if ([self segmentedResults])
    {
        sectionIndexTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
    
    return sectionIndexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleForSection   = nil;

    if (self.dataSource && (section < [self.dataSource count]))
    {
        NSArray *sectionIndexTitles = [self sectionIndexTitlesForTableView:tableView];
        NSArray *sectionArray       = [self.dataSource objectAtIndex:section];
        
        if (sectionIndexTitles != nil && [sectionIndexTitles count] > 0 && [sectionArray count] > 0)
        {
            titleForSection = [sectionIndexTitles objectAtIndex:section];
        }
    }
    
    return titleForSection;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end

@implementation SDFACTBaseTableViewController(UITableViewDelegate)

@end