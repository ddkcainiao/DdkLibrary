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

#pragma mark - 显示提示视图
//显示提示视图, 默认显示在屏幕上方，防止被软键盘覆盖，1.5s后自动消失
+ (void)showAtTop:(NSString *)message;
//显示提示视图, 默认显示在屏幕下方，1.5s后自动消失
+ (void)show:(NSString *)message;
//显示提示视图, 默认显示在屏幕上方，防止被软键盘覆盖,3s后自动消失
+ (void)showLongAtTop:(NSString *)message;
//显示提示视图, 默认显示在屏幕下方,3s后自动消失
+ (void)showLong:(NSString *)message;

//含中文URL编码
+ (NSString *)URLEncodedString:(NSString *)str;
//URL解码
+(NSString *)URLDecodedString:(NSString *)str;

//行间距
+ (void)configLabelLineSpace:(CGFloat)lineSpace lab:(UILabel *)lab content:(NSString *)content;
//给UILabel设置行间距和字间距
+ (void)setLabelSpace:(UILabel*)label line:(CGFloat)lineSpace str:(NSString*)str font:(UIFont*)font;
//计算UILabel的高度(带有行间距的情况)
+ (CGFloat)getSpaceLabelHeight:(NSString*)str line:(CGFloat)lineSpace font:(UIFont*)font wid:(CGFloat)width;

//判断是否安装微信
+ (BOOL)isAnZhuangWechat;
//是否安装QQ
+ (BOOL)isAnZhuangQQ;

//md5加密
+ (NSString *)md5String:(NSString *) str;

//获取当前屏幕VC
+ (UIViewController *)getCurrentVC;

//跳转到其他页面
+ (void)jumpToOtherVC:(UIViewController *)otherVC;

//移除webview的滚动条
+ (void)removeScrollOfWebView:(UIWebView *)webView;

//计算行数
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;

//高斯模糊
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//打电话
+ (void)callToOthers:(UIViewController *)vc phoneNo:(NSString *)phoneNo;

//字典or数组转json数据
+ (NSData *)toJSONData:(id)theData;

//检查版本更新
+ (void)checkUpdateWithAppID:(NSString *)appID appName:(NSString *)appName vc:(UIViewController *)vc cancle:(void (^)())cancle;

//传入 秒 得到 时:分:秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

/********************
 冷链
 ********************/
//获取城市
+ (NSDictionary *)ccGetCityArr:(NSMutableArray *)oldArr;
//获取区县 根据城市id/code
+ (NSMutableArray *)ccGetAreaList:(NSString *)Id adCode:(NSString *)adCode cityArr:(NSMutableArray *)cityArr;
//获取区县 根据城市名
+ (NSMutableArray *)ccGetAreaListWithCityName:(NSString *)cityN cityArr:(NSMutableArray *)cityArr;
//汉字转拼音
+ (NSString *)ccGetFirstChar:(NSString *)str;
//根据拼音首字母 对汉字进行排序 返回：secArr  modelArr
+ (NSDictionary *)ccSortModelArray:(NSMutableArray *)modelArr;

@end
