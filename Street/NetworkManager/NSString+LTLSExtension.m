//
//  NSString+LTLSExtension.m
//

#import "NSString+LTLSExtension.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
#define setOfCharacterAndNumber                 @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

@implementation NSString (LTLSExtension)

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:nil] || [string isEqual:Nil]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (0 == [string length]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if([string isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
}

+(NSString *)encodeToPercentEscapeString:(NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
+(NSString *)decodeEscapeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
    
//    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encodedString, CFSTR("")));
}

//URL解码
+ (NSString *)URLDecodedStringWithOriURLString:(NSString *)oriURLString
{
    NSString *result = [(NSString *)oriURLString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)base64EncodedStringWithOriURLString:(NSString *)oriURLString
{
    NSData *data = [oriURLString dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString*)safeUrlBase64Encode:(NSString *)str {
    
    NSString * base64Str = [NSString base64EncodedStringWithOriURLString:str];
    NSMutableString * safeBase64Str = [[NSMutableString alloc] initWithString:base64Str];
    safeBase64Str = (NSMutableString * )[safeBase64Str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    safeBase64Str = (NSMutableString * )[safeBase64Str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return safeBase64Str;
}

+ (NSString *)base64DecodedStringWithOriURLString:(NSString *)oriURLString
{
    NSData *data = [[NSData  alloc]initWithBase64EncodedString:oriURLString options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

//检验是否手机号
-(BOOL)checkPhoneNumInput{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188 (147 178)
     * 联通：130,131,132,152,155,156,185,186 (145 176)
     * 电信：133,1349,153,180,189 (177 181)
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[678]|8[0125-9])\\d{8}$";;
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[7]|5[017-9]|7[8]|8[123478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[5]|5[256]|7[6]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349|77)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)){
        return YES;
    }
    else{
        return NO;
    }
}
- (NSString *)stringByTrimmingSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (NSString*)filterCharacterAndNumber
{
    NSMutableString *retString = [NSMutableString string];
    
    NSRange range;
    for (int i = 0; i < self.length; i+= range.length) {
        range  = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [self substringWithRange:range];
        if ([s isCharacterOrNumber]) {
            [retString appendString:s];
        }
    }
    
    return retString;
}

- (BOOL)isCharacterOrNumber
{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:setOfCharacterAndNumber];
    s = [s invertedSet];
    NSRange r = [self rangeOfCharacterFromSet:s];
    if (r.location !=NSNotFound)
    {
        return NO;
    }
    else{
        return YES;
    }
}

//! c语言判断方式
- (BOOL)isNumber
{
    if (!self || [self isEqualToString:@""]) {     //先处理为空的情况
        return NO;
    }
    else{
        unichar c;
        for (int i=0; i<self.length; i++) {
            c=[self characterAtIndex:i];
            if (!isdigit(c)) {
                return NO;
            }
        }
        return YES;
    }
}


#pragma mark - 计算文本的宽高
//计算文本的宽高

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{

    if ([NSString isBlankString:string]) {
        string = @"";
    }
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (CGSize)getSpaceLabelHeight:(NSString *)string font:(UIFont*)font maxSize:(CGSize)maxSize {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 7;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
    //                         };
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+ (CGSize)getSpaceLabelHeight:(NSString *)string font:(UIFont*)font maxSize:(CGSize)maxSize withlineSpacing:(float)lineSpacing {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
    //                         };
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

//判断字符串是否过万
+ (NSString *)judgeCurrentCountString:(NSString *)countString isHandleCount:(NSInteger)handleCout{
    
    NSString *newCountString = @"";
    if ([countString hasSuffix:@"w"]) {
        newCountString = countString;
    }
    else {
        newCountString = [NSString stringWithFormat:@"%ld",[countString integerValue] + handleCout];
    }
    return newCountString;
}

/**
 判断当前URL是否含有http
 */
+ (BOOL)judgeCurrentURLIsHasHttp:(NSString *)currentURLString {
    
    if (![currentURLString isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL flag = NO;
    if ([currentURLString hasPrefix:@"http://"] || [currentURLString hasPrefix:@"https://"]) {
        flag = YES;
    }
    return flag;
}

@end

@implementation UIColorTransform

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
    
}



@end
