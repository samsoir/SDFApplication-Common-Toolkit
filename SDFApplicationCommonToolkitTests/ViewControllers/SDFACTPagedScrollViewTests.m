//
//  SDFACTPagedScrollViewControllerTests.m
//  ApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 22/10/2012.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import "SDFACTPagedScrollViewTests.h"
#import "SDFACTPagedScrollViewController.h"
#import "OCMock.h"

@interface SDFACTPagedScrollViewControllerDataSourceMock : NSObject <SDFACTPagedScrollViewControllerDataSource>;

@end

@implementation SDFACTPagedScrollViewControllerDataSourceMock

- (NSInteger)numberOfPagesForPagedScrollView:(SDFACTPagedScrollViewController *)pagedScrollView
{
    return 4;
}

- (UIView *)pagedScrollView:(SDFACTPagedScrollViewController *)pagedScrollView viewForPage:(NSInteger)page
{
    UIView *viewForPage = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    
    return [viewForPage autorelease];
}

@end

@implementation SDFACTPagedScrollViewTests

- (void)testInit
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    
    STAssertNotNil(subject, @"Subject should not be nil");
    
    STAssertNotNil(subject.pageControl, @"Subject page control should be initialized");
    STAssertEquals(kSDFACTPagedScrollViewControllerDefaultNumberOfPages, subject.pageControl.numberOfPages, @"Number of pages should equal: %i, got: %i", kSDFACTPagedScrollViewControllerDefaultNumberOfPages, subject.pageControl.numberOfPages);
    
    STAssertNotNil(subject.scrollView, @"Subject scroll view should be initialized");
    STAssertEquals(kSDFACTPagedScrollViewControllerDefaultHidesForSinglePage, subject.pageControl.hidesForSinglePage, @"Hides for single page should equal: %i got: %i", kSDFACTPagedScrollViewControllerDefaultHidesForSinglePage, subject.pageControl.hidesForSinglePage);
    
    [subject release];
}

- (void)testNumberOfPages
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];

    NSInteger numberOfPages = 2;
    
    [subject setNumberOfPages:numberOfPages];
    
    STAssertEquals(numberOfPages, subject.pageControl.numberOfPages, @"Subject number of pages should equal: %i, got: %i", numberOfPages, subject.pageControl.numberOfPages);
    
    subject.dataSource = [[[SDFACTPagedScrollViewControllerDataSourceMock alloc] init] autorelease];

    numberOfPages = [subject.dataSource numberOfPagesForPagedScrollView:subject];
    
    // Test getter
    STAssertEquals(numberOfPages, [subject numberOfPages], @"Subject number of pages should equal: %i, got: %i", numberOfPages, [subject numberOfPages]);
    
    [subject release];
}

- (void)testCurrentPage
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    
    NSInteger numberOfPages = 4;

    [subject setNumberOfPages:numberOfPages];
    
    STAssertEquals(0, [subject currentPage], @"Subject current page should equal: %i, got: %i", 0, [subject currentPage]);
    
    subject.pageControl.currentPage = numberOfPages - 1;
    
    STAssertEquals((numberOfPages - 1), [subject currentPage], @"Subject current page should equal: %i, got: %i", (numberOfPages - 1), [subject currentPage]);
    
    // Test setter
    
    NSInteger newCurrentPage = 2;
    [subject setCurrentPage:newCurrentPage animated:NO];
    
    STAssertEquals(newCurrentPage, [subject currentPage], @"Subject current page should equal: %i, got: %i", newCurrentPage, [subject currentPage]);
    
    NSInteger rangeExceptionLarge = 10;
    NSInteger rangeExceptionLow   = -5;
    
    [subject setCurrentPage:rangeExceptionLarge animated:NO];
    
    STAssertEquals((numberOfPages - 1), [subject currentPage], @"Subject current page should equal: %i when set with: %i, got: %i", (numberOfPages- 1), rangeExceptionLarge, [subject currentPage]);

    [subject setCurrentPage:rangeExceptionLow animated:NO];
    
    STAssertEquals(0, [subject currentPage], @"Subject current page should equal: %i when set with: %i, got: %i", 0, rangeExceptionLow, [subject currentPage]);
}

- (void)testNextPage
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    
    NSInteger numberOfPages = 4;
    NSInteger currentPage   = 0;
    
    [subject setNumberOfPages:numberOfPages];

    STAssertEquals(currentPage, [subject currentPage], @"Subject current page should equal: %i, got: %i", currentPage, [subject currentPage]);

    ++currentPage;
    [subject nextPage:NO];
    
    STAssertEquals(currentPage, [subject currentPage], @"Subject current page should equal: %i, got: %i", currentPage, [subject currentPage]);
    
    currentPage  = 10;
    [subject setCurrentPage:currentPage animated:NO];
    
    [subject nextPage:NO];
    STAssertFalse((currentPage == [subject currentPage]), @"Subject current page should not equal: %i, got: %i", currentPage, [subject currentPage]);
    STAssertTrue(((numberOfPages - 1) == [subject currentPage]), @"Subject current page should equal: %i, got: %i", (numberOfPages - 1), [subject currentPage]);
}

- (void)testPreviousPage
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    
    NSInteger numberOfPages = 4;
    NSInteger currentPage   = 0;
    
    [subject setNumberOfPages:numberOfPages];
    
    STAssertEquals(currentPage, [subject currentPage], @"Subject current page should equal: %i, got: %i", currentPage, [subject currentPage]);
    
    ++currentPage;
    [subject setCurrentPage:currentPage animated:NO];
    [subject previousPage:NO];
    
    STAssertEquals((currentPage - 1), [subject currentPage], @"Subject current page should equal: %i, got: %i", (currentPage - 1), [subject currentPage]);
    
    currentPage  = -10;
    [subject setCurrentPage:currentPage animated:NO];
    
    [subject previousPage:NO];
    STAssertFalse((currentPage == [subject currentPage]), @"Subject current page should not equal: %i, got: %i", currentPage, [subject currentPage]);
    STAssertTrue(((numberOfPages - numberOfPages) == [subject currentPage]), @"Subject current page should equal: %i, got: %i", (numberOfPages - numberOfPages), [subject currentPage]);
}

- (void)testPageControlHidesForSinglePage
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    STAssertEquals(kSDFACTPagedScrollViewControllerDefaultHidesForSinglePage, [subject pageControlHidesForSinglePage], @"Page control hides for single page should equal: %i, got: %i", kSDFACTPagedScrollViewControllerDefaultHidesForSinglePage, [subject pageControlHidesForSinglePage]);
    
    BOOL hidesForCurrentPage = YES;
    
    [subject setPageControlHidesForSinglePage:hidesForCurrentPage];
    
    STAssertEquals(hidesForCurrentPage, [subject pageControlHidesForSinglePage], @"Page control hides for single page should equal: %i, got: %i", hidesForCurrentPage, [subject pageControlHidesForSinglePage]);
}

- (void)testLayoutViewForPage
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    subject.view.frame                    = CGRectMake(0.0f, 0.0f, 320.0f, 470.0f);
    
    UIView *viewForPage0 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    UIView *viewForPage1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    UIView *viewForPage2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    UIView *viewForPage3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    
    [subject layoutView:viewForPage0 forPage:0];
    [subject layoutView:viewForPage1 forPage:1];
    [subject layoutView:viewForPage2 forPage:2];
    [subject layoutView:viewForPage3 forPage:3];
    
    CGRect page0Frame = viewForPage0.frame;
    CGRect page1Frame = viewForPage1.frame;
    CGRect page2Frame = viewForPage2.frame;
    CGRect page3Frame = viewForPage3.frame;
    
    CGFloat pageWidth = subject.view.frame.size.width;
    CGFloat pageHeight = subject.view.frame.size.height;

    STAssertTrue((page0Frame.origin.x == (0 * pageWidth)), @"Page 0 x offset should be 0");
    STAssertTrue((page1Frame.origin.x == (1 * pageWidth)), @"Page 1 x offset should be %f, got: %f", (1 * pageWidth), page1Frame.origin.x);
    STAssertTrue((page2Frame.origin.x == (2 * pageWidth)), @"Page 2 x offset should be %f, got: %f", (2 * pageWidth), page2Frame.origin.x);
    STAssertTrue((page3Frame.origin.x == (3 * pageWidth)), @"Page 3 x offset should be %f, got: %f", (3 * pageWidth), page3Frame.origin.x);

    STAssertTrue(pageHeight == page0Frame.size.height, @"Page 0 height should match window");
    STAssertTrue(pageHeight == page1Frame.size.height, @"Page 1 height should match window");
    STAssertTrue(pageHeight == page2Frame.size.height, @"Page 2 height should match window");
    STAssertTrue(pageHeight == page3Frame.size.height, @"Page 3 height should match window");

    
    [subject release];
    [viewForPage0 release];
    [viewForPage1 release];
    [viewForPage2 release];
    [viewForPage3 release];
}

- (void)testLayoutViews
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
        
    subject.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 470.0f);
    [subject.view drawRect:subject.view.frame];
    
    subject.dataSource = [[[SDFACTPagedScrollViewControllerDataSourceMock alloc] init] autorelease];
    
    [subject viewDidLoad];
    [subject viewDidAppear:NO];
    
    STAssertTrue(([subject.loadedPageViews count] == [subject.dataSource numberOfPagesForPagedScrollView:subject]), @"Loaded page views :%i should equal the number of pages: %i", [subject.loadedPageViews count], [subject.dataSource numberOfPagesForPagedScrollView:subject]);
    
    NSArray *subviews = [subject.scrollView subviews];
    CGFloat xPos      = -1.0f;
    
    for (UIView *view in subviews)
    {
        STAssertTrue([subject.loadedPageViews containsObject:view], @"View: %@ should be loaded in subject");
        STAssertTrue((xPos < view.frame.origin.x), @"xPos: %f should be less than view xPos: %f", xPos, view.frame.origin.x);
        xPos = view.frame.origin.x;
    }
}

- (void)testDisplayPageAnimated
{
    SDFACTPagedScrollViewController *subject = [[SDFACTPagedScrollViewController alloc] initWithNibName:nil bundle:nil];
    
    subject.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 470.0f);
    [subject.view drawRect:subject.view.frame];
    
    subject.dataSource = [[[SDFACTPagedScrollViewControllerDataSourceMock alloc] init] autorelease];
    
    [subject viewDidLoad];
    [subject viewDidAppear:NO];

    NSInteger currentPage = subject.currentPage;
    NSInteger newPage     = currentPage + 1;
    
    CGPoint contentOffset = subject.scrollView.contentOffset;
    
    STAssertEquals(0.0f, contentOffset.x, @"x offset should be zero at initialization");
    
    [subject displayPage:newPage animated:NO];

    contentOffset = subject.scrollView.contentOffset;
    STAssertEquals((subject.view.frame.size.width * newPage), contentOffset.x, @"x offset should equal: %f, got: %f", (subject.view.frame.size.width * newPage), contentOffset.x);
}

@end
