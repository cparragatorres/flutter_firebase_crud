import 'package:flutter/material.dart';
import 'package:trueque_app/Widgets/loading_widget.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String message;

  LoadingAlertDialog({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(height: 10.0),
          Text("Espere por favor.....")
        ],
      ),
    );
  }
}
