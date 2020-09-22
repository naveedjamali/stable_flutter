import 'package:flutter/foundation.dart';

class Transaction {
  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});

  double amount;
  DateTime date;
  String id;
  String title;
}
