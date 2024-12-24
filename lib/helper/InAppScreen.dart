import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:discount_deals/utils/snackbar_helper.dart'; // Ensure this path is correct

// Dcallback types
typedef PurchaseSuccessCallback = void Function(PurchaserInfo purchaserInfo);
typedef PurchaseFailureCallback = void Function(String errorMessage);

class PurchaseProvider with ChangeNotifier {
  final String _iosKey = "appl_QWzARguPDUmaSGTHqsetrhWfnXB";
  PurchaserInfo? _purchaserInfo;
  List<String> _alreadyPurchased = [];
  Map<String, Product> _productDetails = {};

  PurchaserInfo? get purchaserInfo => _purchaserInfo;

  List<String> get alreadyPurchased => _alreadyPurchased;

  Map<String, Product> get productDetails => _productDetails;

  Future<void> initialize(String appleUserId) async {
    if (Platform.isIOS) {
      await Purchases.setDebugLogsEnabled(false);
      try {
        await Purchases.setup(_iosKey, appUserId: appleUserId);
      } catch (e) {
        await Purchases.setup(_iosKey);
      }
    }
  }

  Future<void> fetchPurchaserInfo() async {
    try {
      _purchaserInfo = await Purchases.getPurchaserInfo();
      _alreadyPurchased =
          _purchaserInfo?.allPurchasedProductIdentifiers.toList() ?? [];
      notifyListeners();
    } catch (e) {
      print('Failed to fetch purchaser info: $e');
    }
  }

  Future<bool> checkProductExist(String proId) async {
    try {
      List<Product> response = await Purchases.getProducts([proId]);
      return response.isNotEmpty;
    } catch (e) {
      print('Error checking product existence: $e');
      return false;
    }
  }

  Future<void> fetchProductDetails(List<String> productIds) async {
    try {
      List<Product> products = await Purchases.getProducts(productIds);
      for (var product in products) {
        _productDetails[product.identifier] = product;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  Future<void> purchaseProduct(
    BuildContext context,
    String productId, {
    required PurchaseSuccessCallback successCallback,
    required PurchaseFailureCallback errorCallback,
    PaymentDiscount? discount, // Add discount parameter
  }) async {
    try {
      // Fetch the latest product details to get the current price
      await fetchProductDetails([productId]);
      final product = _productDetails[productId];

      if (product == null) {
        errorCallback("Product details are not available.");
        return;
      }
      // Proceed with the purchase if the price matches
      PurchaserInfo purchaserInfo;
      if (discount != null) {
        print("discount is use");
        // Handle purchase with discount
        purchaserInfo =
            await Purchases.purchaseDiscountedProduct(product, discount);
      } else {
        print("discount is not use");
        // Handle purchase without discount
        purchaserInfo = await Purchases.purchaseProduct(productId);
      }

      _purchaserInfo = purchaserInfo;
      _alreadyPurchased =
          _purchaserInfo?.allPurchasedProductIdentifiers.toList() ?? [];

      notifyListeners();
      successCallback(purchaserInfo);
    } on PlatformException catch (e) {
      final errorMessage = handlePurchasesError(e);
      errorCallback(errorMessage);
    } catch (e) {
      errorCallback("Purchase failed. Please try again.");
    }
  }

  Future<Map<String, dynamic>> fetchProductAndDiscount(String productIdentifier) async {
    try {
      // Fetch the product
      final products = await Purchases.getProducts([productIdentifier]);

      if (products.isNotEmpty) {
        final product = products.first;

        // Create a dummy Discount object with placeholder values
        final discount = Discount(
          "$productIdentifier",
          10.0,            // Placeholder price
          '',             // Placeholder price string
          0,              // Placeholder cycles
          '',             // Placeholder period
          '',             // Placeholder period unit
          0,              // Placeholder period number of units
        );

        // Fetch the discount for the product
        PaymentDiscount? paymentDiscount;
        try {
          paymentDiscount = await Purchases.getPaymentDiscount(product, discount);
        } catch (e) {
          print('Error fetching payment discount: $e');
        }

        return {
          'product': product,
          'paymentDiscount': paymentDiscount,
        };
      } else {
        print('Product not found');
        return {};
      }
    } catch (e) {
      print('Error fetching product or discount: $e');
      return {};
    }
  }


  // Future<void> purchaseProduct(
  //     BuildContext context,
  //     String productId,
  //     double expectedPrice, // Add expected price as a parameter
  //         {
  //       required PurchaseSuccessCallback successCallback,
  //       required PurchaseFailureCallback errorCallback,
  //     }
  //     ) async {
  //   try {
  //     // Fetch the latest product details to get the current price
  //     await fetchProductDetails([productId]);
  //     final product = _productDetails[productId];
  //
  //     if (product == null) {
  //       errorCallback("Product details are not available.");
  //       return;
  //     }
  //
  //     // Proceed with the purchase if the price matches
  //     PurchaserInfo purchaserInfo = await Purchases.purchaseProduct(productId);
  //     _purchaserInfo = purchaserInfo;
  //     _alreadyPurchased = _purchaserInfo?.allPurchasedProductIdentifiers.toList() ?? [];
  //
  //     notifyListeners();
  //     successCallback(purchaserInfo);
  //   } on PlatformException catch (e) {
  //     final errorMessage = handlePurchasesError(e);
  //     errorCallback(errorMessage);
  //   } catch (e) {
  //     errorCallback("Purchase failed. Please try again.");
  //   }
  // }

  String handlePurchasesError(PlatformException e) {
    final errorCode = PurchasesErrorHelper.getErrorCode(e);
    switch (errorCode) {
      case PurchasesErrorCode.purchaseCancelledError:
        return "Purchase was cancelled.";
      case PurchasesErrorCode.purchaseNotAllowedError:
        return "Purchase not allowed.";
      case PurchasesErrorCode.purchaseInvalidError:
        return "Invalid purchase.";
      case PurchasesErrorCode.networkError:
        return "Network error occurred.";
      default:
        return "An unknown error occurred.";
    }
  }

  Product? getProductDetails(String productId) {
    return _productDetails[productId];
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:discount_deals/utils/snackbar_helper.dart'; // Ensure this path is correct
//
// // Define callback types
// typedef PurchaseSuccessCallback = void Function(PurchaserInfo purchaserInfo);
// typedef PurchaseFailureCallback = void Function(String errorMessage);
//
// class PurchaseProvider with ChangeNotifier {
//   final String _iosKey = "appl_QWzARguPDUmaSGTHqsetrhWfnXB";
//   PurchaserInfo? _purchaserInfo;
//   List<String> _alreadyPurchased = [];
//
//   PurchaserInfo? get purchaserInfo => _purchaserInfo;
//   List<String> get alreadyPurchased => _alreadyPurchased;
//
//   Future<void> initialize(String appleUserId) async {
//     if (Platform.isIOS) {
//       await Purchases.setDebugLogsEnabled(false);
//       try {
//         await Purchases.setup(_iosKey, appUserId: appleUserId);
//       } catch (e) {
//         await Purchases.setup(_iosKey);
//       }
//     }
//   }
//
//   Future<void> fetchPurchaserInfo() async {
//     try {
//       _purchaserInfo = await Purchases.getPurchaserInfo();
//       _alreadyPurchased = _purchaserInfo?.allPurchasedProductIdentifiers.toList() ?? [];
//       notifyListeners();
//     } catch (e) {
//       print('Failed to fetch purchaser info: $e');
//     }
//   }
//
//   Future<bool> checkProductExist(String proId) async {
//     try {
//       List<Product> response = await Purchases.getProducts([proId]);
//       return response.isNotEmpty;
//     } catch (e) {
//       print('Error checking product existence: $e');
//       return false;
//     }
//   }
//
//   Future<void> purchaseProduct(
//       BuildContext context,
//       String productId,
//       {
//         required PurchaseSuccessCallback successCallback,
//         required PurchaseFailureCallback errorCallback,
//       }
//       ) async {
//     try {
//       PurchaserInfo purchaserInfo = await Purchases.purchaseProduct(productId);
//       _purchaserInfo = purchaserInfo;
//       _alreadyPurchased = _purchaserInfo?.allPurchasedProductIdentifiers.toList() ?? [];
//
//       notifyListeners();
//       successCallback(purchaserInfo);
//     } on PlatformException catch (e) {
//       final errorMessage = handlePurchasesError(e);
//       errorCallback(errorMessage);
//     } catch (e) {
//       errorCallback("Purchase failed. Please try again.");
//     }
//   }
//
//   String handlePurchasesError(PlatformException e) {
//     final errorCode = PurchasesErrorHelper.getErrorCode(e);
//     switch (errorCode) {
//       case PurchasesErrorCode.purchaseCancelledError:
//         return "Purchase was cancelled.";
//       case PurchasesErrorCode.purchaseNotAllowedError:
//         return "Purchase not allowed.";
//       case PurchasesErrorCode.purchaseInvalidError:
//         return "Invalid purchase.";
//       case PurchasesErrorCode.networkError:
//         return "Network error occurred.";
//       default:
//         return "An unknown error occurred.";
//     }
//   }
// }
