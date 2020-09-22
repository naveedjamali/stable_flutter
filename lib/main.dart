import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            button: TextStyle(color: Colors.white)),
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;
  final List<Transaction> _userTransactions = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  Widget _buildLandScape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: _showChart,
          onChanged: (value) {
            setState(() {
              _showChart = value;
            });
          },
        ),
      ],
    );
  }

  List<Widget> _buildPortrait(_mediaQuery, appBar, trxListWidget) {
    return [
      Container(
        height: (_mediaQuery.size.height -
                appBar.preferredSize.height -
                _mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      trxListWidget
    ];
  }

  PreferredSizeWidget _buildCupertinoAppBar() {
    return CupertinoNavigationBar(
      leading: Text(
        'Personal Expneses',
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Personal Expneses',
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewTransaction(context);
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Build: HomeWidget');
    final _mediaQuery = MediaQuery.of(context);
    final isLandscape = _mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoAppBar() : _buildAppBar();
    final trxListWidget = Container(
      height: (_mediaQuery.size.height -
              appBar.preferredSize.height -
              _mediaQuery.padding.top) *
          0.6,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final chartWidgetFull = Container(
      height: (_mediaQuery.size.height -
              appBar.preferredSize.height -
              _mediaQuery.padding.top) *
          0.7,
      child: Chart(_recentTransactions),
    );

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) _buildLandScape(),
            if (!isLandscape)
              ..._buildPortrait(_mediaQuery, appBar, trxListWidget),
            if (isLandscape) _showChart ? chartWidgetFull : trxListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: body)
        : Scaffold(
            appBar: appBar,
            // body: FlexFit_Demo(),
            body: body,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
