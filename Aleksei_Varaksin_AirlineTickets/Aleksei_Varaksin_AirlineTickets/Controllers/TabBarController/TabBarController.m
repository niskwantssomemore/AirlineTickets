//
//  TabBarController.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 29/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    [self initTabController];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    [self initTabController];
    return self;
}

- (void) initTabController {
    UIViewController* mainViewController = [MainViewController new];
    UITabBarItem* tab1 = [[UITabBarItem alloc] initWithTitle: @"Search" image: [UIImage systemImageNamed:@"magnifyingglass"] tag: 0];
    mainViewController.tabBarItem = tab1;
    UINavigationController* ncSearch1 = [[UINavigationController alloc] initWithRootViewController: mainViewController];
    ncSearch1.navigationBar.prefersLargeTitles = YES;
    ncSearch1.tabBarItem = tab1;
    UIViewController* favoritesViewController = [FavoritesViewController new];
    UITabBarItem* tab2 = [[UITabBarItem alloc] initWithTitle: @"Favorites" image: [UIImage systemImageNamed:@"star"] tag: 0];
    UINavigationController* ncSearch2 = [[UINavigationController alloc] initWithRootViewController: favoritesViewController];
    ncSearch2.navigationBar.prefersLargeTitles = YES;
    ncSearch2.tabBarItem = tab2;
    self.viewControllers = @[ncSearch1, ncSearch2];
}

@end
