//
//  TicketEntity+CoreDataClass.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//
//

#import "TicketEntity+CoreDataClass.h"

@implementation TicketEntity

- (Ticket*) create {
    Ticket* price = [Ticket new];
    price.originIATA = self.originIATA;
    price.destinationIATA = self.destinationIATA;
    price.value = self.value;
    price.gate = self.gate;
    price.departDate = self.departDate;
    return price;
}

+ (TicketEntity*) createFrom: (Ticket*) price context: (NSManagedObjectContext*) context {
    TicketEntity* entity = nil;
    
    NSFetchRequest<TicketEntity *> * fetchRequest = [TicketEntity fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"originIATA == %@ and destinationIATA == %@ and gate == %@ and value == %d and departDate == %@", price.originIATA, price.destinationIATA, price.gate, price.value, price.departDate];
    fetchRequest.fetchLimit = 1;
    
    NSError* error = nil;
    NSArray* result = [context executeFetchRequest: fetchRequest error: &error];
    entity = [result firstObject];
    
    if (nil == entity) {
        entity = [NSEntityDescription insertNewObjectForEntityForName: @"TicketEntity" inManagedObjectContext: context];
        
        entity.originIATA = price.originIATA;
        entity.destinationIATA = price.destinationIATA;
        entity.value = price.value;
        entity.gate = price.gate;
        entity.departDate = price.departDate;
    }
    return entity;
}

@end
