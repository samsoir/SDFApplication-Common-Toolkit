//
//  NSDate+UTCISO8601.h
//  SDFApplicationCommonToolkit
//
//  Created by Sam de Freyssinet on 10/10/12.
//  Copyright (c) 2012 Maison de Freyssinet. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SDFApplicationCommonToolkit_NSDate_UTCISO8601_h
#define SDFApplicationCommonToolkit_NSDate_UTCISO8601_h

extern NSString *const NSDateUTCISO8601FormatString;

@interface NSDateFormatter (UTCISO8601)

+ (NSDateFormatter *)utcISO8601DateFormatter;

@end

@interface NSDate (UTCISO8601)

+ (NSDate *)dateFromUTCISO8601String:(NSString *)dateString;
+ (NSString *)utcISO8601StringFromDate:(NSDate *)date;

@end

#endif