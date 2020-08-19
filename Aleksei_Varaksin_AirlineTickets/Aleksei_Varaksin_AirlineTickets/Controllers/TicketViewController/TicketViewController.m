//
//  TicketViewController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 12/07/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "TicketViewController.h"

@interface TicketViewController ()

@property (nonatomic, weak) Ticket *ticket;
@property (nonatomic, weak, readwrite) UIView* viewTicket;
@property (nonatomic, weak, readwrite) UILabel* labelPrice;
@property (nonatomic, weak, readwrite) UILabel* labelRoute;
@property (nonatomic, weak, readwrite) UILabel* labelRouteCode;
@property (nonatomic, weak, readwrite) UILabel* labelDepartDate;
@property (nonatomic, weak, readwrite) UILabel* labelGate;

@end

@implementation TicketViewController

- (instancetype)initWithObject:(Ticket*)object
{
    self = [super init];
    if (self) {
        self.ticket = object;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ticket";
    self.view.backgroundColor = [UIColor whiteColor];

    [self addTicketView];
    [self addPriceLabel];
    [self addRouteLabel];
    [self addRouteCodeLabel];
    [self addDepartDateLabel];
    [self addGateLabel];
    
    self.labelPrice.text = [NSString stringWithFormat:@"%ld ₽", self.ticket.value];
    self.labelRoute.text = [NSString stringWithFormat:@"%@-%@", self.ticket.originCity.name, self.ticket.destinationCity.name];
    self.labelRouteCode.text = [NSString stringWithFormat:@"%@-%@", self.ticket.originIATA, self.ticket.destinationIATA];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    self.labelDepartDate.text = [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:self.ticket.departDate], [dateFormatter stringFromDate:self.ticket.returnDate]];
    self.labelGate.text = self.ticket.gate;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.viewTicket.frame = CGRectMake(10, self.view.safeAreaInsets.top + 10, self.view.bounds.size.width - 20, 170);
    
    self.labelPrice.frame = CGRectMake(10, 10, self.viewTicket.bounds.size.width - 20, 30);
    self.labelRoute.frame = CGRectMake(10, 10 + self.labelPrice.frame.size.height, self.viewTicket.bounds.size.width - 20, 30);
    self.labelRouteCode.frame = CGRectMake(10, 10 + self.labelPrice.frame.size.height + self.labelRoute.frame.size.height, self.viewTicket.bounds.size.width - 20, 30);
    self.labelDepartDate.frame = CGRectMake(10, 10 + self.labelPrice.frame.size.height + self.labelRoute.frame.size.height + self.labelRouteCode.frame.size.height, self.viewTicket.bounds.size.width - 20, 30);
    self.labelGate.frame = CGRectMake(10, 10 + self.labelPrice.frame.size.height + self.labelRoute.frame.size.height + self.labelRouteCode.frame.size.height + self.labelDepartDate.frame.size.height, self.viewTicket.bounds.size.width - 20, 30);
}


- (void)addTicketView {
    if (nil != self.viewTicket) { return; }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0;
    [self.view addSubview: view];
    self.viewTicket = view;
}

- (void)addPriceLabel {
    if (nil != self.labelPrice) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightBold];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelPrice = label;
}

- (void)addRouteLabel {
    if (nil != self.labelRoute) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelRoute = label;
}

- (void)addRouteCodeLabel {
    if (nil != self.labelRouteCode) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelRouteCode = label;
}

- (void)addDepartDateLabel {
    if (nil != self.labelDepartDate) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelDepartDate = label;
}

- (void)addGateLabel {
    if (nil != self.labelGate) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelGate = label;
}

@end
