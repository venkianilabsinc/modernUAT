//
//  PortfolioHttpClient.m
//  Portfolio Portal
//
//  Created by Sparity Mini-1 on 21/05/15.
//  Copyright (c) 2015 Sparity. All rights reserved.
//

#import "PortfolioHttpClient.h"

#define kUserId @"user_id"
#define kUserName @"user_name"
#define kEmail @"email"
#define kSecurityToken @"security_token"
#define kfirst_name @"first_name"
#define klast_name @"last_name"


//static NSString* const kBaseUrlStr = @"https://liscioapistage.herokuapp.com/api/v1/";//Dev

static NSString* const kBaseUrlStr = @"https://liscioapi.herokuapp.com/api/v1/"; // integration

//static NSString* const kBaseUrlStr = @"http://demoapi.liscio.me/api/v1/"; //UAT

//static NSString* const kBaseUrlStr = @"http://rootscpa.liscio.me/api/v1/"; //Roots UAT


@implementation PortfolioHttpClient

+ (PortfolioHttpClient *) portfolioSharedHttpClient
{
    static PortfolioHttpClient *sharedPortfolioHttpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sharedPortfolioHttpClient = [[PortfolioHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrlStr] sessionConfiguration:configuration];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
    });
    return sharedPortfolioHttpClient;
}


- (void)signIn:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    self.requestSerializer = [AFJSONRequestSerializer serializer];


    [self POST:@"sign_in/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
    }];
}

- (void)home:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    self.requestSerializer = [AFJSONRequestSerializer serializer];
//    [self.requestSerializer setValue:@"Authorization" forHTTPHeaderField:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]];

    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];

    [self GET:@"home/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

//tasks.json

- (void)openTasks:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    [self GET:@"tasks.json/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

- (void)get_cpa_preference_type:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    [self GET:@"get_cpa_preference_type/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

- (void)get_emp_and_contact:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];

    [self POST:@"get_emp_and_contact/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

- (void)creatingATasks:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    [self POST:@"tasks.json/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

- (void)taskDetail:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    NSString *mySTR = [NSString stringWithFormat:@"tasks/%@", parameters[@"id"]];

    [self GET:mySTR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

- (void)addComment:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    [self POST:@"add_comment/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}

- (void)uploadImgeFromMobile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;
{
    [self isReachableViaInternet];
    
    [self POST:@"upload_from_iphone/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}


- (void)deletingImgeFromMobile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];
    
    NSString *mySTR = [NSString stringWithFormat:@"documents/%@", parameters[@"id"]];

    [self DELETE:mySTR parameters:parameters[@"task_id"] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)uploadImage:(NSDictionary *)parameters selectImage:(NSData*)image success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;
{
    [self isReachableViaInternet];


    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];

    [self POST:@"documents" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:image name:@"file" fileName:@"avatar.png" mimeType:@"image/jpeg"];
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        failure(task, error);
    }];

}

- (void)updateTaskField:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];

    NSString *mySTR = [NSString stringWithFormat:@"update_task_fields/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ID"]];

    [self PUT:mySTR parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)deleteTask:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    NSString *mySTR = [NSString stringWithFormat:@"tasks/%@", parameters[@"task_id"]];
    
    [self DELETE:mySTR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}


- (void)contactsListWithotId:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];

    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self GET:@"get_accounts_of_contact_on_the_basis_of_user_id/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)contactDetail:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure;
{
    [self isReachableViaInternet];

    NSString *mySTR = [NSString stringWithFormat:@"accounts/%@", parameters[@"id"]];
    
    [self GET:mySTR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         success(responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
    
}

- (void)generatePdfFile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self POST:@"sign_document_and_generate_pdf/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}
- (void)forgotPasword:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self POST:@"forgot_password/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)getProfile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self GET:@"profile/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}
- (void)team:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self GET:@"get_accounts_of_contact_on_the_basis_of_user_id/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
}
- (void)updateProfile:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self POST:@"update_profile/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)updatePayRoll:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *mySTR = [NSString stringWithFormat:@"update_task_payroll_change/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"ID"]];

    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"] forHTTPHeaderField:@"Authorization"];
    
    [self PUT:mySTR parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
 
}
//update_profile


- (void)isReachableViaInternet
{
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet!!"
                                                        message:@"Check your internet connection"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//https://liscioapistage.herokuapp.com/api/v1/get_team_members_of_account/30



- (void)teamDetail:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];
    
    NSString *mySTR = [NSString stringWithFormat:@"get_team_members_of_account/%@", parameters[@"account_id"]];
    
    [self GET:mySTR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         success(responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)sendMagicLink:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];
    
//    NSString *mySTR = [NSString stringWithFormat:@"get_team_members_of_account/%@", parameters[@"account_id"]];
    
    [self POST:@"send_magic_link/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         success(responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}

- (void)loginWithMagicLink:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];
    
    //    NSString *mySTR = [NSString stringWithFormat:@"get_team_members_of_account/%@", parameters[@"account_id"]];
    
    [self POST:@"login_with_magic_link/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         success(responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];

}


- (void)updateTaskStatus:(NSDictionary *)parameters success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSURLSessionDataTask *task,NSError *error))failure
{
    [self isReachableViaInternet];
    
    //    NSString *mySTR = [NSString stringWithFormat:@"get_team_members_of_account/%@", parameters[@"account_id"]];
    
    [self POST:@"update_task_status/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         success(responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(task, error);
     }];
    
}

- (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)userId
{
   return [[NSUserDefaults standardUserDefaults] valueForKey:kUserId];
}

- (void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setFirstName:(NSString *)firstName
{
    [[NSUserDefaults standardUserDefaults] setValue:firstName forKey:kfirst_name];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)setLasttName:(NSString *)lastName
{
    [[NSUserDefaults standardUserDefaults] setValue:lastName forKey:klast_name];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)firstName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kfirst_name];
    
}
- (NSString *)lastName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:klast_name];
    
}

- (NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kUserName];
 
}

- (void)setEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setValue:email forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)email
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kEmail];
}

- (void)setSecurityToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:kSecurityToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)securityToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSecurityToken];

}


@end
