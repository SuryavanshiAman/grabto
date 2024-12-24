
import 'package:discount_deals/model/city_model.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

class ItemListDialog extends StatelessWidget {
  final List<CityModel> items;

  const ItemListDialog({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('City'),
      content: Container(
        width: double.maxFinite,
        height: 200,

        child: items.isEmpty
            ? Center(
          child: Text('No items available'),
        )
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index].city), // Display city name
              onTap: () {
                int id = items[index].id;
                //showErrorMessage(context, message: "$id");
                Navigator.of(context)
                    .pop(items[index]); // Pass selected item back
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Close the dialog without selecting any item
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}