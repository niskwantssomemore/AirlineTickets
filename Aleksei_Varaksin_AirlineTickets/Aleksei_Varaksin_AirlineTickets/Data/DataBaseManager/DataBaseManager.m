//
//  DataBaseManager.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 15/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "DataBaseManager.h"

@interface DataBaseManager ()

@property (nonatomic, strong) NSPersistentContainer* container;
@property (nonatomic, strong) NSFetchedResultsController* citiesSearchFetchedResultsController;

@end

@implementation DataBaseManager

+ (DataBaseManager*) shared {
    static DataBaseManager* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        
        NSURL* fileURL = [DataBaseManager dbFile];
        
        NSPersistentStoreDescription* storeDescription = [NSPersistentStoreDescription persistentStoreDescriptionWithURL: fileURL];
        
        shared.container = [NSPersistentContainer persistentContainerWithName: @"Favorites"];
        shared.container.persistentStoreDescriptions = @[storeDescription];
        
        [shared.container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
            
        }];
    });
    return shared;
}

- (void)addMapPriceToFavorite:(Ticket *)price {
    [self.container performBackgroundTask:^(NSManagedObjectContext * context) {
        [TicketEntity createFrom:price context:context];
        NSError* error = nil;
        [context save: &error];
    }];
}

- (void)removeMapPriceFromFavorite:(Ticket *)price {
    NSManagedObjectContext * context = self.container.viewContext;
    TicketEntity *entity = [TicketEntity createFrom:price context:context];
    [context deleteObject:entity];
    NSError* error = nil;
    [context save: &error];
}

- (BOOL)isFavorite:(Ticket *)price {
    TicketEntity* entity = nil;
    NSFetchRequest<TicketEntity *> * fetchRequest = [TicketEntity fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"originIATA == %@ and destinationIATA == %@ and gate == %@ and value == %d and departDate == %@", price.originIATA, price.destinationIATA, price.gate, price.value, price.departDate];
    fetchRequest.fetchLimit = 1;
    NSError* error = nil;
    NSArray* result = [self.container.viewContext executeFetchRequest: fetchRequest error: &error];
    entity = [result firstObject];
    return entity != nil;
}

- (Ticket*)getFavoriteByOrigin:(NSString*)origin andDestination:(NSString*)destination {
    Ticket* price = nil;
    NSFetchRequest<TicketEntity*>* fetchRequest = [TicketEntity fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"originIATA == %@ and destinationIATA == %@", origin, destination];
    fetchRequest.fetchLimit = 1;
    NSError* error = nil;
    NSArray* result = [self.container.viewContext executeFetchRequest: fetchRequest error: &error];
    TicketEntity* entity = [result firstObject];
    price = [entity create];
    return price;
}

- (void)loadFavoriteMapPricesWithSort:(PriceSort)sort completion: (DataBaseManager_MapPriceCompletion) completion {
    [self.container performBackgroundTask:^(NSManagedObjectContext * context) {
        NSFetchRequest* fetchRequest = [TicketEntity fetchRequest];
        if (sort == PriceSortDate) {
            fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey: @"departDate" ascending: YES] ];
        }
        else if (sort == PriceSortPrice) {
            fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey: @"value" ascending: YES] ];
        }
        
        NSError* error = nil;
        NSArray* result = [context executeFetchRequest: fetchRequest error: &error];
        
        NSMutableArray* prices = [NSMutableArray new];
        for (TicketEntity* entity in result) {
            if (NO == [entity isKindOfClass: [TicketEntity class]]) { continue; }
            Ticket* price = [entity create];
            [prices addObject: price];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(prices);
        }];
    }];
}

+ (NSURL*) dbFile {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths firstObject];
    NSString* filePath = [documentPath stringByAppendingPathComponent: @"Favorites.sqlite"];
    return [NSURL fileURLWithPath: filePath];
}

@end
