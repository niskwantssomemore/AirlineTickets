//
//  MapViewController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationService;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Cities";
    _mapView = [MKMapView new];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];    
    _locationService = [LocationManager shared];
    [_locationService requestCurrentLocation];
    _mapView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height);
    _cities = [[DataManager sharedInstance] cities];
    [self reload];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
}

- (void)reload {
    CLLocation *currentLocation = [LocationManager shared].currentLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    [_mapView removeAnnotations: _mapView.annotations];
    City *current = [[LocationManager shared] cityByLocation: _cities location:currentLocation];
    if (NO == [current isKindOfClass:[City class]]) return;
    for (City *city in _cities) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            if (city == current)
            {
                annotation.title = [NSString stringWithFormat:@"%@", @"My Location"];
                annotation.subtitle = [NSString stringWithFormat:@"%@ %@", city.name, city.countryCode];
            }
            else
            {
                annotation.title = [NSString stringWithFormat:@"%@ %@", city.name, city.countryCode];
                annotation.subtitle = [NSString stringWithFormat:@"%@", city.code];
            }
            annotation.coordinate = CLLocationCoordinate2DMake([city.lat doubleValue], [city.lon doubleValue]);
            [self.mapView addAnnotation: annotation];
        });
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation.title  isEqual: @"My Location"])
    {
        NSString *destination = view.annotation.subtitle;
        City *current = nil;
        if (_cities != nil) {
            for (City* city in _cities) {
                if (destination == city.code) {
                    current = city;
                    break;
                }
            }
        }
        NSString *title = [NSString stringWithFormat:@"%@\n%@", view.annotation.title, view.annotation.subtitle];
        UIAlertController *alertController;
        UIAlertAction *favoriteAction;
        alertController = [UIAlertController alertControllerWithTitle:title message: self.type == PlaceTypeDeparture ? @"Do you want to add this city as a departure point?" : @"Do you want to add this city as an arrival point?" preferredStyle:UIAlertControllerStyleActionSheet];
        favoriteAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.delegate selectPlace:current withType:self.type andDataType:DataSourceTypeCity];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
