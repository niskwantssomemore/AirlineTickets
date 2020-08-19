//
//  LocationManager.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@end

@implementation LocationManager

+ (LocationManager*) shared {
    static LocationManager* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (CLLocationManager *)locationManager {
    if (nil == _locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void) requestCurrentLocation {
    [self.locationManager requestAlwaysAuthorization];
}

- (nullable City*) cityByLocation: (NSArray<City*>*) cities location:(CLLocation *)location {
    double minDistance = 10000;
    City* result = nil;
    for (City* city in cities) {
        CLLocation* cityLocation = [[CLLocation alloc] initWithLatitude: [city.lat doubleValue]
                                                              longitude: [city.lon doubleValue]];
        CLLocationDistance distance = [cityLocation distanceFromLocation: location];
        if (distance < minDistance) {
            result = city;
            minDistance = distance;
        }
    }
    return result;
}

- (void) postDidUpdatedCurrentLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object: self.currentLocation];
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self postDidUpdatedCurrentLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (nil == self.currentLocation) {
        self.currentLocation = [locations firstObject];
        [manager stopUpdatingLocation];
        [self postDidUpdatedCurrentLocation];
    }
}

@end
