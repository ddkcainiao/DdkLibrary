//
//  DDKOCTool.m
//  MainProject
//
//  Created by 尚软科技 on 2018/8/9.
//  Copyright © 2018年 cnsunrun. All rights reserved.
//

#import "DDKOCTool.h"
#import <CommonCrypto/CommonDigest.h>//md5
#import <CoreText/CoreText.h>//计算行数
#import <Accelerate/Accelerate.h>//高斯模糊

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

#pragma mark - 显示提示视图
+ (void)showAtTop:(NSString *)message
{
    [self show:message atTop:YES showTime:2.0];
}
+ (void)show:(NSString *)message
{
    [self show:message atTop:NO showTime:2.0];
}
+ (void)showLongAtTop:(NSString *)message
{
    [self show:message atTop:YES showTime:4.0];
}
+ (void)showLong:(NSString *)message
{
    [self show:message atTop:NO showTime:4.0];
}
static UILabel *toastView = nil;
+ (void)show:(NSString *)message atTop:(BOOL)atTop showTime:(float)showTime
{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:message atTop:atTop showTime:showTime];
        });
        return;
    }
    @synchronized(self){
        if (toastView == nil) {
            toastView = [[UILabel alloc] init];
            toastView.backgroundColor = [UIColor darkGrayColor];
            toastView.textColor = [UIColor whiteColor];
            toastView.font = [UIFont systemFontOfSize:15];
            toastView.layer.masksToBounds = YES;
            toastView.layer.cornerRadius = 3.0f;
            toastView.textAlignment = NSTextAlignmentCenter;
            toastView.alpha = 0;
            toastView.numberOfLines = 0;
            toastView.lineBreakMode = NSLineBreakByCharWrapping;
            [[UIApplication sharedApplication].keyWindow addSubview:toastView];
        }
    }
//    if (toastView.superview != [UIApplication sharedApplication].keyWindow) {
        [toastView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:toastView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:toastView];
//    }
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    CGFloat width = [self stringText:message font:16 isHeightFixed:YES fixedValue:30];
    CGFloat height = 30;
    if (width > screenWidth - 20) {
        width = screenWidth - 20;
        height = [self stringText:message font:16 isHeightFixed:NO fixedValue:width];
    }
    
    CGRect frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-width)/2, atTop?[UIScreen mainScreen].bounds.size.height*0.15:[UIScreen mainScreen].bounds.size.height*0.85, width, height);
    toastView.alpha = 1;
    toastView.text = message;
    toastView.frame = frame;
    [UIView animateWithDuration:showTime animations:^{
        toastView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}
//根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)text font:(CGFloat)font isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue
{
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    
    CGSize resultSize;
    //返回计算出的size
    resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size;
    
    if (isHeightFixed) {
        return resultSize.width;
    } else {
        return resultSize.height;
    }
}

+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}
+ (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
+ (void)configLabelLineSpace:(CGFloat)lineSpace lab:(UILabel *)lab content:(NSString *)content{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpace];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [content length])];
    [lab setAttributedText:attributedString1];
    [lab sizeToFit];
}

+ (void)setLabelSpace:(UILabel*)label line:(CGFloat)lineSpace str:(NSString*)str font:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

+ (CGFloat)getSpaceLabelHeight:(NSString*)str line:(CGFloat)lineSpace font:(UIFont*)font wid:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+ (BOOL)isAnZhuangWechat{
    BOOL has_weicaht = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    return has_weicaht;
}
+ (BOOL)isAnZhuangQQ{
    BOOL has_qq = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    return has_qq;
}

+ (NSString *)md5String:(NSString *) str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (void)jumpToOtherVC:(UIViewController *)otherVC{
    UIViewController * viewController = [self getCurrentVC];
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)viewController;
        UINavigationController *selectVC = tabController.selectedViewController;
        UIViewController *frontVC = selectVC.viewControllers.lastObject;
        if ([frontVC.navigationController respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
            [frontVC.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [frontVC dismissViewControllerAnimated:NO completion:nil];
        }
        [selectVC pushViewController:otherVC animated:NO];
    }
}

+ (void)removeScrollOfWebView:(UIWebView *)webView{
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
}

+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (void)callToOthers:(UIViewController *)vc phoneNo:(NSString *)phoneNo{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNo];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [vc.view addSubview:callWebview];
}

+ (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (void)checkUpdateWithAppID:(NSString *)appID appName:(NSString *)appName vc:(UIViewController *)vc cancle:(void (^)())cancle{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    NSString *encodingUrl=[[@"http://itunes.apple.com/lookup?id=" stringByAppendingString:appID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:encodingUrl parameters:nil error:nil];
    request.timeoutInterval = 30; //设置超时时间
    NSURLSessionDataTask *task = [manager GET:encodingUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[resultDic objectForKey:@"results"] count]) {
            NSString * versionStr =[[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"version"];
            NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
            NSString * currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
            if(![versionStr isEqualToString:currentVersion]){
                //需要更新
                NSString *alertMsg = [NSString stringWithFormat:@"%@v%@，赶快体验最新版本吧！",appName,versionStr];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    cancle();
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    //                https://itunes.apple.com/us/app/挖集/id1314132811?l=zh&ls=1&mt=8
                    NSString *iTunesLink =[[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"trackViewUrl"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                    
                }]];
                [vc presentViewController:alert animated:YES completion:nil];
            }else{
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [task resume];
}

//传入 秒 得到 时:分:秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

+ (NSDictionary *)ccGetCityArr:(NSMutableArray *)oldArr{
    NSMutableArray * cityArr = [NSMutableArray array];
    [oldArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cityArr addObjectsFromArray:obj[@"_city"]];
    }];
    
    //ddk:自己找首字母---也可以根据后台返回的来
    [cityArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * firStr = [self ccGetFirstChar:obj[@"title"]];
        NSMutableDictionary * tDic = [NSMutableDictionary dictionaryWithDictionary:obj];
        tDic[@"first_char"] = firStr;
        [cityArr replaceObjectAtIndex:idx withObject:tDic];
    }];
    
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    NSDictionary * sortDic = [self ccSortModelArray:cityArr];
    resultDic[@"secArr"] = sortDic[@"secArr"];
    resultDic[@"modelArr"] = sortDic[@"modelArr"];
    return resultDic;
}

+ (NSMutableArray *)ccGetAreaList:(NSString *)Id adCode:(NSString *)adCode cityArr:(NSMutableArray *)cityArr{
    __block NSMutableArray * areaArr = [NSMutableArray array];
    [cityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSMutableArray class]]) {
            [obj enumerateObjectsUsingBlock:^(NSDictionary * s_obj, NSUInteger s_idx, BOOL * _Nonnull s_stop) {
                if ([s_obj[@"id"] isEqualToString:Id] && [s_obj[@"adcode"] isEqualToString:adCode]) {
                    areaArr = [NSMutableArray arrayWithArray:s_obj[@"_city"]];
                    *s_stop = YES;
                    *stop = YES;
                }
            }];
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            //搜索
            if ([obj[@"id"] isEqualToString:Id] && [obj[@"adcode"] isEqualToString:adCode]) {
                areaArr = [NSMutableArray arrayWithArray:obj[@"_city"]];
                *stop = YES;
            }
        }
    }];
    return areaArr;
}

+ (NSMutableArray *)ccGetAreaListWithCityName:(NSString *)cityN cityArr:(NSMutableArray *)cityArr{
    __block NSMutableArray * areaArr = [NSMutableArray array];
    [cityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSMutableArray class]]) {
            [obj enumerateObjectsUsingBlock:^(NSDictionary * s_obj, NSUInteger s_idx, BOOL * _Nonnull s_stop) {
                if ([s_obj[@"title"] isEqualToString:cityN]) {
                    areaArr = [NSMutableArray arrayWithArray:s_obj[@"_city"]];
                    *s_stop = YES;
                    *stop = YES;
                }
            }];
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"title"] isEqualToString:cityN]) {
                areaArr = [NSMutableArray arrayWithArray:obj[@"_city"]];
                *stop = YES;
            }
        }
    }];
    return areaArr;
}

+ (NSString *)ccGetFirstChar:(NSString *)str{
    NSMutableString *ms = [[NSMutableString alloc]initWithString:str];//带声仄 //不能注释掉
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformMandarinLatin, NO)) {
        //                        NSLog(@"pinyin: ---- %@", ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO)) {
        NSString *bigStr = [ms uppercaseString]; // bigStr 是转换成功后的拼音
        NSString *cha = [bigStr substringToIndex:1];
        return cha; // cha 是汉字的首字母
    }
    return @"";
}

+ (NSDictionary *)ccSortModelArray:(NSMutableArray *)modelArr{
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    NSMutableArray * arr = [NSMutableArray array];
    NSMutableArray * indexArray = [NSMutableArray array];
    for(int i='A';i<='Z';i++){
        NSMutableArray * rulesArr = [NSMutableArray array];
        NSString *str1=[NSString stringWithFormat:@"%c",i];
        for(int j=0;j<modelArr.count;j++){
            NSDictionary * model = modelArr[j];
            if ([model[@"first_char"] isEqualToString:str1]) {
                [rulesArr addObject:model]; //把首字母相同的人物model 放到同一个数组里面
                [modelArr removeObject:model];//model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
                j--;
            }
        }
        if (rulesArr.count !=0) {
            [arr addObject:rulesArr];
            [indexArray addObject:[NSString stringWithFormat:@"%c",i]]; //把大写字母也放到一个数组里面
        }
    }
    if (modelArr.count !=0) {
        [arr addObject:modelArr];
        [indexArray addObject:@"#"]; //把首字母不是A~Z里的字符全部放到 array里面 然后返回
    }
    resultDic[@"secArr"] = indexArray;
    resultDic[@"modelArr"] = arr;
    return resultDic;
}

@end
