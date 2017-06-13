//
//  TokenModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "Contract.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "NSDate+Extension.h"

@implementation Contract

-(NSString*)creationDateString {
    
    return self.creationDate ? [self.creationDate formatedDateString] : nil;
}


#pragma mark - Getters 

-(NSString *)mainAddress {
    
    return self.contractAddress;
}

-(CGFloat)balance {
    
    NSArray* values = self.addressBalanceDictionary.allValues;
    CGFloat balance = 0;
    for (NSNumber* balanceValue in values) {
        balance += balanceValue.floatValue;
    }
    return balance;
}

#pragma mark - Spendable

-(void)updateBalanceWithHandler:(void (^)(BOOL))complete {
    
    [self.manager updateBalanceOfSpendableObject:self withHandler:complete];
}

-(void)updateHistoryWithHandler:(void (^)(BOOL))complete andPage:(NSInteger) page {
    
    [self.manager updateHistoryOfSpendableObject:self withHandler:complete andPage:page];
}

-(void)loadToMemory {
    
    _historyStorage = [HistoryDataStorage new];
    _historyStorage.spendableOwner = self;
}

-(void)historyDidChange{
    [self.manager spendableDidChange:self];
}
-(void)updateHandler:(void(^)(BOOL success)) complete{
    [self.manager updateSpendableObject:self];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.contractCreationAddressAddress forKey:@"contractCreationAddressAddress"];
    [aCoder encodeObject:self.addressBalanceDictionary forKey:@"addressBalanceDictionary"];
    [aCoder encodeObject:self.localName forKey:@"localName"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.templateModel forKey:@"templateModel"];
    [aCoder encodeObject:self.contractAddress forKey:@"contractAddress"];
    [aCoder encodeObject:self.adresses forKey:@"adresses"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
    [aCoder encodeObject:self.decimals forKey:@"decimals"];
    [aCoder encodeObject:self.totalSupply forKey:@"totalSupply"];
    [aCoder encodeObject:@(self.balance) forKey:@"balance"];
    [aCoder encodeObject:@(self.unconfirmedBalance) forKey:@"unconfirmedBalance"];
    [aCoder encodeObject:@(self.isActive) forKey:@"isActive"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *contractCreationAddressAddress = [aDecoder decodeObjectForKey:@"contractCreationAddressAddress"];
    NSDictionary* addressBalanceDictionary = [aDecoder decodeObjectForKey:@"addressBalanceDictionary"];
    NSString *localName = [aDecoder decodeObjectForKey:@"localName"];
    NSDate *creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
    TemplateModel *templateModel = [aDecoder decodeObjectForKey:@"templateModel"];
    NSString *contractAddress = [aDecoder decodeObjectForKey:@"contractAddress"];
    NSArray *adresses = [aDecoder decodeObjectForKey:@"adresses"];
    NSString *symbol = [aDecoder decodeObjectForKey:@"symbol"];
    NSString *decimals = [aDecoder decodeObjectForKey:@"decimals"];
    NSString *totalSupply = [aDecoder decodeObjectForKey:@"totalSupply"];
    CGFloat balance = [[aDecoder decodeObjectForKey:@"balance"] floatValue];
    CGFloat unconfirmedBalance = [[aDecoder decodeObjectForKey:@"unconfirmedBalance"] floatValue];
    BOOL isActive = [[aDecoder decodeObjectForKey:@"isActive"] boolValue];
    
    self = [super init];
    if (self) {
        self.name = name;
        self.addressBalanceDictionary = addressBalanceDictionary;
        self.contractCreationAddressAddress = contractCreationAddressAddress;
        self.localName = localName;
        self.creationDate = creationDate;
        self.templateModel = templateModel;
        self.contractAddress = contractAddress;
        self.adresses = adresses;
        self.symbol = symbol;
        self.decimals = decimals;
        self.totalSupply = totalSupply;
        self.balance = balance;
        self.unconfirmedBalance = unconfirmedBalance;
        self.isActive = isActive;
    }
    
    return self;
}

@end
