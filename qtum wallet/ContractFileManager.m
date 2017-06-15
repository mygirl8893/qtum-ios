//
//  ContractFileManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ContractFileManager.h"
#import "NSData+Extension.h"
#import "NSString+Extension.h"
#import "TokenCell.h"

@implementation ContractFileManager

+ (instancetype)sharedInstance {
    
    static ContractFileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        [self copyFilesToDocumentDirectoty];
    }
    return self;
}

-(NSString*)documentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(NSString*)contractDirectory{
    return [[self documentDirectory] stringByAppendingPathComponent:@"/Contracts"];
}

-(void)copyFilesToDocumentDirectoty {
    
    NSString *fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Contracts"];
    NSString *contractsPath = [self contractDirectory];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:contractsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:contractsPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSString *toPath = contractsPath;
    [self copyAllFilesFormPath:fromPath toPath:toPath];
}

-(NSDictionary*)getStandartAbi {
    
    return [self getAbiWithTemplate:@"Standart"];
}

-(NSDictionary*)getAbiWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/abi-contract",[self contractDirectory],templateName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* jsonAbi = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonAbi;
}

-(NSString*)getEscapeAbiWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/abi-contract",[self contractDirectory],templateName];
    NSString *abi = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return abi;
}

-(NSString*)getContractWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/source-contract",[self contractDirectory],templateName];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return contract;
}

-(NSData*)getBitcodeWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/bitecode-contract",[self contractDirectory],templateName];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *bitecode = [NSString dataFromHexString:contract];
    return bitecode;
}

-(void)copyAllFilesFormPath:(NSString*) fromPath toPath:(NSString*) toPath {
    
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:NULL];
    [resContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
         NSError* error;
        BOOL isDirectory;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[toPath stringByAppendingPathComponent:obj] isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] copyItemAtPath:[fromPath stringByAppendingPathComponent:obj]
                                                    toPath:[toPath stringByAppendingPathComponent:obj]
                                                     error:&error];
        }
    }];
}

-(BOOL)writeNewAbi:(NSArray*) abi withPathName:(NSString*) newTeplateName {
    
    NSString* folderPath = [NSString stringWithFormat:@"%@/%@",[self contractDirectory],newTeplateName];
    NSString* filePath = [NSString stringWithFormat:@"%@/abi-contract",folderPath];


    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSError *err = nil;
    
    NSMutableData *jsonData = [[NSJSONSerialization dataWithJSONObject:abi
                                                               options:0 
                                                                 error:&err] copy];
    [jsonData writeToFile:filePath atomically:YES];
    
    if (err != nil) {
        return NO;
    } else {
        return YES;
    }
}

-(NSDate*)getDateOfCreationTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self contractDirectory],templateName];
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:[path stringByAppendingPathComponent:resContents[0]] error:nil];
    
    if (attrs) {
        
        return (NSDate*)[attrs objectForKey: NSFileCreationDate];
    } else {
        
        return nil;
    }
}


@end