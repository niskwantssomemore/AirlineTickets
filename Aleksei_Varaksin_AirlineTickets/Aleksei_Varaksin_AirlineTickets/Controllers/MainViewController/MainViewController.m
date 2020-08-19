//
//  MainViewController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 01/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic) UIButton *from;
@property (nonatomic) UIButton *to;
@property (nonatomic) UIButton *search;
@property (nonatomic) UIButton *clear;
@property (nonatomic) UITextField *dateTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) City *myLocation;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *airports;
@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, weak) NSString* codeFrom;
@property (nonatomic, weak) NSString* codeTo;
@property (nonatomic, strong) NSString* date;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete:) name:kDataManagerLoadDataDidComplete object:nil];
    [[DataManager sharedInstance] loadData];
    self.view.backgroundColor = [UIColor orangeColor];
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [NSDate date];
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDateTap:)];
    keyboardToolbar.items = @[flexible, doneBarButton];
    _from = [[UIButton alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height / 2 - 140, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [_from addTarget:self action:@selector(chooseFrom:) forControlEvents:UIControlEventTouchUpInside];
    [_from setTitle:@"From" forState:UIControlStateNormal];
    [_from setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _from.backgroundColor = [UIColor whiteColor];
    _to = [[UIButton alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [_to addTarget:self action:@selector(chooseTo:) forControlEvents:UIControlEventTouchUpInside];
    [_to setTitle:@"To" forState:UIControlStateNormal];
    [_to setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _to.backgroundColor = [UIColor whiteColor];
    _dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height / 2 - 20, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    _dateTextField.text = @"Enter the date";
    _dateTextField.inputView = _datePicker;
    _dateTextField.inputAccessoryView = keyboardToolbar;
    _dateTextField.textAlignment = NSTextAlignmentCenter;
    _dateTextField.backgroundColor = [UIColor whiteColor];
    _search = [[UIButton alloc] initWithFrame:CGRectMake(65, [UIScreen mainScreen].bounds.size.height / 2 + 40, [UIScreen mainScreen].bounds.size.width - 130, 40)];
    [_search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [_search setTitle:@"Search" forState:UIControlStateNormal];
    [_search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _search.backgroundColor = [UIColor whiteColor];
    _clear = [[UIButton alloc] initWithFrame:CGRectMake(110, [UIScreen mainScreen].bounds.size.height / 2 + 100, [UIScreen mainScreen].bounds.size.width - 220, 40)];
    [_clear addTarget:self action:@selector(clearSelection:) forControlEvents:UIControlEventTouchUpInside];
    [_clear setTitle:@"Сlear selection" forState:UIControlStateNormal];
    [_clear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _clear.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_from];
    [self.view addSubview:_to];
    [self.view addSubview:_dateTextField];
    [self.view addSubview:_search];
    [self.view addSubview:_clear];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateCurrentLocation:) name: kLocationServiceDidUpdateCurrentLocation object: nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    if (currentLocation != nil)
    {
        City *city = [[LocationManager shared] cityByLocation: _cities location:currentLocation];
        if (NO == [city isKindOfClass:[City class]]) return;
        [self.from setTitle:city.name forState:UIControlStateNormal];
        self.codeFrom = city.code;
        _myLocation = city;
        [self addressFromLocation:currentLocation];
    }
}

- (void)addressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            NSMutableString *address = [NSMutableString new];
            for (MKPlacemark *placemark in placemarks) {
                [address appendString:placemark.name];
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your location address is:" message:address preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            UIWindow *found = nil;
            NSArray *windows = [[UIApplication sharedApplication]windows];
            for (UIWindow *window in windows) {
                if (window.isKeyWindow)
                {
                    found = window;
                    break;
                }
            }
            [found.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)loadDataComplete:(NSNotification *)notification {
    [self changeSource];
}

-(void)changeSource {
    _cities = [[DataManager sharedInstance] cities];
    _airports = [[DataManager sharedInstance] airports];
    _countries = [[DataManager sharedInstance] countries];
}

-(void)chooseFrom:(UIButton *)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose how you want to add a departure point" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *myLocationAction = [UIAlertAction actionWithTitle: @"Add my location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPlace:self.myLocation withType:PlaceTypeDeparture andDataType:DataSourceTypeCity];
    }];
    UIAlertAction *listAction = [UIAlertAction actionWithTitle: @"From the list" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseAirport:PlaceTypeDeparture];
    }];
    UIAlertAction *mapAction = [UIAlertAction actionWithTitle:@"With the map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MapViewController *mapViewController = [MapViewController new];
        mapViewController.delegate = self;
        mapViewController.type = PlaceTypeDeparture;
        [self.navigationController pushViewController: mapViewController animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:myLocationAction];
    [alertController addAction:listAction];
    [alertController addAction:mapAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doneButtonDateTap:(UIBarButtonItem *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _dateTextField.text = [dateFormatter stringFromDate:_datePicker.date];
    _date = [dateFormatter stringFromDate:_datePicker.date];
    [self.view endEditing:YES];
}

-(void)chooseTo:(UIButton *)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose how you want to add an arrival point" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *myLocationAction = [UIAlertAction actionWithTitle: @"Add my location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPlace:self.myLocation withType:PlaceTypeArrival andDataType:DataSourceTypeCity];
    }];
    UIAlertAction *listAction = [UIAlertAction actionWithTitle: @"From the list" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseAirport:PlaceTypeArrival];
    }];
    UIAlertAction *mapAction = [UIAlertAction actionWithTitle:@"With the map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MapViewController *mapViewController = [MapViewController new];
        mapViewController.delegate = self;
        mapViewController.type = PlaceTypeArrival;
        [self.navigationController pushViewController: mapViewController animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:myLocationAction];
    [alertController addAction:listAction];
    [alertController addAction:mapAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)search:(UIButton *)button {
    if (_codeFrom != nil && _codeTo != nil && _date != nil)
    {
        SearchViewController *searchViewController = [[SearchViewController alloc] initWithFrom:self.codeFrom To:self.codeTo Date:self.date];
        searchViewController.cities = _cities;
        [self.navigationController pushViewController: searchViewController animated:YES];
    }
}

-(void)clearSelection:(UIButton *)button {
    [_from setTitle:@"From" forState:UIControlStateNormal];
    [_to setTitle:@"To" forState:UIControlStateNormal];
    _dateTextField.text = @"Enter the date";
    _date = nil;
    _codeFrom = nil;
    _codeTo = nil;
}

-(void)chooseAirport:(PlaceType)type {
    CollectionViewController *controller = [[CollectionViewController alloc] init];
    controller.type = type;
    controller.delegate = self;
    controller.cities = _cities;
    controller.airports = _airports;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        [_from setTitle:title forState:UIControlStateNormal];
        self.codeFrom = iata;
    } else {
        [_to setTitle:title forState:UIControlStateNormal];
        self.codeTo = iata;
    }
}

@end
