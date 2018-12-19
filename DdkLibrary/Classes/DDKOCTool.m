//
//  DDKOCTool.m
//  MainProject
//
//  Created by 尚软科技 on 2018/8/9.
//  Copyright © 2018年 cnsunrun. All rights reserved.
//

#import "DDKOCTool.h"

@implementation DDKOCTool

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSDate *)dateFromDateStr:(NSString *)dateStr{
//    NSString *dateStr = @"2016-7-16 09:33:22";
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *data = [format dateFromString:dateStr];
//    NSString *newString = [format stringFromDate:data];
    return data;
}
+ (NSString *)dateStrFormDate:(NSDate *)date{
//    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *string = [format stringFromDate:date];
    return string;
}
+ (NSString *)dateIntervalStrMinDate:(NSDate *)minD MaxDate:(NSDate *)maxD{
    //比较日期大小
    NSInteger comIndex = [self compareOneDate:minD anotherDate:maxD];
    if (comIndex > 0) {
        NSDate * midD = minD;
        minD = maxD;
        maxD = midD;
    }
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
//    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;//同时比较年、月、日、时、分、秒差异
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth;//同时比较天数、月份差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:minD toDate:maxD options:0];
//    return [NSString stringWithFormat:@"间隔%ld年%ld月%ld日%ld时%ld分%ld秒",delta.year,delta.month,delta.day,delta.hour,delta.minute,delta.second];
    return [NSString stringWithFormat:@"%ld个月%ld天",delta.month,delta.day];
}
+(int)compareOneDate:(NSDate *)oneD anotherDate:(NSDate *)anotherD{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *oneDayStr = [dateFormatter stringFromDate:oneD];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherD];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
//        dateA > dateB
        return 1;
    }
    else if (result == NSOrderedAscending){
//        dateA < dateB
        return -1;
    }
//    dateA == dateB
    return 0;
}

@end
