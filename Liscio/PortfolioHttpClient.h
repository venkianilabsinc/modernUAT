//
//  PortfolioHttpClient.h
//  Portfolio Portal
//
//  Created by Sparity Mini-1 on 21/05/15.
//  Copyright (c) 2015 Sparity. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface PortfolioHttpClient : AFHTTPSessionManager

+ (PortfolioHttpClient *) portfolioSharedHttpClient;


- (void)signIn:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)home:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)openTasks:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)get_cpa_preference_type:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)get_emp_and_contact:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)creatingATasks:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)taskDetail:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)addComment:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;


- (void)uploadImage:(NSDictionary *)parameters selectImage:(NSData*)image success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)uploadImgeFromMobile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)deletingImgeFromMobile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;


//- (void)uploadImage:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)updateTaskField:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)deleteTask:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)contactsListWithotId:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)contactDetail:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;


- (void)generatePdfFile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

//
- (void)forgotPasword:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)getProfile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)team:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)teamDetail:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)updateProfile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

//- (void)getMessage:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;
//update_task_payroll_change

- (void)updatePayRoll:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;
// App user defaults

- (void)sendMagicLink:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)loginWithMagicLink:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;

- (void)updateTaskStatus:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;




- (void)setUserId:(NSString *)userId;

- (NSString *)userId;

- (void)setUserName:(NSString *)userName;

- (NSString *)userName;

- (void)setEmail:(NSString *)email;

- (NSString *)email;

- (void)setSecurityToken:(NSString *)token;

- (NSString *)securityToken;

-(void)setFirstName:(NSString *)firstName;
-(void)setLasttName:(NSString *)lastName;
- (NSString *)firstName;
- (NSString *)lastName;

@end
