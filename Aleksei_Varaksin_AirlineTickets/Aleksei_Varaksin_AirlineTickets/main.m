//
//  main.m
//  Aleksei_Varaksin_AirlineTickets
//
//  Created by Aleksei Niskarav on 01/06/2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
