//
//  SearchViewController.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 09/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "CustomTableViewCell.h"
#import "NotificationManager.h"
#import "TicketViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *cities;
- (instancetype)initWithFrom:(NSString*)from To:(NSString*)to Date:(NSString*)date;

@end

NS_ASSUME_NONNULL_END
