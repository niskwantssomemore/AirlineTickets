//
//  TicketEntity+CoreDataClass.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketEntity : NSManagedObject

+ (TicketEntity*) createFrom: (Ticket*) price context: (NSManagedObjectContext*) context;
- (Ticket*) create;

@end

NS_ASSUME_NONNULL_END

#import "TicketEntity+CoreDataProperties.h"
