//
//  FavoritesViewController.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 06/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "DataBaseManager.h"
#import "CustomTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *airports;

@end

NS_ASSUME_NONNULL_END
