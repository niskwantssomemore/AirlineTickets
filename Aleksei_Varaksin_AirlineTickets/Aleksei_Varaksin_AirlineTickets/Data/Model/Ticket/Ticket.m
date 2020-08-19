//
//  Ticket.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 09/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

+ (nullable Ticket*) createWithDictionary: (NSDictionary*) dictionary {
    NSString* destinationIATA = [dictionary objectForKey: @"destination"];
    if (NO == [destinationIATA isKindOfClass: [NSString class]]) { destinationIATA = nil; }
    NSString* originIATA = [dictionary objectForKey: @"origin"];
    if (NO == [originIATA isKindOfClass: [NSString class]]) { originIATA = nil; }
    NSNumber* value = [dictionary objectForKey: @"value"];
    if (NO == [value isKindOfClass: [NSNumber class]]) { value = 0; }
    NSString* gate = [dictionary objectForKey: @"gate"];
    if (NO == [originIATA isKindOfClass: [NSString class]]) { gate = nil; }
    NSString* dateStringDeparture = [dictionary objectForKey: @"depart_date"];
    NSDate* departureDate = nil;
    if (YES == [dateStringDeparture isKindOfClass: [NSString class]]) {
        departureDate = [self dateFromString:dateStringDeparture];
    }
    NSString* dateStringReturn = [dictionary objectForKey: @"return_date"];
    NSDate* returnDate = nil;
    if (YES == [dateStringReturn isKindOfClass: [NSString class]]) {
        returnDate = [self dateFromString:dateStringReturn];
    }
    
    Ticket* price = [Ticket new];
    price.destinationIATA = destinationIATA;
    price.originIATA = originIATA;
    price.value = [value integerValue];
    price.gate = gate;
    price.departDate = departureDate;
    price.returnDate = returnDate;
    return price;
}

- (void) fillWithCities: (NSArray<City*>*) cities {
    for (City* city in cities) {
        if ([city.code isEqualToString: self.destinationIATA]) {
            self.destinationCity = city;
        }
        if ([city.code isEqualToString: self.originIATA]) {
            self.originCity = city;
        }
        if (self.originCity != nil && self.destinationCity != nil) { break; }
    }
}

+ (NSDate * _Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) { return  nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString: dateString];
}

@end
