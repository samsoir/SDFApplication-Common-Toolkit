//
//  SDFACTNSDateUTCISO8601Tests.m
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 10/22/12.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import "SDFACTNSDateUTCISO8601Tests.h"
#import "NSDate+UTCISO8601.h"

@implementation SDFACTNSDateUTCISO8601Tests

- (NSDateComponents *)dateComponents
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:1981];
    [dateComponents setMonth:8];
    [dateComponents setDay:15];
    [dateComponents setHour:21];
    [dateComponents setMinute:30];
    [dateComponents setSecond:0];

    return dateComponents;
}

- (NSCalendar *)calendarForLocale:(NSLocale *)locale
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:locale];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

    return calendar;
}

- (void)testUtcISO8601DateFormatter
{
    return;
    
    NSDateFormatter *dateFormatCurrent = [NSDateFormatter utcISO8601DateFormatter];
    
    STAssertNotNil(dateFormatCurrent, @"Date formatter should not be nil");
    
    NSDateFormatter *dateFormatCurrent2 = [NSDateFormatter utcISO8601DateFormatter];
    
    STAssertEqualObjects(dateFormatCurrent, dateFormatCurrent2, @"NSDateFormatter should only produce one formatter per locale");    
}

- (void)testDateFromUTCISO8601StringLocale
{
    return;
    
    NSLocale *UTCLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"UTC"] autorelease];
    
    NSDateComponents *dateComponents = [self dateComponents];
    NSCalendar *calendar = [self calendarForLocale:UTCLocale];
    
    NSString *dateString       = @"1981-08-15T21:30:00Z";

    NSDate *dateRepresentation = [calendar dateFromComponents:dateComponents];
    
    NSDate *computedDateFromString = [NSDate dateFromUTCISO8601String:dateString];
    
    STAssertTrue([dateRepresentation isEqualToDate:computedDateFromString], @"Date: %@ should be equal to computed date from string %@", dateRepresentation, computedDateFromString);
}

- (void)testUtcISO8601StringFromDateLocale
{
    return;

    NSLocale *UTCLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"UTC"] autorelease];

    NSDateComponents *dateComponents = [self dateComponents];
    NSCalendar *calendar = [self calendarForLocale:UTCLocale];

    NSString *dateString       = @"1981-08-15T21:30:00Z";

    NSDate *dateRepresentation = [calendar dateFromComponents:dateComponents];
    
    NSString *computedStringFromDate = [NSDate utcISO8601StringFromDate:dateRepresentation];
    
    STAssertTrue([dateString isEqualToString:computedStringFromDate], @"Date: %@ should be equal to computed date from string %@", dateString, computedStringFromDate);
}

@end
