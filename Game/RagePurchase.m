//
//  RagePurchase.m
//  Game
//
//  Created by Vlad on 17.04.13.
//
//

#import "RagePurchase.h"

@implementation RagePurchase

+ (RagePurchase *) sharedInstance
{
    static dispatch_once_t once;
    
    static RagePurchase *sharedInstance;
    
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects: @"com.javier.speedy.kidsmode",
                                                           @"com.javier.speedy.superchick",
                                                           @"com.javier.speedy.ghostchick",
                                                           @"com.javier.speedy.noads",
                                                           @"com.javier.speedy.3rockets",
                                                           @"com.javier.speedy.15rockets",
                                                           @"com.javier.speedy.50rockets",
                                                           @"com.javier.speedy.1000coins",
                                                           @"com.javier.speedy.5000coins",
                                                           @"com.javier.speedy.20000coins",
                                     nil];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers: productIdentifiers];
        
        
    });
    
    return sharedInstance;
}

@end
