//
//  TabBarController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount;

@end
