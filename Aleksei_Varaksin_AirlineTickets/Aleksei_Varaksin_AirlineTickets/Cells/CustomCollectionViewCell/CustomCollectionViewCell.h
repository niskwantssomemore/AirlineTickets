//
//  CustomCollectionViewCell.h
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 29/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCollectionViewCell : UICollectionViewCell

- (void) configureWithName: (NSString*)name;

@end

NS_ASSUME_NONNULL_END
