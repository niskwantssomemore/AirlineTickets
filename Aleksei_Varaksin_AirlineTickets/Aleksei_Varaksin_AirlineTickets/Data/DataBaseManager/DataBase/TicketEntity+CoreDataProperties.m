//
//  TicketEntity+CoreDataProperties.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//
//

#import "TicketEntity+CoreDataProperties.h"

@implementation TicketEntity (CoreDataProperties)

+ (NSFetchRequest<TicketEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TicketEntity"];
}

@dynamic value;
@dynamic gate;
@dynamic departDate;
@dynamic destinationIATA;
@dynamic originIATA;

@end
