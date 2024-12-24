import 'dart:convert';

import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/ui/coupon_fullview_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchStoreScreen extends StatefulWidget {
  @override
  _SearchStoreScreenState createState() => _SearchStoreScreenState();
}

class _SearchStoreScreenState extends State<SearchStoreScreen> {
  TextEditingController _searchController = TextEditingController();
  List<StoreModel> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _fetchStores('');
  }

  Future<void> _fetchStores(String query) async {
    final body = {"search_name": "$query"};

    String apiUrl = '$BASE_URL/search_store';
    try {
      final response = await http.post(Uri.parse(apiUrl), body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['res'] == 'success') {
          List<dynamic> data = jsonData['data'];
          setState(() {
            _filteredStores =
                data.map((store) => StoreModel.fromMap(store)).toList();
          });

          print("data: ");
        }
      } else {
        throw Exception(
            'Failed to load stores. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (query) => _fetchStores(query),
          // Call _fetchStores with the current query text
          decoration: InputDecoration(
            hintText: 'Search stores...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _fetchStores('');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredStores.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to coupon full view screen here
              // You can use Navigator to push a new screen onto the navigation stack
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CouponFullViewScreen("${_filteredStores[index].id}")),
              );
            },
            child: ListTile(
              title: Text(
                _filteredStores[index].storeName,
                maxLines: 2, // Set maxLines to 2
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
              subtitle: Text(
                _filteredStores[index].address,
                maxLines: 2, // Set maxLines to 2
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_filteredStores[index].logo),
              ),
            ),
          );
        },
      ),
    );
  }
}
