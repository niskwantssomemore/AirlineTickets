#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (self.window == nil && [scene isKindOfClass:[UIWindowScene class]])
        self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    TabBarController *mainTab = [TabBarController new];
    self.window.rootViewController = mainTab;
    [self.window makeKeyAndVisible];
    [[LocationManager shared] requestCurrentLocation];
    [[NotificationManager shared] requestPermissions];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
}

- (void)sceneWillResignActive:(UIScene *)scene {
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
}

@end
