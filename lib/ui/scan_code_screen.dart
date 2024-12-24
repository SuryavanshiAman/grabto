import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';


class ScanCodeScreen extends StatefulWidget{
  String result = '';

  ScanCodeScreen(this.result);

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState(result);
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {

  String result = '';
  _ScanCodeScreenState(this.result);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Barcode Result: ${widget.result}'),
          ],
        ),
      ),
    );
  }
}
