//
//  SDFACTPagedScrollViewController.h
//  ApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 22/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SDFApplicationCommonToolkit_MSAPagedScrollViewController_h
#define SDFApplicationCommonToolkit_MSAPagedScrollViewController_h

#define kSDFACTPagedScrollViewControllerDefaultNumberOfPages      1
#define kSDFACTPagedScrollViewControllerDefaultHidesForSinglePage NO

@protocol SDFACTPagedScrollViewControllerDataSource;
@protocol SDFACTPagedScrollViewControllerDelegate;

@interface SDFACTPagedScrollViewController : UIViewController <UIScrollViewDelegate> {
    
    id<SDFACTPagedScrollViewControllerDataSource> _dataSource;
    id<SDFACTPagedScrollViewControllerDelegate>   _delegate;

    UIPageControl  *_pageControl;
    UIScrollView   *_scrollView;
    
    NSMutableArray *_loadedPageViews;
    
    BOOL            _displayPageControl;

}

@property (nonatomic, retain) id<SDFACTPagedScrollViewControllerDataSource> dataSource;
@property (nonatomic, retain) id<SDFACTPagedScrollViewControllerDelegate>   delegate;

@property (nonatomic, readonly) UIPageControl  *pageControl;
@property (nonatomic, readonly) UIScrollView   *scrollView;
@property (nonatomic, readonly) NSMutableArray *loadedPageViews;
@property (nonatomic, assign) BOOL              displayPageControl;

#pragma mark - MSAPagedScrollViewController Lifecycle Methods

- (void)initializePageControlView;
- (void)initializeScrollView;

#pragma mark - MSAPagedScrollView Drawing Methods

- (void)loadPageViews;
- (void)layoutView:(UIView *)view forPage:(NSInteger)page;
- (void)layoutPageControlView;

#pragma mark - UIPageControl Methods

- (NSInteger)currentPage;
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;
- (void)nextPage:(BOOL)animated;
- (void)previousPage:(BOOL)animated;
- (void)displayPage:(NSInteger)page animated:(BOOL)animated;

- (NSInteger)numberOfPages;
- (void)setNumberOfPages:(NSInteger)numberOfPages;

- (BOOL)pageControlHidesForSinglePage;
- (void)setPageControlHidesForSinglePage:(BOOL)hidesForSinglePage;

@end

@protocol SDFACTPagedScrollViewControllerDataSource <NSObject>

@required

- (NSInteger)numberOfPagesForPagedScrollView:(SDFACTPagedScrollViewController *)pagedScrollView;
- (UIView *)pagedScrollView:(SDFACTPagedScrollViewController *)pagedScrollView viewForPage:(NSInteger)page;

@end

@protocol SDFACTPagedScrollViewControllerDelegate <NSObject>

@optional

- (void)pagedScrollViewDidEndScrollingWithAnimation:(SDFACTPagedScrollViewController *)pagedScrollView;

@end

#endif