//
//  LanguageViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageCoordinatorDelegate;

@interface LanguageViewController : BaseViewController

@property (nonatomic) id<UITableViewDelegate, UITableViewDataSource> tableSource;
@property (nonatomic, weak) id<LanguageCoordinatorDelegate> delegate;

@end