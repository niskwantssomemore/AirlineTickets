//
//  APIManager.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 09/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (APIManager*) shared {
    static APIManager* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) getMapPricesFrom: (NSString*) origin to: (NSString*) destination date: (NSString*) date completion: (APIManager_GetMapPricesCompletion) completion {
    NSURLSession* session = [NSURLSession sharedSession];
    NSString* urlString = [NSString stringWithFormat: @"https://min-prices.aviasales.ru/calendar_preload?origin=%@&destination=%@&depart_date=%@", origin, destination, date];
    NSURL* url = [NSURL URLWithString: urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL: url];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSArray* json = nil;
        if (nil != data) {
            NSError* jsonError;
            json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
        }
        NSArray* newsDictionaries = nil;
        if ([json isKindOfClass: [NSDictionary class]]) {
            newsDictionaries = [json valueForKey: @"current_depart_date_prices"];
        }
        NSMutableArray<Ticket*>* prices = [NSMutableArray new];
        if ([newsDictionaries isKindOfClass: [NSArray class]]) {
            for (NSDictionary* dictionary in newsDictionaries) {
                if (NO == [dictionary isKindOfClass: [NSDictionary class]]) { continue; }
                Ticket* object = [Ticket createWithDictionary: dictionary];
                if (NO == [object isKindOfClass: [Ticket class]]) { continue; }
                [prices addObject: object];
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(prices);
        }];
    }];
    [dataTask resume];
}

@end
