//
//  CollectionViewController.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 29/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "CustomCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface CollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *airports;
@property (assign) PlaceType type;
@property (assign) UIViewController<PlaceViewControllerDelegate> *delegate;

@end

NS_ASSUME_NONNULL_END
