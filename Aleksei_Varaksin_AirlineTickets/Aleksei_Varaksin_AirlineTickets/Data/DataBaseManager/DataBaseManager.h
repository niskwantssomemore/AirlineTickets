//
//  DataBaseManager.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Ticket.h"
#import "TicketEntity+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PriceSort {
    PriceSortDate,
    PriceSortPrice
} PriceSort;

typedef void(^DataBaseManager_MapPriceCompletion)(NSArray<Ticket*>*);

@interface DataBaseManager : NSObject <NSFetchedResultsControllerDelegate>

+ (DataBaseManager*) shared;

- (void)addMapPriceToFavorite:(Ticket *)price;
- (void)removeMapPriceFromFavorite:(Ticket *)price;
- (BOOL)isFavorite:(Ticket *)price;
- (void)loadFavoriteMapPricesWithSort:(PriceSort)sort completion: (DataBaseManager_MapPriceCompletion) completion;
- (Ticket*)getFavoriteByOrigin:(NSString*)origin andDestination:(NSString*)destination;

@end

NS_ASSUME_NONNULL_END
