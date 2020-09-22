import 'package:flutter/material.dart';

class FlexFit_Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: Text('Item 1'),
          height: 100,
          color: Colors.red,
        ),
        Expanded(
          flex: 5,
          child: Container(
            child: Text('Item 2'),
            height: 100,
            width: 100,
            color: Colors.blue,
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: Container(
            color: Colors.orange,
            child: Text('Item 3'),
            height: 100,
            width: 100,
          ),
        ),
      ],
    );
  }
}
