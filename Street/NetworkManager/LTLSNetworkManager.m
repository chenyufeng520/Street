//
//  LTLSNetworkManager.m
//

#import "LTLSNetworkManager.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFURLRequestSerialization.h"
#import "LTLSSettingManager.h"
#import "KeychainUUID.h"
#import "NSString+LTLSExtension.h"
#import <CommonCrypto/CommonDigest.h>

#define kUIScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kUIScreenHeight [[UIScreen mainScreen] bounds].size.height

static NSString * const baseURL = @"http://47.96.237.239:8080";//测试环境
//static NSString * const baseURL = @"https://api.xi5jie.com";//正式环境

static NSString * const app_key = @"jyjxs";
static NSString * const miyao_str = @"asdfgwgwbfew";
static NSString * const paiChannel = @"AppStore";
static NSString * const paiPlatform = @"ios";
static NSString * const paiAppVer = @"20300";
static NSString * const paiVer = @"20300";
//static NSString * const User-Agent = @"0301";

static NSString * userAgent = @"";
static NSMutableDictionary * signDic ;
// Copy From AFNetworking
static NSString * const kLTLSCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * LTLSPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kLTLSCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * LTLSPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kLTLSCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@interface LTLSNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

@property (nonatomic, strong) NSMutableDictionary *baseParams;

@end

@implementation LTLSNetworkManager

#pragma mark - LifeCycle

+ (instancetype)sharedNetworkManager
{
    static LTLSNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTLSNetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.baseParams = [NSMutableDictionary dictionaryWithCapacity:6];
        
    }
    return self;
}

//获取appinfo
- (NSDictionary *)getAppInfoData {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
    [dic addEntriesFromDictionary:@{@"paiVer":paiVer}];
    [dic addEntriesFromDictionary:@{@"paiAppVer":paiAppVer}];
    [dic addEntriesFromDictionary:@{@"paiChannel":paiChannel}];
    [dic addEntriesFromDictionary:@{@"paiPlatform":paiPlatform}];
    [dic addEntriesFromDictionary:@{@"paiScreen":[self getCurrentScreen]}];
    [dic addEntriesFromDictionary:@{@"User-Agent":[self defaultUserAgentString]}];
    
    NSString * token = [LTLSSettingManager getStringTokenFromUserDefaults];
    if (![ NSString isBlankString:token]) {
        [dic addEntriesFromDictionary:@{@"paiSession":token}];
    }
    
    NSString * timeStr = [self getCurrentTimeInterval];
    [dic addEntriesFromDictionary:@{@"paiTime":timeStr}];
    
    return dic;
}

- (void)addbaseParement:(NSDictionary*)parmDic andBodyData:(NSData *)data andrequestType:(NSString*)requestType andTimeStr:(NSString*)timeStr{
    //paiSession  paiTime
    if(!signDic){
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
        [dic addEntriesFromDictionary:@{@"paiVer":paiVer}];
        [dic addEntriesFromDictionary:@{@"paiAppVer":paiAppVer}];
        [dic addEntriesFromDictionary:@{@"paiChannel":paiChannel}];
        [dic addEntriesFromDictionary:@{@"paiPlatform":paiPlatform}];
        [dic addEntriesFromDictionary:@{@"paiScreen":[self getCurrentScreen]}];
        [dic addEntriesFromDictionary:@{@"User-Agent":[self defaultUserAgentString]}];
        
        signDic = [dic mutableCopy];
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
    [dic addEntriesFromDictionary:signDic];
    NSString * token = [LTLSSettingManager getStringTokenFromUserDefaults];
    if (![ NSString isBlankString:token]) {
        [dic addEntriesFromDictionary:@{@"paiSession":token}];
    }
    NSString * paiInstallCode = [LTLSSettingManager getStringValueFromUserDefaults:@"PaiInstall"];
    if (![NSString isBlankString:paiInstallCode]) {
        [dic addEntriesFromDictionary:@{@"paiInstall":paiInstallCode}];
    }
    [dic addEntriesFromDictionary:@{@"paiTime":timeStr}];
    if ([requestType isEqualToString:@"get"]) {
        if(parmDic){
            [dic addEntriesFromDictionary:parmDic];
        }
    }
    
    NSString * signStr = [self sortedDictionary:dic];
    signStr = [signStr stringByAppendingString:@"&secret=QiFRxdws2AHcke3WvBoUV9qYp6J0ab4y"];
    //    NSData * signData = [signStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString * md5;
    if ([requestType isEqualToString:@"get"]) {
        NSLog(@"md5 Str == %@",signStr);
        md5 = [self getmd5WithString:signStr];
    }else{
        
        NSString * parmDicStr = [self sortedDictionary:parmDic];
        
        signStr = [signStr stringByAppendingString:parmDicStr];
        NSLog(@"md5 Str == %@",signStr);
        md5 = [self getmd5WithString:signStr];
    }
    [self.requestManager.requestSerializer setValue:md5 forHTTPHeaderField:@"paiSign"];
}
- (void)addrequestrHeadMsg:(NSDictionary*)parmDic andBodyData:(NSData *)data andrequestType:(NSString*)requestType{
    NSString * timeStr = [self getCurrentTimeInterval];
    NSString * token = [LTLSSettingManager getStringTokenFromUserDefaults];
    if (![ NSString isBlankString:token]) {
        [self.requestManager.requestSerializer setValue:token forHTTPHeaderField:@"paiSession"];
    }
    else{
        [self.requestManager.requestSerializer setValue:@"" forHTTPHeaderField:@"paiSession"];
    }
    NSString * paiInstallCode = [LTLSSettingManager getStringValueFromUserDefaults:@"PaiInstall"];
    if (![NSString isBlankString:paiInstallCode]) {
        [self.requestManager.requestSerializer setValue:paiInstallCode forHTTPHeaderField:@"paiInstall"];
    }
    [self.requestManager.requestSerializer setValue:paiVer forHTTPHeaderField:@"paiVer"];
    [self.requestManager.requestSerializer setValue:paiPlatform forHTTPHeaderField:@"paiPlatform"];
    [self.requestManager.requestSerializer setValue:paiAppVer forHTTPHeaderField:@"paiAppVer"];
    [self.requestManager.requestSerializer setValue:paiChannel forHTTPHeaderField:@"paiChannel"];
    [self.requestManager.requestSerializer setValue:timeStr forHTTPHeaderField:@"paiTime"];
    [self.requestManager.requestSerializer setValue:[self getCurrentScreen] forHTTPHeaderField:@"paiScreen"];
    [self.requestManager.requestSerializer setValue:[self defaultUserAgentString] forHTTPHeaderField:@"User-Agent"];
    [self addbaseParement:parmDic andBodyData:data andrequestType:requestType andTimeStr:timeStr];
    //        manager.requestSerializer.HTTPRequestHeaders =
    //    NSString * vers = [self defaultUserAgentString];
}
- (NSString *)defaultUserAgentString

{
    if([NSString isBlankString:userAgent]){
        
        NSString *OSName;
        
        NSString *OSVersion;
        
        NSString *locale = [[NSLocale currentLocale] localeIdentifier];
        
        
        UIDevice *device = [UIDevice currentDevice];
        
        OSName = [device systemName];
        NSString* deviceModel = [device model];
        OSVersion = [device systemVersion];
        
        // Takes the form "My Application 1.0 (Macintosh; Mac OS X 10.5.7; en_GB)"
        //系统信息、手机品牌、语言、应用版本、屏幕、唯一标示
        KeychainUUID *keychain = [[KeychainUUID alloc] init];
        id data = [keychain readUDID];
        userAgent =  [NSString stringWithFormat:@"%@%@;%@;%@;%@/%@;%@;%@",OSName,OSVersion,deviceModel,locale, paiAppVer,[self getSystemVersion],[self getCurrentScreen],data];
    }
    return userAgent;
}

/**
 获取版本号
 */
- (NSString *)getSystemVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
    
}

- (NSDictionary *)baseParameterDict {
    NSMutableDictionary *mDict = [self.baseParams mutableCopy];
    return mDict;
}


- (NSString*)getCurrentTimeInterval{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    long long theTime = [[NSNumber numberWithDouble:nowTime] longLongValue];
    //当前时间毫秒数
    NSString *currentTime = [NSString stringWithFormat:@"%llu",theTime];
    return currentTime;
}
- (NSString*)getCurrentScreen{
    NSString * width = [NSString stringWithFormat:@"%d",(int)kUIScreenWidth];
    NSString * height = [NSString stringWithFormat:@"%d",(int)kUIScreenHeight];
    NSString * currentS = [NSString stringWithFormat:@"%@x%@",width,height];
    return currentS;
}

- (NSURLSessionTask *)get:(NSString *)urlString parameters:(NSDictionary *)parameters success:(LTLSNetworkSuccessBlock)success failure:(LTLSNetworkFailureBlock)failure
{
    
    NSMutableDictionary *parMutable = [NSMutableDictionary dictionaryWithCapacity:4];
    [parMutable addEntriesFromDictionary:parameters];
    for (NSString * keyStr in parMutable.allKeys) {
        NSString * value = [parMutable objectForKey:keyStr];
        if ([NSString isBlankString:value]) {
            [parMutable removeObjectForKey:keyStr];
        }
    }
    
    NSString * url = [self getEntireRequestURL:urlString];;
    
    NSMutableString *query = [@"" mutableCopy];
    NSMutableString *encodedQuery = [@"" mutableCopy];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    
    [mDict addEntriesFromDictionary:parMutable];
    
    NSArray *keyArr = [mDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in keyArr) {
        NSString *value = mDict[key];
        NSString *encodedKey = LTLSPercentEscapedQueryStringKeyFromStringWithEncoding(key, NSUTF8StringEncoding);
        NSString *encodedValue = LTLSPercentEscapedQueryStringValueFromStringWithEncoding(value, NSUTF8StringEncoding);
        [query appendString:[NSString stringWithFormat:@"%@=%@&", encodedKey, encodedValue]];
        [encodedQuery appendString:[NSString stringWithFormat:@"%@=%@&", encodedKey, encodedValue]];
    }
    if (query.length) {
        [query deleteCharactersInRange:NSMakeRange(query.length - 1, 1)];
        [encodedQuery deleteCharactersInRange:NSMakeRange(encodedQuery.length - 1, 1)];
        [query insertString:[NSString stringWithFormat:@"%@%@",[self getMainDomain],urlString] atIndex:0];
        url = [[url stringByAppendingString:@"?"] stringByAppendingString:encodedQuery];
        
    }
    
    [self addrequestrHeadMsg:parMutable andBodyData:nil andrequestType:@"get"];
    NSURLSessionTask *task = [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            // 成功逻辑，code为200成功，其余全部不解析  1003数据为空
            if ([responseObject[@"code"] integerValue] == 200 || [responseObject[@"code"] integerValue] == 1003) {
                if (success) {
                    success(task, responseObject);
                }
            }
            else {
                if (failure) {
                    failure(task, responseObject, nil);
                }
                
            }
            
        }
        else {
            if (failure) {
                failure(task, responseObject, nil);
            }
        }
        NSLog(@"get请求参数：%@ ========== 请求结果：%@",url,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(task, nil, error);
        }
        NSLog(@"get请求参数：%@ ========== 报错信息：%@",url,error);
    }];
    [task resume];
    return task;
    
    
}

- (NSURLSessionTask *)post:(NSString *)urlString parameters:(NSDictionary *)parameters success:(LTLSNetworkSuccessBlock)success failure:(LTLSNetworkFailureBlock)failure
{
    NSString * url = [self getEntireRequestURL:urlString];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    [mDict addEntriesFromDictionary:parameters];
    
    [self addrequestrHeadMsg:parameters andBodyData:nil andrequestType:@"post"];
    NSURLSessionTask *task = [self.requestManager POST:url parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data =    [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"post请求返回结果=%@=%@",url,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            // 成功逻辑，code为200成功，其余全部不解析
            if ([responseObject[@"code"] integerValue] == 200 || [responseObject[@"code"] integerValue] == 1003) {
                if (success) {
                    success(task, responseObject);
                }
            }
            else {
                if (failure) {
                    failure(task, responseObject, nil);
                }
            }
            
        }
        else {
            if (failure) {
                failure(task, responseObject, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, nil, error);
        }
    }];
    [task resume];
    return task;
    
}

- (NSURLSessionTask *)post:(NSString *)urlString BodyParameters:(NSString *)parameters success:(LTLSNetworkBodySuccessBlock)success failure:(LTLSNetworkBodyFailureBlock)failure
{
    NSString * url = [self getEntireRequestURL:urlString];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self addrequestrHeadMsg:nil andBodyData:parameters request:request];
    NSURLSessionTask *task = [self.requestManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (success) {
                success(responseObject);
            }
        }
        else {
            if (failure) {
                failure( responseObject, nil);
            }
        }
    }];
    [task resume];
    return task;
    
}

- (void)addbaseParement:(NSDictionary*)parmDic andBodyData:(NSString *)data request:(NSMutableURLRequest *)request andTimeS:(NSString *)timeS{
    //paiSession  paiTime
    if(!signDic){
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
        [dic addEntriesFromDictionary:@{@"paiVer":paiVer}];
        [dic addEntriesFromDictionary:@{@"paiAppVer":paiAppVer}];
        [dic addEntriesFromDictionary:@{@"paiChannel":paiChannel}];
        [dic addEntriesFromDictionary:@{@"paiPlatform":paiPlatform}];
        [dic addEntriesFromDictionary:@{@"paiScreen":[self getCurrentScreen]}];
        [dic addEntriesFromDictionary:@{@"User-Agent":[self defaultUserAgentString]}];
        
        signDic = [dic mutableCopy];
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:8];
    [dic addEntriesFromDictionary:signDic];
    NSString * token = [LTLSSettingManager getStringTokenFromUserDefaults];
    if (![ NSString isBlankString:token]) {
        [dic addEntriesFromDictionary:@{@"paiSession":token}];
    }
    NSString * paiInstallCode = [LTLSSettingManager getStringValueFromUserDefaults:@"PaiInstall"];
    if (![NSString isBlankString:paiInstallCode]) {
        [dic addEntriesFromDictionary:@{@"paiInstall":paiInstallCode}];
    }
    [dic addEntriesFromDictionary:@{@"paiTime":timeS}];
    
    NSString * signStr = [self sortedDictionary:dic];
    signStr = [signStr stringByAppendingString:@"&secret=QiFRxdws2AHcke3WvBoUV9qYp6J0ab4y"];
    
    NSString * md5;
    
    signStr = [signStr stringByAppendingString:data];
    NSLog(@"md5 Str == %@",signStr);
    md5 = [self getmd5WithString:signStr];
    
    [request setValue:md5 forHTTPHeaderField:@"paiSign"];
}
- (void)addrequestrHeadMsg:(NSDictionary*)parmDic andBodyData:(NSString *)data request:(NSMutableURLRequest *)request{
    NSString * timeS = [self getCurrentTimeInterval];
    NSString * token = [LTLSSettingManager getStringTokenFromUserDefaults];
    if (![ NSString isBlankString:token]) {
        [request setValue:token forHTTPHeaderField:@"paiSession"];
    }
    else{
        [request setValue:@"" forHTTPHeaderField:@"paiSession"];
    }
    NSString * paiInstallCode = [LTLSSettingManager getStringValueFromUserDefaults:@"PaiInstall"];
    if (![NSString isBlankString:paiInstallCode]) {
        [request setValue:paiInstallCode forHTTPHeaderField:@"paiInstall"];
    }
    [request setValue:paiVer forHTTPHeaderField:@"paiVer"];
    [request setValue:paiPlatform forHTTPHeaderField:@"paiPlatform"];
    [request setValue:paiAppVer forHTTPHeaderField:@"paiAppVer"];
    [request setValue:paiChannel forHTTPHeaderField:@"paiChannel"];
    [request setValue:timeS forHTTPHeaderField:@"paiTime"];
    [request setValue:[self getCurrentScreen] forHTTPHeaderField:@"paiScreen"];
    [request setValue:[self defaultUserAgentString] forHTTPHeaderField:@"User-Agent"];
    [self addbaseParement:parmDic andBodyData:data request:request andTimeS:timeS];
    //        manager.requestSerializer.HTTPRequestHeaders =
    //    NSString * vers = [self defaultUserAgentString];
}

//数据上报
- (NSURLSessionTask*)uploadUserActionLog:(NSDictionary * )params{
    NSString * url = [self getEntireRequestURL:@"api/system/uploadLog.json"];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    [mDict addEntriesFromDictionary:params];
    [self addrequestrHeadMsg:params andBodyData:nil andrequestType:@"post"];
    NSURLSessionTask *task = [self.requestManager POST:url parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data =    [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"上传日志返回结果=%@=%@",url,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [task resume];
    return task;
}
- (NSURLSessionTask *)post:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                  formData:(NSData *)imagedata
                   success:(LTLSNetworkSuccessBlock)success
                   failure:(LTLSNetworkFailureBlock)failure{
    
    
    NSString * url = [self getEntireRequestURL:urlString];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    [mDict addEntriesFromDictionary:parameters];
    [self addrequestrHeadMsg:parameters andBodyData:nil andrequestType:@"post"];
    NSURLSessionTask *task = [self.requestManager POST:url parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //            [formData appendPartWithFileData:imagedata name:@"img" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileURL:[mDict objectForKey:@"file"] name:@"file" error:nil];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //            NSDictionary *responseDict = (NSDictionary *)responseObject;
            //                if (responseDict[@"status"] && [responseDict[@"status"] boolValue]) {
            // 成功逻辑
            if (success) {
                success(task, responseObject);
            }
            //                }
            //                else {
            //                    if (failure) {
            //                        failure(task, responseObject, nil);
            //                    }
            //                }
        }
        else {
            if (failure) {
                failure(task, responseObject, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, nil, error);
        }
    }];
    [task resume];
    return task;
    
    
}

//批量图片上传
- (NSURLSessionTask *)uploadImages:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          formData:(NSMutableArray *)arrayImage
                           success:(LTLSNetworkSuccessBlock)success
                           failure:(LTLSNetworkFailureBlock)failure{
    
    
    NSString * url = [self getEntireRequestURL:urlString];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    [mDict addEntriesFromDictionary:parameters];
    [self addrequestrHeadMsg:parameters andBodyData:nil andrequestType:@"post"];
    NSURLSessionTask *task = [self.requestManager POST:url parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < arrayImage.count; i++) {
            
            
            NSString *fileName = [NSString stringWithFormat:@"%@%d", @"file",i];
            //            [formData appendPartWithFileData:data name:@"img" fileName:fileName mimeType:@"image/jpg"];
            [formData appendPartWithFileURL:[arrayImage objectAtIndex:i] name:fileName error:nil];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //            NSDictionary *responseDict = (NSDictionary *)responseObject;
            //                if (responseDict[@"status"] && [responseDict[@"status"] boolValue]) {
            // 成功逻辑
            if (success) {
                success(task, responseObject);
            }
            //                }
            //                else {
            //                    if (failure) {
            //                        failure(task, responseObject, nil);
            //                    }
            //                }
        }
        else {
            if (failure) {
                failure(task, responseObject, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, nil, error);
        }
    }];
    [task resume];
    return task;
    
    
}
- (NSURLSessionTask *)uploadImages:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          imageStr:(NSData *)imageStr
                           success:(LTLSNetworkSuccessBlock)success
                           failure:(LTLSNetworkFailureBlock)failure{
    
    NSString * url = [self getEntireRequestURL:urlString];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    [mDict addEntriesFromDictionary:parameters];
    [self addrequestrHeadMsg:parameters andBodyData:nil andrequestType:@"post"];
    NSURLSessionTask *task = [self.requestManager POST:url parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@", @"avatar"];
        [formData appendPartWithFileData:imageStr name:@"avatar" fileName:fileName mimeType:@"image/jpg"];
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageStr] name:fileName error:nil];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (success) {
                success(task, responseObject);
            }
        }
        else {
            if (failure) {
                failure(task, responseObject, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, nil, error);
        }
    }];
    [task resume];
    return task;
    
    
}
#pragma mark - Utils

- (NSString*)getMainDomain
{
    
    NSString *domain = baseURL;
    
    return domain;
}

- (NSString*)getEntireRequestURL:(NSString*)url
{
    //拼接
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",[self getMainDomain],url];
    return fullUrl;
}

- (NSURL *)getURLWithRoute:(NSString *)route parameters:(NSDictionary *)parameters {
    NSMutableString *query = [@"" mutableCopy];
    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
    [mDict addEntriesFromDictionary:parameters];
    for (NSString *key in mDict.allKeys) {
        NSString *value = mDict[key];
        [query appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    if (query.length) {
        [query deleteCharactersInRange:NSMakeRange(query.length - 1, 1)];
        NSString *routeQuery = [[route stringByAppendingString:@"?"] stringByAppendingString:query];
        NSString *urlString = [[self getMainDomain] stringByAppendingString:routeQuery];//
        return [NSURL URLWithString:urlString];
    }
    NSString *urlString = [[self getMainDomain] stringByAppendingString:route]; //
    return [NSURL URLWithString:urlString];
}


-(NSDictionary*)headerDic{
    return nil;
    //
}
#pragma mark - Getter

//v2.4 重构改getter方法（主域名在第一次请求后，可能发生变化；而baseURL为readOnly）
- (AFHTTPSessionManager *)requestManager
{
    if (!_requestManager) {
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self getMainDomain]]];//
        
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json",@"text/html", @"text/plain", @"text/json", nil];//
        manager.responseSerializer = serializer;
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = requestSerializer;
        
        if (!_requestManager) {
            _requestManager = manager;
            
//            //线上环境
//            NSString * cerpath = [[NSBundle mainBundle] pathForResource:@"*.xi5jie.com" ofType:@"cer"];
//            NSData * cerdata = [NSData dataWithContentsOfFile:cerpath];
//            _requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerdata, nil]];
//            _requestManager.securityPolicy.allowInvalidCertificates = YES;
//            [_requestManager.securityPolicy setValidatesDomainName:NO];
            
            //charles 抓接口时用
            //            _requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            //            _requestManager.securityPolicy.allowInvalidCertificates = YES;
            //            [_requestManager.securityPolicy setValidatesDomainName:NO];
            return _requestManager;
        }
        
    }
    
    return _requestManager;
}



- (void)refreshAFManager
{
    _requestManager = nil;
}
/**
 对字典(Key-Value)排序 区分大小写
 
 @param dict 要排序的字典
 */
- (NSString *)sortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    //    NSMutableArray *valueArray = [NSMutableArray array];
    NSString * str = @"";
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",sortsing,valueString]];
        //        [valueArray addObject:valueString];
    }
    if(str.length>0 && [str hasSuffix:@"&"]){
        str = [str substringToIndex:str.length-1];
    }
    NSLog(@"valueArray:%@",str);
    return str;
    
}

//#pragma mark - 数据埋点专用
//
//- (NSURLSessionTask *)dataPointPost:(NSString *)urlString parameters:(NSDictionary *)parameters success:(LTLSNetworkSuccessBlock)success failure:(LTLSNetworkFailureBlock)failure
//{
//    NSString * url = [NSString stringWithFormat:@"%@%@",HostDataPointBaseURLPath,urlString];
//    NSMutableDictionary *mDict = [[self baseParameterDict] mutableCopy];
//    [mDict addEntriesFromDictionary:parameters];
//    
//    [self addrequestrHeadMsg:parameters andBodyData:nil andrequestType:@"post"];
//    NSURLSessionTask *task = [self.requestManager POST:url parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//  
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            
//            // 成功逻辑，code为200成功，其余全部不解析
//            if ([responseObject[@"code"] integerValue] == 200 || [responseObject[@"code"] integerValue] == 1003) {
//                if (success) {
//                    success(task, responseObject);
//                }
//            }
//            else {
//                if (failure) {
//                    failure(task, responseObject, nil);
//                }
//                
//            }
//            
//        }
//        else {
//            if (failure) {
//                failure(task, responseObject, nil);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        if (failure) {
//            failure(task, nil, error);
//        }
//    }];
//    [task resume];
//    return task;
//    
//}

#pragma mark - MD5加密

#define CC_MD5_DIGEST_LENGTH 16

- (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

@end
