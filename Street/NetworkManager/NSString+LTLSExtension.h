//
//  NSString+LTLSExtension.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LTLSExtension)

+ (BOOL)isBlankString:(NSString *)string;
+(NSString *)encodeToPercentEscapeString:(NSString *)input;
+(NSString *)decodeEscapeString:(NSString*)encodedString;

//编码base64
+ (NSString *)base64EncodedStringWithOriURLString:(NSString *)oriURLString;
+ (NSString *)base64DecodedStringWithOriURLString:(NSString *)oriURLString;

//编码base64安全编码
+ (NSString*)safeUrlBase64Encode:(NSString *)str;

//检验是否手机号
-(BOOL)checkPhoneNumInput;
- (NSString *)stringByTrimmingSpace;

//! 只留字母和数字字符
- (NSString*) filterCharacterAndNumber;
//! 判断是否为数字
- (BOOL)isNumber;

/**
 计算系统默认的字符串宽高

 @param string 当前内容
 @param font 当前字体
 @param maxSize 当前最大宽高
 @return 返回宽高
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (CGSize)getSpaceLabelHeight:(NSString *)string font:(UIFont*)font maxSize:(CGSize)maxSize withlineSpacing:(float)lineSpacing;
/**
 可以设置字间距和行间距,以及分行等各种属性

 @param string 当前内容
 @param font 当前字体
 @param maxSize 当前最大宽高
 @return 返回设置各种属性后的新宽高
 */
+ (CGSize)getSpaceLabelHeight:(NSString *)string font:(UIFont*)font maxSize:(CGSize)maxSize;


/**
 判断字符串是否过万
 
 @param countString 当前需要处理的字符串
 @param handleCout 计算加减的数
 @return 返回处理后的字符串
 */
+ (NSString *)judgeCurrentCountString:(NSString *)countString isHandleCount:(NSInteger)handleCout;


/**
 判断当前URL是否含有http

 @param currentURLString 当前URL链接
 @return 返回是否含有
 */
+ (BOOL)judgeCurrentURLIsHasHttp:(NSString *)currentURLString;

@end

@interface UIColorTransform : NSObject

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;


@end
