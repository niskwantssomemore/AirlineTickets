//
//  LocationManager.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "City.h"

#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

NS_ASSUME_NONNULL_BEGIN

@class City;
@class CLLocation;

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager*) shared;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

- (void) requestCurrentLocation;
- (nullable City*) cityByLocation: (NSArray<City*>*) cities location:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
