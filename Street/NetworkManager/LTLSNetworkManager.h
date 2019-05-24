//
//  LTLSNetworkManager.h
//

#import <Foundation/Foundation.h>

typedef void(^LTLSNetworkSuccessBlock)(NSURLSessionTask *task ,id responseObject);
typedef void(^LTLSNetworkFailureBlock)(NSURLSessionTask *task, id responseObject, NSError *error);
typedef void(^LTLSNetworkBodySuccessBlock)(id responseObject);
typedef void(^LTLSNetworkBodyFailureBlock)( id responseObject, NSError *error);
typedef void (^LTLSFormdataBlock)(id  formData);
@interface LTLSNetworkManager : NSObject

@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

+ (instancetype)sharedNetworkManager;

- (void)refreshAFManager;

- (NSURLSessionTask *)get:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(LTLSNetworkSuccessBlock)success
                  failure:(LTLSNetworkFailureBlock)failure;

- (NSURLSessionTask *)post:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(LTLSNetworkSuccessBlock)success
                  failure:(LTLSNetworkFailureBlock)failure;


- (NSURLSessionTask *)post:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                  formData:(NSData *) imagedata
                   success:(LTLSNetworkSuccessBlock)success
                   failure:(LTLSNetworkFailureBlock)failure;

- (NSURLSessionTask *)post:(NSString *)urlString BodyParameters:(NSString *)parameters success:(LTLSNetworkBodySuccessBlock)success failure:(LTLSNetworkBodyFailureBlock)failure;
//批量图片上传
- (NSURLSessionTask *)uploadImages:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          formData:(NSMutableArray *)arrayImage
                           success:(LTLSNetworkSuccessBlock)success
                           failure:(LTLSNetworkFailureBlock)failure;

//图片上传
- (NSURLSessionTask *)uploadImages:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                              imageStr:(NSData *)imageStr
                           success:(LTLSNetworkSuccessBlock)success
                           failure:(LTLSNetworkFailureBlock)failure;
- (NSURL *)getURLWithRoute:(NSString *)route parameters:(NSDictionary *)parameters;
- (NSURLSessionTask*)uploadUserActionLog:(NSDictionary * )params;

//获取appinfo
- (NSDictionary *)getAppInfoData;

//数据埋点专用
//- (NSURLSessionTask *)dataPointPost:(NSString *)urlString
//                parameters:(NSDictionary *)parameters
//                   success:(LTLSNetworkSuccessBlock)success
//                   failure:(LTLSNetworkFailureBlock)failure;

@end
