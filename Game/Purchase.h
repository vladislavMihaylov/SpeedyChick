#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const PurchaseProductPurchasedNotification;
UIKIT_EXTERN NSString *const PurchaseProductCanceledPurchaseNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray* products);

@interface Purchase: NSObject

- (id) initWithProductIdentifiers: (NSSet *) productIdentifiers;
- (void) requestProductsWithCompletionHandler: (RequestProductsCompletionHandler) completionHandler;

- (void) buyProduct: (SKProduct *) product;
- (BOOL) productPurchased: (NSString *) productIdentifier;
- (void)restoreCompletedTransactions;

@end