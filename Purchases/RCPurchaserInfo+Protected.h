//
//  RCPurchaserInfo+Protected.h
//  Purchases
//
//  Created by Jacob Eiting on 10/22/17.
//  Copyright © 2019 RevenueCat, Inc. All rights reserved.
//

#import "RCPurchaserInfo.h"
NS_ASSUME_NONNULL_BEGIN
@interface RCPurchaserInfo (Protected)

- (instancetype _Nullable)initWithData:(NSDictionary * _Nonnull)data;

@property (nonatomic, readonly) NSDictionary<NSString *, NSDate *> *expirationDatesByProduct;
@property (nonatomic, readonly) NSDictionary<NSString *, NSDate *> *purchaseDatesByProduct;
@property (nonatomic, readonly) NSDictionary<NSString *, NSObject *> *expirationDateByEntitlement;
@property (nonatomic, readonly) NSDictionary<NSString *, NSObject *> *purchaseDateByEntitlement;
@property (nonatomic, readonly) NSSet<NSString *> *nonConsumablePurchases;
@property (nonatomic, readonly) NSString  * _Nullable originalApplicationVersion;

- (NSDictionary * _Nonnull)JSONObject;

@end
NS_ASSUME_NONNULL_END
