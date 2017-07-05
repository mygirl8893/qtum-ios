//
//  TokenListViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contract.h"
#import "WalletCoordinator.h"

@protocol TokenListViewControllerDelegate <NSObject>

@required
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item;

@end

@interface TokenListViewController : BaseViewController

@property (copy, nonatomic) NSArray<Contract*>* tokens;
@property (weak,nonatomic) id <TokenListViewControllerDelegate> delegate;

-(void)reloadTable;

@end
