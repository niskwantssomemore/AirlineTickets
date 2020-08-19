//
//  TicketViewController.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 12/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketViewController : UIViewController

- (instancetype)initWithObject:(Ticket*)object;

@end

NS_ASSUME_NONNULL_END
