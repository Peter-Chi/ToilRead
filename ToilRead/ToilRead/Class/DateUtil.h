//
//  DateUtil.h
//  ToilRead
//
//  Created by Peter on 16/9/1.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+ (NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format;
+ (NSString*)dateString:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)dateIdentifierNow;
+ (NSString*)dateString:(NSString*)originalStr fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat;
+ (NSString*)appendWeekStringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
