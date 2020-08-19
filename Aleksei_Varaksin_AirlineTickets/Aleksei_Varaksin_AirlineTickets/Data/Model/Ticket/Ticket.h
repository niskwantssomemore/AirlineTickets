//
//  Ticket.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 09/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ticket : NSObject

@property (nonatomic, strong) NSString* destinationIATA;
@property (nonatomic, strong) NSString* originIATA;
@property (nonatomic, strong) NSDate *departDate;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString* gate;

@property (nonatomic, strong) City* destinationCity;
@property (nonatomic, strong) City* originCity;

+ (nullable Ticket*) createWithDictionary: (NSDictionary*) dictionary;

- (void) fillWithCities: (NSArray<City*>*) cities;

@end

NS_ASSUME_NONNULL_END
