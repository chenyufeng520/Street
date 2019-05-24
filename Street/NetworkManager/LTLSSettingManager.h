//
//  LTLSSettingManager.h
//

#import <Foundation/Foundation.h>
#define kIsTestPort @"kIsTestPort"

@interface LTLSSettingManager : NSObject

//保存数据
+ (void) saveDictionaryToUserDefaults: (NSDictionary*) dict ForKey: (NSString*) key;
//查询是否有保存的key
+ (BOOL) hasValueFromUserDefaults:(NSString *)key;
//保存当前用户的id
+ (void) saveCurrrentUserWithUserId;

//移除当前用户的id
+ (void) removeCurrrentUserWithUserId;

//保存当前拒绝活动用户的id，和对应活动的类型id
+ (void) saveCurrrentUserDeleteActivityData:(NSDictionary *)activityDic;

//保存当前用户是否拒绝过此活动
+ (BOOL) judgeCurrrentUserDeleteActivityData:(NSDictionary *)activityDic;
    
//是否弹出用户等级框
+ (BOOL) hasShowRankPopView;

//当前用户是否为第一次登录
+ (BOOL) currentUserIsFirstLogin;

//判断当前用户是否具有长文权限
+ (BOOL) currentUserIsLongArticleControl;

//手动修改数据
+ (void) refreshFirstLogin:(BOOL)isFirstLogin;

//保存当前关掉首页海报活动的用户id，已经当前时间，24小时后再次开启
+ (void) saveCurrrentUserClosePopPosterActivityDataWithActivityString:(NSString *)activityString;

//判断当前用户是否拒绝过首页海报活动活动,24小时内
+ (BOOL) judgeCurrrentUserClosePopPosterActivityDataWithActivityString:(NSString *)activityString;

//获取当前jvip用户标识
+ (NSString *) getCurrentUserVIPIconWithIdType:(NSString *)idType;

//获取当前登录用户的id
+ (NSString *)getCurrentUserId;

//获取当前登录用户的头像avatar
+ (NSString *)getCurrentUserAvatar;

//获取当前登录用户的昵称nick
+ (NSString *)getCurrentUserNick;

//当前是否为当前用户
+ (BOOL)judgeIsHasCurrentUserWithUserIdString:(NSString *)userIdString;

+ (NSDictionary*) getDictionaryFromUserDefaults: (NSString*) key;

+ (void)saveArrayData:(NSMutableArray *)data forKey:(NSString *)key;
+ (NSMutableArray *)getArrayData:(NSString *)key;

+ (NSString *)getStringValueFromUserDefaults:(NSString *)key;

+ (void)saveStringValueToUserDefaults:(NSString *)strValue ForKey:(NSString *)key;

+(BOOL) getBoolValueFromeUserDefaults:(NSString *)key;
+ (void)saveBoolValueToUserDefaults:(BOOL)boolValue ForKey:(NSString *)key;

+(NSInteger) getIntegerValueFromeUserDefaults:(NSString *)key;
+ (void)saveIntegerValueToUserDefaults:(NSInteger)integerValue ForKey:(NSString *)integerValue;

+ (void)setLocationLongitudeAndLatitude:(NSDictionary *)dict;
+ (void)saveStringValueToUserDefaultsForToken:(NSString *)strValue;
+ (NSString*)getStringTokenFromUserDefaults;
+ (NSDictionary *)getLocationLongitudeAndLatitude;
+ (void)setLocationGeocoder:(NSDictionary *)dict;
+ (NSDictionary *)getLocationGeocoder;
+ (BOOL)islogin;
//+ (BOOL)isFirstLaunch;
+ (NSString *)getOrderStatusFromId:(NSInteger)orderstatus andOrderType:(NSInteger)ordertype;
+ (void)saveStringValueToTBKPid:(NSString *)strValue;
+ (NSString*)getStringTokenFromTBKPid;
@end
