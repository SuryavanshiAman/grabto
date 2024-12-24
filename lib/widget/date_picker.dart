

import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

class DobWidget extends StatefulWidget {
  final TextEditingController controller;
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;


  const DobWidget({
    required this.controller,
    required this.initialDate,
    required this.onDateSelected,

  });

  @override
  _DobWidgetState createState() => _DobWidgetState();
}

class _DobWidgetState extends State<DobWidget> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = ThemeData.dark().copyWith(
      primaryColor: MyColors.redBG,
      colorScheme: const ColorScheme.dark(primary: MyColors.redBG),
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme,
          child: child!,
        );
      },

    );


    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(selectedDate); // Callback to the parent widget
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return
      TextField(
        onTap: ()=>_selectDate(context),
        style: TextStyle(fontSize: width*0.04, color:MyColors.whiteBG,fontWeight: FontWeight.w600),
        controller: widget.controller,
        keyboardType: TextInputType.number,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'DOB',
          hintStyle: const TextStyle(
              color:
              Color(0xFFDDDDDD)),
          prefixIcon: const Icon(
              Icons.calendar_month_sharp,
              color:
              MyColors.whiteBG),
          enabledBorder:
          OutlineInputBorder(
            gapPadding: 0,
            borderSide: const BorderSide(
                color: MyColors
                    .primaryColor),
            borderRadius:
            BorderRadius.circular(
                50.0),
          ),
          focusedBorder:
          OutlineInputBorder(
            borderSide: const BorderSide(
                color:
                MyColors.whiteBG),
            borderRadius:
            BorderRadius.circular(
                50.0),
          ),
        ),
      );

  }
}