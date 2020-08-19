//
//  SearchViewController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 09/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, weak) NSString* codeFrom;
@property (nonatomic, weak) NSString* codeTo;
@property (nonatomic, weak) NSString* date;
@property (nonatomic, weak) Ticket* currentPrice;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation SearchViewController

- (instancetype)initWithFrom:(NSString*)from To:(NSString*)to Date:(NSString*)date {
    self = [super init];
    if (self) {
        _codeFrom = from;
        _codeTo = to;
        _date = date;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tickets";
    self.view.backgroundColor = [UIColor whiteColor];
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    _dateTextField.hidden = YES;
    _dateTextField.inputView = _datePicker;
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
    keyboardToolbar.items = @[flexible, doneBarButton];
    _dateTextField.inputAccessoryView = keyboardToolbar;
    
    _apiManager = [APIManager shared];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_tableView];
    [self.view addSubview:_dateTextField];
    [self reloadPrices];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)reloadPrices {
    __weak typeof(self) weakSelf = self;
    [self.apiManager getMapPricesFrom:self.codeFrom to:self.codeTo date:self.date completion:^(NSArray<Ticket *> * _Nonnull prices) {
        NSMutableArray *arr = [NSMutableArray new];
        for (Ticket* price in prices) {
            if ([price.destinationIATA isEqualToString:weakSelf.codeTo])
                [arr addObject:price];
        }
        weakSelf.currentArray = arr;
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"CustomTableViewCell"];
    }
    Ticket *price = [_currentArray objectAtIndex:indexPath.row];
    if (price.originCity == nil && price.destinationCity == nil) {
        [price fillWithCities:_cities];
    }
    [cell configureWithData:price];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentPrice = [self.currentArray objectAtIndex:indexPath.row];
    if (NO == [self.currentPrice isKindOfClass:[Ticket class]]) { return; }
    NSString *title = [NSString stringWithFormat:@"%@\n%@",
                       [NSString stringWithFormat:@"%@-%@", self.currentPrice.originCity.name, self.currentPrice.destinationCity.name],
                       [NSString stringWithFormat:@"%ld ₽", (long)self.currentPrice.value]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"What do you want to do?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction = [UIAlertAction actionWithTitle: [[DataBaseManager shared] isFavorite:self.currentPrice] ? @"Remove from favorites" : @"Add to favourites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[DataBaseManager shared] isFavorite:self.currentPrice])
        {
            [[DataBaseManager shared] removeMapPriceFromFavorite:self.currentPrice];
        }
        else
        {
            [[DataBaseManager shared] addMapPriceToFavorite:self.currentPrice];
            UIAlertController *alertControllerfavorite = [UIAlertController alertControllerWithTitle:title message:@"Do you want to add a reminder?" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Yes" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self.dateTextField becomeFirstResponder];
            }];
            UIAlertAction *cancelfavoriteAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            [alertControllerfavorite addAction:notificationAction];
            [alertControllerfavorite addAction:cancelfavoriteAction];
            [self presentViewController:alertControllerfavorite animated:YES completion:nil];
        }
    }];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"View ticket" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TicketViewController *vc = [[TicketViewController alloc] initWithObject:self.currentPrice];
        [self.navigationController pushViewController: vc animated: YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:openAction];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (_datePicker.date && self.currentPrice) {
        [[DataBaseManager shared] addMapPriceToFavorite:self.currentPrice];
        NSString *message = [NSString stringWithFormat:@"%@-%@, %ld ₽", self.currentPrice.originCity.name, self.currentPrice.destinationCity.name, (long)self.currentPrice.value];
        NSString *ident = [NSString stringWithFormat:@"%@-%@", self.currentPrice.originIATA, self.currentPrice.destinationIATA];
        [[NotificationManager shared] send:message at: _datePicker.date id:ident];
    }
    _datePicker.date = [NSDate date];
    self.currentPrice = nil;
    [self.view endEditing:YES];
}

@end
