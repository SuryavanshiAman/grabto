// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
//
// class BillingService {
//   BillingService._();
//   static final BillingService _instance = BillingService._();
//   static BillingService get instance => _instance;
//
//   final InAppPurchase _iap = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//
//   Future<void> initialize() async {
//     if (!await _iap.isAvailable()) {
//       print('IAP is not available');
//       return;
//     }
//
//     print('IAP is available');
//     if (Platform.isIOS) {
//       final iosPlatformAddition = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
//       print('Set iOS delegate');
//     }
//
//     _subscription = _iap.purchaseStream.listen((purchaseDetailsList) {
//       handlePurchaseUpdates(purchaseDetailsList);
//     }, onError: (error) {
//       print('Purchase stream error: $error');
//     });
//
//     print('Initialized BillingService');
//   }
//
//   Future<void> dispose() async {
//     if (Platform.isIOS) {
//       final iosPlatformAddition = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(null);
//       print('Removed iOS delegate');
//     }
//     await _subscription.cancel();
//     print('Disposed BillingService');
//   }
//
//   Future<List<ProductDetails>> fetchProducts(List<String> productIds) async {
//     print('Fetching products: $productIds');
//     final response = await _iap.queryProductDetails(productIds.toSet());
//     if (response.notFoundIDs.isNotEmpty) {
//       print('Not found product IDs: ${response.notFoundIDs}');
//     } else {
//       print('Found products: ${response.productDetails.map((p) => p.title).toList()}');
//     }
//     if (response.error != null) {
//       print('Error fetching product details: ${response.error?.message}');
//     }
//     return response.productDetails;
//   }
//
//   Future<PurchaseDetails?> makePurchase(ProductDetails product, {bool isConsumable = false}) async {
//     print('Making purchase for product: ${product.title}');
//     final purchaseParam = PurchaseParam(productDetails: product);
//
//     PurchaseDetails? purchaseDetails;
//     if (isConsumable) {
//       purchaseDetails = (await _iap.buyConsumable(purchaseParam: purchaseParam)) as PurchaseDetails?;
//     } else {
//       purchaseDetails = (await _iap.buyNonConsumable(purchaseParam: purchaseParam)) as PurchaseDetails?;
//     }
//
//     if (purchaseDetails?.status == PurchaseStatus.error) {
//       print('Purchase error: ${purchaseDetails?.error}');
//     } else {
//       print('Purchase successful: ${purchaseDetails?.purchaseID}');
//     }
//
//     return purchaseDetails;
//   }
//
//   Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
//     // Implement your backend verification logic here.
//     // Dummy implementation:
//     print('Verifying purchase: ${purchaseDetails.purchaseID}');
//     return Future.value(true);
//   }
//
//   Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
//     for (final purchaseDetails in purchaseDetailsList) {
//       print('Handling purchase update: ${purchaseDetails.purchaseID}, status: ${purchaseDetails.status}');
//       switch (purchaseDetails.status) {
//         case PurchaseStatus.pending:
//           print('Purchase pending: ${purchaseDetails.purchaseID}');
//           continue;
//         case PurchaseStatus.error:
//           print('Purchase error: ${purchaseDetails.purchaseID}, error: ${purchaseDetails.error}');
//           break;
//         case PurchaseStatus.canceled:
//           print('Purchase canceled: ${purchaseDetails.purchaseID}');
//           break;
//         case PurchaseStatus.purchased:
//         case PurchaseStatus.restored:
//           if (await verifyPurchase(purchaseDetails)) {
//             print('Purchase verified: ${purchaseDetails.purchaseID}');
//             deliverProduct(purchaseDetails);
//           } else {
//             print('Purchase verification failed: ${purchaseDetails.purchaseID}');
//             handleInvalidPurchase(purchaseDetails);
//           }
//           break;
//       }
//       if (purchaseDetails.pendingCompletePurchase) {
//         await _iap.completePurchase(purchaseDetails);
//         print('Completed purchase: ${purchaseDetails.purchaseID}');
//       }
//     }
//   }
//
//   void deliverProduct(PurchaseDetails purchaseDetails) {
//     print('Delivering product: ${purchaseDetails.purchaseID}');
//     // Deliver the product to the user
//   }
//
//   void handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     print('Handling invalid purchase: ${purchaseDetails.purchaseID}');
//     // Handle invalid purchase
//   }
// }
//
// class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     // Define the logic for whether to continue the transaction
//     print('Should continue transaction for product: ${transaction.payment.productIdentifier}');
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     // Define the logic for whether to show the price consent
//     print('Should show price consent');
//     return false;
//   }
// }
