
#import "Purchase.h"
#import <StoreKit/Storekit.h>
#import "Settings.h"

NSString *const PurchaseProductPurchasedNotification = @"PurchaseProductPurchasedNotification";
NSString *const PurchaseProductCanceledPurchaseNotification = @"PurchaseProductCanceledPurchaseNotification";

@interface Purchase () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation Purchase
{
    SKProductsRequest *_productsRequest;
    
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet *_productsIdentifiers;
    NSMutableSet *_purchasedProductIdentifiers;
}

- (id) initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if(self = [super init])
    {
        _productsIdentifiers = productIdentifiers;
        
        _purchasedProductIdentifiers = [[NSMutableSet alloc] init]; //[NSMutableSet set];
        
        for(NSString *productIdentifier in _productsIdentifiers)
        {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey: productIdentifier];
            
            if(productPurchased)
            {
                [_purchasedProductIdentifiers addObject: productIdentifier];
                
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            else
            {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver: self];
    }
    
    return self;
}

- (void) requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: _productsIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void) productsRequest: (SKProductsRequest *) request didReceiveResponse: (SKProductsResponse *) response
{
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray *skProducts = response.products;
    
    for(SKProduct *skProduct in skProducts)
    {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    
    _completionHandler = nil;
}

- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list of products.");
    
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
}

- (BOOL) productPurchased:(NSString *)productIdentifier
{
    return [_purchasedProductIdentifiers containsObject: productIdentifier];
}

- (void) buyProduct:(SKProduct *)product
{
    NSLog(@"Buying %@...", product.productIdentifier);
    
    if([SKPaymentQueue canMakePayments])
    {
        SKPayment *payment = [SKPayment paymentWithProduct: product];
        [[SKPaymentQueue defaultQueue] addPayment: payment];
    }
    else
    {
        NSLog(@"OLOLOLOLOLOLO");
    }
    
}

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction: transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction: transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction: transaction];
                
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *) transaction
{
    NSLog(@"Complete transaction");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: PurchaseProductCanceledPurchaseNotification object: self];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) provideContentForProductIdentifier: (NSString *) productIdentifier
{
    [_purchasedProductIdentifiers addObject: productIdentifier];
    
    NSLog(@"Count: %i", [_productsIdentifiers count]);
    
    if([_productsIdentifiers containsObject: productIdentifier])
    {
        [self applyPurchase: productIdentifier];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool: YES forKey: productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName: PurchaseProductPurchasedNotification
                                                        object: productIdentifier
                                                      userInfo: nil];
}

- (void) applyPurchase: (NSString *) identifier
{
    if([identifier isEqualToString: @"com.javier.speedy.kidsmode"])
    {
        [Settings sharedSettings].isKidsModeBuyed = YES;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.superchick"])
    {
        [Settings sharedSettings].isSuperChickBuyed = YES;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.ghostchick"])
    {
        [Settings sharedSettings].isGhostChickBuyed = YES;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.noads"])
    {
        [Settings sharedSettings].isAdEnabled = NO;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.3rockets"])
    {
        [Settings sharedSettings].countOfRockets += 3;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.15rockets"])
    {
        [Settings sharedSettings].countOfRockets += 15;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.50rockets"])
    {
        [Settings sharedSettings].countOfRockets += 50;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.1000coins"])
    {
        [Settings sharedSettings].countOfCoins += 1000;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.5000coins"])
    {
        [Settings sharedSettings].countOfCoins += 5000;
    }
    else if([identifier isEqualToString: @"com.javier.speedy.20000coins"])
    {
        [Settings sharedSettings].countOfCoins += 20000;
    }
    
    [[Settings sharedSettings] save];
}

@end