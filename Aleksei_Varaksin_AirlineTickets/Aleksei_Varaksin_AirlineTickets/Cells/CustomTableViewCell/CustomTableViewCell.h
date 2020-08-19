//
//  CustomTableViewCell.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 06/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelBig;
@property (nonatomic, strong) UILabel *labelSmall;
- (void) configureWithData: (Ticket*)price;

@end

NS_ASSUME_NONNULL_END
