//
//  CustomTableViewCell.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 06/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelBig = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2 * self.contentView.bounds.size.height / 3)];
        _labelBig.textAlignment = NSTextAlignmentCenter;
        _labelSmall = [[UILabel alloc] initWithFrame:CGRectMake(0, 2 * self.contentView.bounds.size.height / 3, [UIScreen mainScreen].bounds.size.width, self.contentView.bounds.size.height / 3)];
        _labelSmall.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelBig];
        [self addSubview:_labelSmall];
    }
    return self;
}

- (void) configureWithData:(Ticket *)price {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    self.backgroundColor = [UIColor orangeColor];
    self.labelBig.text = [NSString stringWithFormat:@"%@-%@, %@", price.originCity.name, price.destinationCity.name, [dateFormatter stringFromDate:price.departDate]];
    self.labelSmall.text = [NSString stringWithFormat:@"Price: %ld ₽, %@", (long)price.value, price.gate];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _labelBig.text = @"";
    _labelSmall.text = @"";
    self.backgroundColor = [UIColor whiteColor];
}

@end
