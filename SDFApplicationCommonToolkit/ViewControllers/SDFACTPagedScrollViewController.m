//
//  SDFACTPagedScrollViewController.m
//  ApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 22/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import "SDFACTPagedScrollViewController.h"

@implementation SDFACTPagedScrollViewController

@synthesize dataSource         = _dataSource;
@synthesize delegate           = _delegate;
@synthesize pageControl        = _pageControl;
@synthesize scrollView         = _scrollView;
@synthesize loadedPageViews    = _loadedPageViews;
@synthesize displayPageControl = _displayPageControl;

#pragma mark - MSAPagedScrollViewController Lifecycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self initializeScrollView];
        [self initializePageControlView];
                
        _loadedPageViews = nil;
        
        _displayPageControl = YES;
    }
    
    return self;
}

- (id)init
{
    return [super initWithNibName:nil bundle:nil];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutPageControlView];
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [self loadPageViews];
    
    [super viewDidLoad];
}

- (void)dealloc
{
    [_dataSource release];
    [_pageControl release];
    [_scrollView release];
    [_loadedPageViews release];
    
    [super dealloc];
}

#pragma mark - MSAPagedScrollViewController Lifecycle Methods

- (void)initializePageControlView
{
    UIPageControl *pageControl           = [[UIPageControl alloc] init];
    pageControl.numberOfPages            = kSDFACTPagedScrollViewControllerDefaultNumberOfPages;
    pageControl.hidesForSinglePage       = kSDFACTPagedScrollViewControllerDefaultHidesForSinglePage;
    pageControl.defersCurrentPageDisplay = YES;
    
    _pageControl = pageControl;
    [self.view addSubview:pageControl];
}

- (void)initializeScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    
    _scrollView  = scrollView;
    [self.view addSubview:scrollView];
}

#pragma mark - MSAPagedScrollView Drawing Methods

- (void)loadPageViews
{
    if (self.dataSource == nil)
    {
        return;
    }
    
    // Remove any existing views from UIScrollView
    if (_loadedPageViews != nil)
    {
        for (UIView *view in _loadedPageViews)
        {
            [view removeFromSuperview];
        }
    }
    
    NSInteger numberOfPages     = [self numberOfPages];
    NSMutableArray *loadedViews = [NSMutableArray arrayWithCapacity:numberOfPages];
    
    for (int i = 0; i < numberOfPages; i += 1)
    {
        UIView *viewForPage = [self.dataSource pagedScrollView:self viewForPage:(NSInteger)i];
        
        [loadedViews insertObject:viewForPage atIndex:i];
        
    }
    
    if (_loadedPageViews != nil)
    {
        [_loadedPageViews release];
    }

    _loadedPageViews = [loadedViews retain];
}

- (void)layoutView:(UIView *)view forPage:(NSInteger)page
{
    CGSize  windowSize   = self.view.frame.size;
    CGRect viewFrame     = view.frame;
    
    viewFrame.origin.x   = windowSize.width * page;
    viewFrame.origin.y   = 0.0f;
    viewFrame.size       = windowSize;
    
    view.frame = viewFrame;
    
    [self.scrollView addSubview:view];
}

- (void)layoutPageControlView
{    
    NSInteger numberOfPages    = [self numberOfPages];
    
    // Set the scroll view size
    CGFloat scrollViewWidth    = (CGFloat)self.view.frame.size.width;
    CGFloat scrollViewHeight   = (CGFloat)self.view.frame.size.height;
    
    // Set the content size
    CGFloat contentWidth       = (CGFloat)self.view.frame.size.width * numberOfPages;
    CGFloat contentHeight      = scrollViewHeight;
    
    [self.scrollView setFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    [self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
    
    // Layout pages
    for (int i = 0; i < numberOfPages; i += 1)
    {
        UIView *viewForPage = [_loadedPageViews objectAtIndex:i];
        
        [self layoutView:viewForPage forPage:i];
    }
    
    // Apply the page control
    CGRect windowFrame        = self.view.frame;
    CGSize pageControlSize    = [self.pageControl sizeForNumberOfPages:numberOfPages];
    
    CGFloat pageControlXPos   = windowFrame.size.width / 2;  // UIPageControl centers itself on xPos
    CGFloat pageControlYPos   = ((windowFrame.size.height - pageControlSize.height) - 20.0f);
    CGPoint pageControlOrigin = CGPointMake(pageControlXPos, pageControlYPos);
    
    CGRect pageControlFrame   = self.pageControl.frame;
    pageControlFrame.origin   = pageControlOrigin;
    
    [self.pageControl setHidden:( ! self.displayPageControl)];
    
    [self.pageControl setFrame:pageControlFrame];
}

#pragma mark - UIPageControl Methods

- (NSInteger)currentPage
{
    return self.pageControl.currentPage;
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated
{
    if (currentPage >= self.pageControl.numberOfPages)
    {
        currentPage = self.pageControl.numberOfPages - 1;
    }
    else if (currentPage < 0)
    {
        currentPage = 0;
    }
    
    [self.pageControl setCurrentPage:currentPage];
    [self displayPage:currentPage animated:animated];
}

- (void)nextPage:(BOOL)animated
{
    NSInteger currentPage = [self currentPage];
    currentPage += 1;
    
    [self setCurrentPage:currentPage animated:animated];
}

- (void)previousPage:(BOOL)animated
{
    NSInteger currentPage = [self currentPage];
    currentPage -= 1;
    
    [self setCurrentPage:currentPage animated:animated];
}

- (void)displayPage:(NSInteger)page animated:(BOOL)animated
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat windowWidth   = self.scrollView.frame.size.width;
    CGFloat xPos          = 0.0f;
    xPos = (CGFloat)(windowWidth * page);
    
    contentOffset.x = xPos;

    [self.scrollView setContentOffset:contentOffset animated:animated];
    [self.pageControl updateCurrentPageDisplay];
}

- (NSInteger)numberOfPages
{
    if (self.dataSource == nil)
    {
        return 0;
    }

    NSInteger numberOfPages = [self.dataSource numberOfPagesForPagedScrollView:self];
    [self.pageControl setNumberOfPages:numberOfPages];

    return self.pageControl.numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    self.pageControl.numberOfPages = numberOfPages;
}

- (BOOL)pageControlHidesForSinglePage
{
    return self.pageControl.hidesForSinglePage;
}

- (void)setPageControlHidesForSinglePage:(BOOL)hidesForSinglePage
{
    [self.pageControl setHidesForSinglePage:hidesForSinglePage];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    SEL didEndAnimationSelector = @selector(pagedScrollViewDidEndScrollingWithAnimation:);
    
    if (self.delegate && [self.delegate respondsToSelector:didEndAnimationSelector])
    {
        [self.delegate performSelector:didEndAnimationSelector withObject:self];
    }
}

@end
