import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stable_flutter/models/transaction.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    Key key,
    @required this.transaction,
    @required this.date,
    @required this.deleteTransactionHandler,
  }) : super(key: key);

  final String date;
  final Function deleteTransactionHandler;
  final Transaction transaction;

  @override
  _TransactionListItemState createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  Color _bgColor;

  final _availableColors = [
    Colors.blue,
    Colors.black,
    Colors.orange,
    Colors.grey,
    Colors.amber,
    Colors.white,
    Colors.yellow,
    Colors.red,
    Colors.purple,
    Colors.green
  ];
  @override
  void initState() {
    super.initState();
    _bgColor = _availableColors[Random().nextInt(_availableColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('\$ ${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(widget.date),
        trailing: _mediaQuery.size.width > 720
            ? FlatButton.icon(
                textColor: Theme.of(context).errorColor,
                onPressed: () =>
                    widget.deleteTransactionHandler(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () =>
                    widget.deleteTransactionHandler(widget.transaction.id),
              ),
      ),
    );
  }
}
