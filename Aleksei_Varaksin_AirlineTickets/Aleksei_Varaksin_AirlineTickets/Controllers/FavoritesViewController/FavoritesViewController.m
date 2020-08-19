//
//  FavoritesViewController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 06/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@property (nonatomic, strong) NSArray *currentArray;
@property (strong, nonnull) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Favorites";
    self.view.backgroundColor = [UIColor whiteColor];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"By Date", @"By Price"]];
    [_segmentedControl addTarget:self action:@selector(changeSort) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadPrices];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)reloadPrices {
    PriceSort ps = _segmentedControl.selectedSegmentIndex == 0 ? PriceSortDate : PriceSortPrice;
    [[DataBaseManager shared] loadFavoriteMapPricesWithSort: ps completion:^(NSArray<Ticket*>* prices) {
        self.currentArray = prices;
        [self.tableView reloadData];
    }];
}

- (void)changeSort
{
    [self reloadPrices];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellIdentifier"];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"CustomTableViewCellIdentifier"];
    }
    Ticket *price = [_currentArray objectAtIndex:indexPath.row];
    if (price.originCity == nil && price.destinationCity == nil) {
        [price fillWithCities:[[DataManager sharedInstance] cities]];
    }
    [cell configureWithData:price];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Ticket *curPrice = [self.currentArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@-%@", curPrice.originCity.name, curPrice.destinationCity.name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Remove from favorites?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    favoriteAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[DataBaseManager shared] removeMapPriceFromFavorite:curPrice];
        [self reloadPrices];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
