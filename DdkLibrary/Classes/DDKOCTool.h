//
//  DDKOCTool.h
//  MainProject
//
//  Created by 尚软科技 on 2018/8/9.
//  Copyright © 2018年 cnsunrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDKOCTool : NSObject
//时间戳转时间
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
//string转date
+ (NSDate *)dateFromDateStr:(NSString *)dateStr;
//date转string
+ (NSString *)dateStrFormDate:(NSDate *)date;
//计算间隔:date1,date2
+ (NSString *)dateIntervalStrMinDate:(NSDate *)minD MaxDate:(NSDate *)maxD;
//比较日期大小
+(int)compareOneDate:(NSDate *)oneD anotherDate:(NSDate *)anotherD;


@end
