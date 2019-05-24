//
//  LTLSSettingManager.m

//

#import "LTLSSettingManager.h"
#import "NSString+LTLSExtension.h"

#define kLocationLongitudeAndLatitude @"kLocationLongitudeAndLatitude"
#define kLocationGeocoder @"kLocationGeocoder"
#define kTBKPid @"kTBKPid"
#define kUserInfoDictionary @"kUserInfoDictionary"

@implementation LTLSSettingManager

+ (NSString *)getStringValueFromUserDefaults:(NSString *)key {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        NSString* value = [standardUserDefaults objectForKey: key];
        return value;
    }
    return @"";
}

+ (void) saveStringValueToUserDefaults: (NSString*) strValue ForKey: (NSString*) key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults && strValue != nil) {
        [standardUserDefaults setObject: strValue forKey: key];
        [standardUserDefaults synchronize];
    }
}

//保存当前用户的id
+ (void) saveCurrrentUserWithUserId {
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
        if ([standardUserDefaults objectForKey:@"rankUserIdArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"rankUserIdArray"];
            NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
            [newArr addObject:[NSString stringWithFormat:@"%@",dic[@"uid"]]];
            [standardUserDefaults setValue:newArr forKey:@"rankUserIdArray"];
        }
        else {
            [standardUserDefaults setValue:@[[NSString stringWithFormat:@"%@",dic[@"uid"]]] forKey:@"rankUserIdArray"];
        }
        [standardUserDefaults synchronize];
    }
}

//移除当前用户的id
+ (void) removeCurrrentUserWithUserId {
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
        if ([standardUserDefaults objectForKey:@"rankUserIdArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"rankUserIdArray"];
            NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
            [newArr containsObject:[NSString stringWithFormat:@"%@",dic[@"uid"]]];
            [newArr removeObject:[NSString stringWithFormat:@"%@",dic[@"uid"]]];
            [standardUserDefaults setValue:newArr forKey:@"rankUserIdArray"];
        }
        else {
            [standardUserDefaults setValue:@[[NSString stringWithFormat:@"%@",dic[@"uid"]]] forKey:@"rankUserIdArray"];
        }
        [standardUserDefaults synchronize];
    }
    
}

//保存当前拒绝活动用户的id，和对应活动的类型id
+ (void) saveCurrrentUserDeleteActivityData:(NSDictionary *)activityDic {
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults objectForKey:@"activityArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"activityArray"];
            NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
            [newArr addObject:activityDic];
            [standardUserDefaults setValue:newArr forKey:@"activityArray"];
        }
        else {
           [standardUserDefaults setValue:@[activityDic] forKey:@"activityArray"];
        }
        [standardUserDefaults synchronize];
    }
}

//判断当前用户是否拒绝过此活动
+ (BOOL) judgeCurrrentUserDeleteActivityData:(NSDictionary *)activityDic {
    
    BOOL flag = NO;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults objectForKey:@"activityArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"activityArray"];
            if ([arr containsObject:activityDic]) {
                flag = YES;
            }
        }
    }
    
    return flag;
}

//是否弹出用户等级框
+ (BOOL) hasShowRankPopView {
    
    BOOL flag = NO;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults objectForKey:@"rankUserIdArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"rankUserIdArray"];
            NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
            if ([arr containsObject:[NSString stringWithFormat:@"%@",dic[@"uid"]]]) {
                flag = YES;
            }
        }
    }
    return flag;
}

//当前用户是否为第一次登录
+ (BOOL) currentUserIsFirstLogin {
    
    BOOL flag = NO;
    NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
    if ([[dic objectForKey:@"first_login"] boolValue]) {
        flag = YES;
    }
    return flag;
}

//判断当前用户是否具有长文权限
+ (BOOL) currentUserIsLongArticleControl {
    
    BOOL flag = NO;
    NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
    
    if ([dic objectForKey:@"control"]) {
        
        NSString *controlString = [dic objectForKey:@"control"];
        if ([NSString isBlankString:controlString]) {
            flag = NO;
        }
        else {
            if ([controlString containsString:@"imgtext"]) {
                flag = YES;
            }
        }
    }
    return flag;
}

//手动修改数据
+ (void) refreshFirstLogin:(BOOL)isFirstLogin {
    
    NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [newDic setValue:[NSNumber numberWithBool:isFirstLogin] forKey:@"first_login"];
    
    [LTLSSettingManager saveDictionaryToUserDefaults:newDic ForKey:kUserInfoDictionary];
}

//保存当前关掉首页海报活动的用户id，已经当前时间，24小时后再次开启
+ (void) saveCurrrentUserClosePopPosterActivityDataWithActivityString:(NSString *)activityString {
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults objectForKey:@"popPosterActivityArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"popPosterActivityArray"];
            NSMutableArray *newArr = [NSMutableArray arrayWithArray:arr];
            [newArr addObject:activityString];
            [standardUserDefaults setValue:newArr forKey:@"popPosterActivityArray"];
        }
        else {
            [standardUserDefaults setValue:@[activityString] forKey:@"popPosterActivityArray"];
        }
        [standardUserDefaults synchronize];
    }
    
}

//判断当前用户是否拒绝过首页海报活动活动,24小时内
+ (BOOL) judgeCurrrentUserClosePopPosterActivityDataWithActivityString:(NSString *)activityString {

    BOOL flag = NO;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults objectForKey:@"popPosterActivityArray"]) {
            NSArray *arr = [standardUserDefaults objectForKey:@"popPosterActivityArray"];
            if ([arr containsObject:activityString]) {
                return YES;
            }
        }
    }

    return flag;
}

+ (BOOL) hasValueFromUserDefaults:(NSString *)key {
    
    BOOL flag = NO;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults objectForKey: key]) {
            flag = YES;
        }
    }
    return flag;
}

+(BOOL) getBoolValueFromeUserDefaults:(NSString *)key{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        BOOL value = [standardUserDefaults boolForKey: key];
        return value;
    }
    return YES;

}
+ (void)saveBoolValueToUserDefaults:(BOOL)boolValue ForKey:(NSString *)key{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setBool:boolValue forKey:key];
    [standardUserDefaults synchronize];
}

+ (NSInteger) getIntegerValueFromeUserDefaults:(NSString *)key{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger verionBase = 0;
    if (standardUserDefaults) {
        verionBase = [standardUserDefaults integerForKey:key];
        return verionBase;
    }
    return verionBase;
    
}
+ (void)saveIntegerValueToUserDefaults:(NSInteger)integerValue ForKey:(NSString *)key{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setInteger:integerValue forKey:key];
    [standardUserDefaults synchronize];
}


+ (void)saveArrayData:(NSMutableArray *)array forKey:(NSString *)key {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject: array];
        [standardUserDefaults setObject: data forKey: key];
        [standardUserDefaults synchronize];
    }
}

+ (NSMutableArray *)getArrayData:(NSString *)key {
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [standardUserDefaults objectForKey: key];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData: data];
    }else {
        return nil;
    }
}

+ (void) saveDictionaryToUserDefaults: (NSDictionary*) dict ForKey: (NSString*) key
{
    if (dict && ![dict isKindOfClass: [NSDictionary class]]) {
        return;
    }
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject: dict];
        [standardUserDefaults setObject: data forKey: key];
        [standardUserDefaults synchronize];
    }
}

+ (NSDictionary*) getDictionaryFromUserDefaults: (NSString*) key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* val = nil;
    
    if (standardUserDefaults) {
        NSData* data = [standardUserDefaults objectForKey: key];
        if (nil == data) {
            return nil;
        }
        val = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    }
    return val;
}
+ (void)setLocationLongitudeAndLatitude:(NSDictionary *)dict {
    [self saveDictionaryToUserDefaults:dict ForKey:kLocationLongitudeAndLatitude];
}

+ (NSDictionary *)getLocationLongitudeAndLatitude {
    return [self getDictionaryFromUserDefaults:kLocationLongitudeAndLatitude];
}
+ (void)setLocationGeocoder:(NSDictionary *)dict
{
    [self saveDictionaryToUserDefaults:dict ForKey:kLocationGeocoder];
}

+ (NSDictionary *)getLocationGeocoder
{
    return [self getDictionaryFromUserDefaults:kLocationGeocoder];
}
+ (void)saveStringValueToUserDefaultsForToken:(NSString *)strValue{
    [self saveStringValueToUserDefaults:strValue ForKey:@"token"];
}
+ (NSString*)getStringTokenFromUserDefaults{
    return  [self getStringValueFromUserDefaults:@"token"];
}
+ (void)saveStringValueToTBKPid:(NSString *)strValue{
    [self saveStringValueToUserDefaults:strValue ForKey:kTBKPid];
}
+ (NSString*)getStringTokenFromTBKPid{
    NSString * pid =  [self getStringValueFromUserDefaults:kTBKPid];
    if ([NSString isBlankString:pid]) {
        return @"mm_133871316_0_0";
    }
    return pid;
}
+ (BOOL)islogin{
    NSString * token = [self getStringTokenFromUserDefaults];
    if (token.length>0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getOrderStatusFromId:(NSInteger)orderstatus andOrderType:(NSInteger)ordertype{
    return @"";
}


//获取当前jvip用户标识
+ (NSString *) getCurrentUserVIPIconWithIdType:(NSString *)idType {
    
    NSString *pic = @"";
    NSDictionary *rankDic = [self dictionaryWithJsonString:[LTLSSettingManager getStringValueFromUserDefaults:@"honorList"]];
    NSArray *typeArray = [rankDic allKeys];
    for (int i = 0; i < typeArray.count; i ++) {
        NSString *currentType = [NSString stringWithFormat:@"%@",typeArray[i]];
        if ([[NSString stringWithFormat:@"%@",idType] isEqualToString:currentType]) {
            pic = [NSString stringWithFormat:@"%@",[rankDic objectForKey:currentType][@"pic"]];
        }
    }
    return pic;
}


//获取当前登录用户的id
+ (NSString *)getCurrentUserId {
    
    NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
    NSString *currentUserId = [NSString stringWithFormat:@"%@",dic[@"uid"]];
    
    return currentUserId;
}

//获取当前登录用户的头像avatar
+ (NSString *)getCurrentUserAvatar {
    
    NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
    NSString *currentUserAvatar = [NSString stringWithFormat:@"%@",dic[@"avatar"]];
    
    return currentUserAvatar;
}

//获取当前登录用户的昵称nick
+ (NSString *)getCurrentUserNick {
    
    NSDictionary * dic = [LTLSSettingManager getDictionaryFromUserDefaults:kUserInfoDictionary];
    NSString *currentUserNick = [NSString stringWithFormat:@"%@",dic[@"nick"]];
    
    return currentUserNick;
}

//当前是否为当前用户
+ (BOOL)judgeIsHasCurrentUserWithUserIdString:(NSString *)userIdString {
    
    BOOL flag = NO;
    
    if ([userIdString isEqualToString:[self getCurrentUserId]]) {
        flag = YES;
    }
    return flag;
}

#pragma mark - 自定义

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    return dic;
}


@end
