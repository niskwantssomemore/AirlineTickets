//
//  CustomCollectionViewCell.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 29/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell ()

@property (nonatomic, weak) UILabel *labelName;

@end

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void) configureWithName: (NSString*)name {
    self.labelName.text = name;
}

- (void) addSubviews {
    [self addNameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelName.frame = CGRectMake(self.contentView.bounds.origin.x / 2,
                                      self.contentView.bounds.origin.y / 2,
                                      self.contentView.bounds.size.width,
                                      self.contentView.bounds.size.height);
}

- (void) addNameLabel {
    if (self.labelName != nil) { return; }
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightBold];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview: label];
    self.labelName = label;
}

@end
