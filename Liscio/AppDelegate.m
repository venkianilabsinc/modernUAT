//
//  AppDelegate.m
//  Liscio
//
//  Created by Anilabs Inc on 23/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
@import Firebase;
@import FirebaseMessaging;

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    NSString *InstanceID;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    
//    UIUserNotificationType allNotificationTypes =
//    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//    UIUserNotificationSettings *settings =
//    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
    
        [self registerForRemoteNotifications];
    
    [application registerForRemoteNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshCallback:) name:kFIRInstanceIDTokenRefreshNotification object:nil];

    
    return YES;
}
//
- (void)registerForRemoteNotifications {

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }

    [[UIApplication sharedApplication] registerForRemoteNotifications];
    


}
//- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
//    // Note that this callback will be fired everytime a new token is generated, including the first
//    // time. So if you need to retrieve the token as soon as it is available this is where that
//    // should be done.
//    NSLog(@"FCM registration token: %@", fcmToken);
//
//    // TODO: If necessary send token to application server.
//}
//
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
     completionHandler(UNNotificationPresentationOptionSound);
    
    int badge_value = [[[notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"badge"]intValue] + 1;
    NSLog(@"Totoal badge Value:%d",badge_value);
    
    for (id key in notification.request.content.userInfo) {
        NSLog(@"key: %@, value: %@", key, [notification.request.content.userInfo objectForKey:key]);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge_value;
    


}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}
//


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSLog(@"userInfo=>%@", userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue]+1;

}
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
//
//
//    NSLog(@"deviceToken1 = %@",deviceToken);
//
//}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // available in iOS8
{
    [application registerForRemoteNotifications];
}



-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    NSLog(@"deviceToken1 = %@",deviceToken);
    
    //    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    // Handle your remote RemoteNotification
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
//
//}
//
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[NSUserDefaults standardUserDefaults]setObject:@"XXXXX-124512451-XDEF" forKey:@"deviceToken"];
    
    NSLog(@"Error:%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFirebase];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- Custom Firebase Code

-(void)tokenRefreshCallback:(NSNotification *) notification
{
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    InstanceID = [NSString stringWithFormat:@"%@",[notification object]];
    
    [[NSUserDefaults standardUserDefaults] setValue:InstanceID forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self connectToFirebase];
}

-(void) connectToFirebase
{
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            
            NSLog(@"InstanceID_connectToFcm = %@", InstanceID);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self sendDeviceInfo];
                    NSLog(@"instanceId_tokenRefreshNotification22=>%@",[[FIRInstanceID instanceID] token]);
                    
                    
                    
                });
            });
            
            
        }
    }];
    
}
@end
