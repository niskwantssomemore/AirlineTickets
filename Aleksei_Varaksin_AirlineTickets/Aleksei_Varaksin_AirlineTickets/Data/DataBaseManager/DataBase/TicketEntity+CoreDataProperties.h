//
//  TicketEntity+CoreDataProperties.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//
//

#import "TicketEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketEntity (CoreDataProperties)

+ (NSFetchRequest<TicketEntity *> *)fetchRequest;

@property (nonatomic) int64_t value;
@property (nullable, nonatomic, copy) NSString *gate;
@property (nullable, nonatomic, copy) NSDate *departDate;
@property (nullable, nonatomic, copy) NSString *destinationIATA;
@property (nullable, nonatomic, copy) NSString *originIATA;

@end

NS_ASSUME_NONNULL_END
