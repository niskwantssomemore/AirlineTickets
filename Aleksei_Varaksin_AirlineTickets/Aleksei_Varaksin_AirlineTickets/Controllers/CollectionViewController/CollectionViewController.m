//
//  CollectionViewController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 29/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong, readonly) NSArray *actualArray;

@end

@implementation CollectionViewController

- (NSArray*) actualArray {
    if (nil != _searchController && [_searchController.searchBar.text length] > 0) {
        return _searchArray;
    }
    return _currentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.itemSize = CGSizeMake(130.0, 90.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CustomCollectionViewCell class])];
    [self.view addSubview:_collectionView];

    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    _searchArray = [NSArray new];
    self.navigationItem.searchController = _searchController;

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
    
    self.title = _type == PlaceTypeDeparture ? @"From" : @"To";
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

- (void)changeSource
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = _cities;
            break;
        case 1:
            _currentArray = _airports;
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString* placeCellID = NSStringFromClass([CustomCollectionViewCell class]);
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:placeCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[CustomCollectionViewCell alloc] init];
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [self.actualArray objectAtIndex:indexPath.row];
        [cell configureWithName:city.name];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [self.actualArray objectAtIndex:indexPath.row];
        [cell configureWithName:airport.name];
    }
    cell.backgroundColor = UIColor.orangeColor;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actualArray.count;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text, searchController.searchBar.text];
        _searchArray = [_currentArray filteredArrayUsingPredicate: predicate];
        [_collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate selectPlace:[self.actualArray objectAtIndex:indexPath.row] withType:_type andDataType:_segmentedControl.selectedSegmentIndex == 0 ? DataSourceTypeCity : DataSourceTypeAirport];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
