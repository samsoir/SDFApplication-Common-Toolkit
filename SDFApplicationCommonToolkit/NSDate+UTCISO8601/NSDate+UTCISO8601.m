//
//  NSDate+UTCISO8601.m
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 10/10/12.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import "NSDate+UTCISO8601.h"

NSString *const NSDateUTCISO8601FormatString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

@implementation NSDateFormatter (UTCISO8601)

+ (NSDateFormatter *)utcISO8601DateFormatter
{
    static NSDateFormatter *utcISO8601DateFormatter;
    
    if (utcISO8601DateFormatter == nil)
    {
        utcISO8601DateFormatter = [[NSDateFormatter alloc] init];
        [utcISO8601DateFormatter setDateFormat:NSDateUTCISO8601FormatString];
        [utcISO8601DateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    
    return utcISO8601DateFormatter;
}

@end

@implementation NSDate (UTCISO8601)

+ (NSDate *)dateFromUTCISO8601String:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [NSDateFormatter utcISO8601DateFormatter];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)utcISO8601StringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter utcISO8601DateFormatter];

    return [dateFormatter stringFromDate:date];
}

@end
