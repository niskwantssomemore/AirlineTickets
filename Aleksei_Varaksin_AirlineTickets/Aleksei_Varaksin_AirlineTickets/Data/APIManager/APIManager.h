//
//  APIManager.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 09/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^APIManager_GetMapPricesCompletion)(NSArray<Ticket*>*);

@interface APIManager : NSObject

+ (APIManager*) shared;

- (void) getMapPricesFrom: (NSString*) origin to: (NSString*) destination date: (NSString*) date completion: (APIManager_GetMapPricesCompletion) completion;

@end

NS_ASSUME_NONNULL_END
