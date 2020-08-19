//
//  MapViewController.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "LocationManager.h"
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *cities;
@property (assign) PlaceType type;
@property (assign) UIViewController<PlaceViewControllerDelegate> *delegate;

@end

NS_ASSUME_NONNULL_END
