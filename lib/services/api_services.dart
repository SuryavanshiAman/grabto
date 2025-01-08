import 'dart:convert';
import 'dart:io';

import 'package:discount_deals/model/MembershipModel.dart';
import 'package:discount_deals/model/categories_model.dart';
import 'package:discount_deals/model/coupon_model.dart';
import 'package:discount_deals/model/features_model.dart';
import 'package:discount_deals/model/gallery_model.dart';
import 'package:discount_deals/model/great_offer_model.dart';
import 'package:discount_deals/model/menu_model.dart';
import 'package:discount_deals/model/plan_model.dart';
import 'package:discount_deals/model/pre_book_table_history.dart';
import 'package:discount_deals/model/pre_book_table_model.dart';
import 'package:discount_deals/model/redeem_model.dart';
import 'package:discount_deals/model/regular_offer_model.dart';
import 'package:discount_deals/model/regular_offer_history.dart';
import 'package:discount_deals/model/book_table_pay_bill_history.dart';
import 'package:discount_deals/model/review_model.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/model/sub_categories_model.dart';
import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:discount_deals/model/time_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  //================================================
  static Future<Map<String, dynamic>?> user_signup(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/user_signup';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('user_signup response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verify_otp(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/verify_otp';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('verify_otp response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> firebaseToken(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/Token';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('verify_otp response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> user_details(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/user_details';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('user_details response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> UpdateUserCity(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/UpdateUserCity';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('UpdateUserCity response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> api_user_login(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/api_user_login';
    print('api_user_login response: $url');
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('api_user_login response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> update_profile(
      BuildContext context, Map body) async {
    final url = '$BASE_URL/update_profile';

    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('verify_otp response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> update_profile_image({
    required String userId,
    required File image,
  }) async {
    try {
      const url = '$BASE_URL/update_profile_image';
      final uri = Uri.parse(url);

      var request = http.MultipartRequest('POST', uri);
      // Add form fields
      request.fields['user_id'] = userId;

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(await response.stream.bytesToString())
            as Map<String, dynamic>;
        // Print the entire response
        print('update_profile_image response: $jsonResponse');

        return jsonResponse;
      } else {
        // Handle other status codes
        print('Failed to submit review: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
      return null;
    }
  }


  static Future<Map<String, dynamic>?> disable_account(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/DisableAccount';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('disable_account response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getwayStatus(
      BuildContext context) async {
    const url = '$BASE_URL/GatewayStatus';
    final uri = Uri.parse(url);
    final response = await http.get(uri,);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('GatewayStatus response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  //================================================

  static Future<List?> Api_show_slider(Map body) async {
    final url = '$BASE_URL/api_show_slider';
    final uri = Uri.parse(url);
    print('ShowSlider: $url');

    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      print('ShowSlider: $response');
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final data = jsonResponse['data'] as List;

      return data;
    } else {
      return null;
    }
  }

  static Future<List<CategoriesModel>?> fetchCategories() async {
    const url = '$BASE_URL/api_show_category';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_show_category: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final categories = data.map((e) {
          return CategoriesModel.fromMap(e);
        }).toList();

        return categories;
      } else {
        print("api_show_category: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<SubCategoriesModel>?> fetchSubCategories(Map body) async {
    const url = '$BASE_URL/api_show_subcategory';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_show_subcategory: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final subcategories = data.map((e) {
          return SubCategoriesModel.fromMap(e);
        }).toList();

        return subcategories;
      } else {
        print("api_show_subcategory: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<GreatOfferModel>?> show_offer(String name) async {
    final url = '$BASE_URL/show_offer/$name'; // Corrected URL format
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final res = jsonResponse['res'] as String;

      if (res == "success") {
        print('showOffer: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final offers = data.map((e) => GreatOfferModel.fromMap(e)).toList();
        return offers;
      } else {
        print("showOffer Error: $res");
        return null;
      }
    } else {
      print('Failed to load offers: ${response.statusCode}');
      return null;
    }
  }

  static Future<List<StoreModel>?> all_store(Map body) async {
    try {
      const url = '$BASE_URL/all_store';
      final uri = Uri.parse(url);
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body) as Map;
        //print('all_store 1: $jsonResponse');
        final res = jsonResponse['res'] as String;
        if (res == "success") {
          //print('all_store 2: $jsonResponse');
          final data = jsonResponse['data'] as List<dynamic>;
          final store = data.map((e) {
            return StoreModel.fromMap(e);
          }).toList();
          //print('all_store 3: ');
          return store;
        } else {
          //print("all_store: $res");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      //print('Error in all_store function: $e');
      return null; // Return null in case of an exception
    }
  }

  static Future<List<StoreModel>?> trending_store(Map body) async {
    try {
      const url = '$BASE_URL/trending_store';
      final uri = Uri.parse(url);
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body) as Map;
        //print('all_store 1: $jsonResponse');
        final res = jsonResponse['res'] as String;
        if (res == "success") {
          //print('all_store 2: $jsonResponse');
          final data = jsonResponse['data'] as List<dynamic>;
          final store = data.map((e) {
            return StoreModel.fromMap(e);
          }).toList();
          //print('all_store 3: ');
          return store;
        } else {
          //print("all_store: $res");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      //print('Error in all_store function: $e');
      return null; // Return null in case of an exception
    }
  }

  static Future<List<StoreModel>?> wishlist_show(Map body) async {
    const url = '$BASE_URL/wishlist_show';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('wishlist_show: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final store = data.map((e) {
          return StoreModel.fromMap(e);
        }).toList();

        return store;
      } else {
        print("all_store: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> api_store_fullview(Map body) async {
    const url = '$BASE_URL/api_store_fullview';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('api_store_fullview response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getsalecode(Map body) async {
    const url = '$BASE_URL/getsalecodepercentage';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('getsalecode response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> gateway_open(Map body) async {
    const url = '$BASE_URL/gateway_open';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('gateway_open response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> appstore_gateway_open(Map body) async {
    const url = '$BASE_URL/appstore_gateway_open';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('appstore_gateway_open response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> update_gateway(Map body) async {
    const url = '$BASE_URL/update_gateway';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('update_gateway response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<List<MenuModel>?> api_related_menu(Map body) async {
    final header = {"Content-Type": "application/json"};
    const url = '$BASE_URL/api_related_menu';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: body,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_trending_store: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final menus = data.map((e) {
          return MenuModel.fromMap(e);
        }).toList();

        return menus;
      } else {
        print("api_show_subcategory: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<TimeModel>?> api_store_timings(Map body) async {
    const url = '$BASE_URL/api_store_timings';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_store_timings: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final times = data.map((e) {
          return TimeModel.fromMap(e);
        }).toList();

        return times;
      } else {
        print("api_store_timings: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<FeaturesModel>?> api_features(Map body) async {
    const url = '$BASE_URL/api_features';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_features: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final features = data.map((e) {
          return FeaturesModel.fromMap(e);
        }).toList();

        return features;
      } else {
        print("api_features: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  // static Future<List<TermConditionModel>?> api_store_termconditions(Map body) async {
  //   const url = '$BASE_URL/api_store_termconditions';
  //   final uri = Uri.parse(url);
  //   final response = await http.post(uri, body: body);
  //
  //   if (response.statusCode == 200) {
  //     // Parse the JSON response
  //     final jsonResponse = json.decode(response.body) as Map;
  //     final res = jsonResponse['res'] as String;
  //     if (res == "success") {
  //       print('api_store_termconditions: $jsonResponse');
  //       final data = jsonResponse['data'] as List<dynamic>;
  //
  //       final term_condition = data.map((e) {
  //         return TermConditionModel.fromMap(e);
  //       }).toList();
  //
  //       return term_condition;
  //     } else {
  //       print("api_store_termconditions: $res");
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }

  static Future<List<TermConditionModel>?> api_store_termconditions() async {
    const url = '$BASE_URL/ConditionTermAdmin';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_store_termconditions: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final term_condition = data.map((e) {
          return TermConditionModel.fromMap(e);
        }).toList();

        return term_condition;
      } else {
        print("api_store_termconditions: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<CouponModel>?> api_related_coupons(Map body) async {
    const url = '$BASE_URL/api_related_coupons';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_related_coupons: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final coupons = data.map((e) {
          return CouponModel.fromMap(e);
        }).toList();

        return coupons;
      } else {
        print("api_related_coupons: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<GalleryModel>?> store_multiple_gallery(Map body) async {
    const url = '$BASE_URL/store_multiple_gallery';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_show_subcategory: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final images = data.map((e) {
          return GalleryModel.fromMap(e);
        }).toList();

        return images;
      } else {
        print("api_show_subcategory: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List?> store_multiple_galleryJson(Map body) async {
    const url = '$BASE_URL/store_multiple_gallery';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        final jsonResponse = json.decode(response.body) as Map;
        final data = jsonResponse['data'] as List;

        return data;
      } else {
        print("api_show_subcategory: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> store_review_rating(Map body) async {
    final url = '$BASE_URL/store_review_rating';

    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('store_review_rating response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<List<ReviewModel>?> show_store_reviews(Map body) async {
    const url = '$BASE_URL/show_store_reviews';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('show_store_reviews: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final reviews = data.map((e) {
          return ReviewModel.fromMap(e);
        }).toList();

        return reviews;
      } else {
        print("api_show_subcategory: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> add_review({
    required String userId,
    required String storeId,
    required String rating,
    required String description,
    required File image,
  }) async {
    try {
      const url = '$BASE_URL/add_review';
      final uri = Uri.parse(url);

      var request = http.MultipartRequest('POST', uri);
      // Add form fields
      request.fields['user_id'] = userId;
      request.fields['store_id'] = storeId;
      request.fields['rating'] = rating.toString();
      request.fields['description'] = description;

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(await response.stream.bytesToString())
            as Map<String, dynamic>;
        // Print the entire response
        print('add_review response: $jsonResponse');

        return jsonResponse;
      } else {
        // Handle other status codes
        print('Failed to submit review: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
      return null;
    }
  }

  static Future<List<RedeemModel>?> apply_coupon_history(Map body) async {
    const url = '$BASE_URL/apply_coupon_history';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('apply_coupon_history: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final redeems = data.map((e) {
          print("apply_coupon_history:redeems $e");
          return RedeemModel.fromMap(e);
        }).toList();

        return redeems;
      } else {
        print("apply_coupon_history: $msg");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> wishlist(Map body) async {
    const url = '$BASE_URL/wishlist';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('wishlist response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> AverageType(Map body) async {
    const url = '$BASE_URL/AverageType';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {

      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('AverageType response: $jsonResponse');
      return jsonResponse;
    } else {
      return null;
    }
  }


  static Future<List<PreBookTable>?> PreBookOffer(Map body) async {
    const url = '$BASE_URL/PreBookOffer';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('PreBookOffer: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final prebooktable = data.map((e) {
          print("PreBookOffer:redeems $e");
          return PreBookTable.fromMap(e);
        }).toList();

        return prebooktable;
      } else {
        print("PreBookOffer: $msg");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> bookedPreOffer(Map body) async {
    const url = '$BASE_URL/BookPreOffer';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('BookPreOffer response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> UpdateBookPreOffer(Map body) async {
    const url = '$BASE_URL/UpdateBookPreOffer';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('UpdateBookPreOffer response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<List<PreBookTableHistoryModel>?> BookPreOfferHistory(Map body) async {
    const url = '$BASE_URL/BookPreOfferHistory';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('BookPreOfferHistory: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final prebooktableHistory = data.map((e) {
          return PreBookTableHistoryModel.fromMap(e);
        }).toList();

        return prebooktableHistory;
      } else {
        print("BookPreOfferHistory: $msg");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<TablePayBillHistoryModel?> BookTablePayBillHistory(Map body) async {
    const url = '$BASE_URL/BookTablePayBillHistory';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('BookTablePayBillHistory: $jsonResponse');
        final data = jsonResponse['data']; // 'data' is an object, not a list

        // Map the object to the model
        final bookTablePayBillHistory = TablePayBillHistoryModel.fromMap(data);

        return bookTablePayBillHistory; // Return the single object instead of a list
      } else {
        print("BookTablePayBillHistory: $msg");
        return null;
      }
    } else {
      print("BookTablePayBillHistory: Failed with status code ${response.statusCode}");
      return null;
    }
  }


  static Future<List<PreBookTableHistoryModel>?> UserPreBookTableHistory(Map body) async {
    const url = '$BASE_URL/UserPreBookTableHistory';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('UserPreBookTableHistory: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final prebooktableHistory = data.map((e) {
          print("UserPreBookTableHistory: $e");
          return PreBookTableHistoryModel.fromMap(e);
        }).toList();

        return prebooktableHistory;
      } else {
        print("UserPreBookTableHistory: $msg");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<PreBookTableHistoryModel>?> SinglePreBookTableHistory(Map body) async {
    const url = '$BASE_URL/SinglePreBookTableHistory';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('SinglePreBookTableHistory: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final prebooktableHistory = data.map((e) {
          print("SinglePreBookTableHistory: $e");
          return PreBookTableHistoryModel.fromMap(e);
        }).toList();

        return prebooktableHistory;
      } else {
        print("SinglePreBookTableHistory: $msg");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> TablePayBill(Map body) async {
    const url = '$BASE_URL/TablePayBill';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('TablePayBill response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> UpdateTablePayBill(Map body) async {
    const url = '$BASE_URL/UpdateTablePayBill';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('UpdateTablePayBill response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> BookPreCancel(Map body) async {
    const url = '$BASE_URL/BookPreCancel';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);
    print('BookPreCancel BookPreCancel responseapi: $response');
    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('BookPreCancel responseapi: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }


  static Future<List<RegularOfferModel>?> RegularOffer(Map body) async {
    const url = '$BASE_URL/RegularOffer';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('RegularOffer: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final regularoffer = data.map((e) {
          print("RegularOffer:redeems $e");
          return RegularOfferModel.fromMap(e);
        }).toList();

        return regularoffer;
      } else {
        print("RegularOffer: $msg");
        return null;
      }
    } else {
      return null;
    }
  }
  static Future<Map<String, dynamic>?> availableSeats(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/GetAvailableSeats';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse th4e JSON resp  print("😓😓😓");onse
      print("🙉🙉");
      final jsonResponse = json.decode(response.body);
      // Print the entire response
      print("🙉🙉$jsonResponse");
      print('available response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }
    static Future<Map<String, dynamic>?> ConveinceFee() async {
    const url = '$BASE_URL/ConveinceFee';
    final uri = Uri.parse(url);
    final response = await http.get(uri,);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('ConveinceFee: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> RegularPayBill(Map body) async {
    const url = '$BASE_URL/RegularPayBill';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('RegularPayBill response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> UpdateRegularPayBill(Map body) async {
    const url = '$BASE_URL/UpdateRegularPayBill';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('UpdateRegularPayBill response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<List<RegularOfferHistory>?> UserRegularPayBillHistory(Map body) async {
    const url = '$BASE_URL/UserRegularPayBillHistory';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      final msg = jsonResponse['msg'] as String;
      if (res == "success") {
        print('UserRegularPayBillHistory: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final prebooktableHistory = data.map((e) {
          print("UserRegularPayBillHistory: $e");
          return RegularOfferHistory.fromMap(e);
        }).toList();

        return prebooktableHistory;
      } else {
        print("UserRegularPayBillHistory: $msg");
        return null;
      }
    } else {
      return null;
    }
  }

  //====================================

  static Future<Map<String, dynamic>?> api_show_city(
      BuildContext context) async {
    const url = '$BASE_URL/api_show_city';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('api_show_city response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> ShowLocality(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/ShowLocality';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('ShowLocality response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> apply_coupon(
      BuildContext context, Map body) async {
    const url = '$BASE_URL/apply_coupon';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('verify_otp response: $jsonResponse');

      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<List<PlanModel>?> show_plans(Map body) async {
    const url = '$BASE_URL/show_all_plans';
    final uri = Uri.parse(url);
    final response = await http.post(uri,body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('show_plans: $jsonResponse');
        final data = jsonResponse['data'] as List<dynamic>;

        final plans = data.map((e) {
          return PlanModel.fromMap(e);
        }).toList();

        return plans;
      } else {
        print("show_plans: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> api_membership_banner() async {
    const url = '$BASE_URL/api_membership_banner';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('api_membership_banner response: $jsonResponse');
      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<MembershipModel?> api_CurrentMembership(Map body) async {
    const url = '$BASE_URL/CurrentMembership';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final res = jsonResponse['res'] as String;
      if (res == "success") {
        print('api_CurrentMembership: $jsonResponse');
        final data = jsonResponse['data'] as Map<String, dynamic>;

        final membership = MembershipModel.fromMap(data);

        return membership;
      } else {
        print("api_CurrentMembership: $res");
        return null;
      }
    } else {
      return null;
    }
  }

  //=========================================================

  static Future<Map<String, dynamic>?> api_popup_dialog() async {
    const url = '$BASE_URL/api_popup_dialog';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the JSON response
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('api_popup_dialog response: $jsonResponse');
      return jsonResponse;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> website_setting() async {
    const url = '$BASE_URL/website_setting';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the JSON response
      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      // Print the entire response
      print('website_setting response: $jsonResponse');
      return jsonResponse;
    } else {
      return null;
    }
  }
}
