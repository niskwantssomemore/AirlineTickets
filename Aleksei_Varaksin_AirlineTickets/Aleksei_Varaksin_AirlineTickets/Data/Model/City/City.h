//
//  City.h
//  Lesson1
//
//  Created by Elena Gracheva on 11.05.2020.
//  Copyright © 2020 Elena Gracheva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSDictionary *translations;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong, nonnull, readonly) NSNumber* lon;
@property (nonatomic, strong, nonnull, readonly) NSNumber* lat;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
