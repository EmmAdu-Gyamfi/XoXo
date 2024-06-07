
import 'package:flutter/material.dart';
import 'package:xoxo/utils/colors.dart';


class DialogProgress extends StatelessWidget {

  final String message;

  DialogProgress(this.message);

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((16))),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(width: 16 * 2),
          Expanded(child: Text(message))
        ],
      ),
    );
  }
}
