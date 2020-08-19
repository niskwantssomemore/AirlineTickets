//
//  NotificationManager.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "DataManager.h"
#import "DataBaseManager.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationManager : NSObject <UNUserNotificationCenterDelegate>

+ (NotificationManager*) shared;
- (void) requestPermissions;
- (void) send: (NSString*) text after: (NSTimeInterval) delay id: (NSString*)ident;
- (void) send: (NSString*) text at: (NSDate*) date id: (NSString*)ident;

@end

NS_ASSUME_NONNULL_END
