import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this.transactions, this.deleteTx);

  final Function deleteTx;
  final List<Transaction> transactions;

  List<Transaction> get getMostRecentTrasactionsFirst {
    return transactions.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    print('Build: TransactionList Widget');
    final _mediaQuery = MediaQuery.of(context);
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FittedBox(
                      child: Text(
                        'No transactions added yet  ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: transactions.map((tx) {
            String date = DateFormat.yMMMMEEEEd().format(tx.date);
            return TransactionListItem(
              key: ValueKey(tx.id),
              transaction: tx,
              date: date,
              deleteTransactionHandler: deleteTx,
            );
          }).toList());
  }
}
