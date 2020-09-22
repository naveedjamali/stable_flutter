import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String label;
  final Function handler;

  AdaptiveFlatButton({this.label, this.handler});
  @override
  Widget build(BuildContext context) {
    
    print('Build: AdaptiveFlatButton Widget');
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler,
          )
        : FlatButton(
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Theme.of(context).primaryColor,
            onPressed: handler,
          );
  }
}
