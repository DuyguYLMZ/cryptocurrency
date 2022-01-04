import 'package:crypto_currency/src/domain/entity/crypto_currency.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:crypto_currency/src/ui/controller/sharedpreference.dart';
import 'package:crypto_currency/src/ui/list/crypto_currency_list_item.dart';
import 'package:crypto_currency/src/ui/list/crypto_currency_list_screen.dart';
import 'package:crypto_currency/src/ui/models/alarm_info.dart';
import 'package:crypto_currency/src/ui/views/alarm_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/entity/crypto_currency_rate.dart';
import 'navigation/router.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with  WidgetsBindingObserver{
  bool waitingForResponse = false;
  int _selectedIndex = 0;
  List<AlarmInfo> _searchAlarmResult = [];
  List<CryptoCurrencyRate> _searchResult = [];
  TextEditingController controller = TextEditingController();

  static final List<Widget> _widgetOptions = <Widget>[
    CryptoCurrencyListScreen(),
    CryptoCurrencyListScreen(),
    AlarmPage(),
  ];
  CryptoProvider  _cryptoProvider;
  @override
  void initState() {
    _cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("aaaa");
    super.dispose();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      clearPreferences();
      final List<String> favListName=[];
      final List<CryptoCurrencyRate> favList = _cryptoProvider.getFavList();
      if(favList!=null && favList.isNotEmpty){
        for (final CryptoCurrencyRate favCrypto in favList) {
          favListName.add(favCrypto.name);
        }
      }
      saveFav(favListName);
        break;
    }

  }
  @override
  Widget build(BuildContext context) {
    if(_selectedIndex==0){
      _cryptoProvider.setIsFavPage(false);
    }else{
      _cryptoProvider.setIsFavPage(true);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CryptoCosmic',
          style: TextStyle(
              fontFamily: 'avenir',
              fontWeight: FontWeight.w700,
              fontSize: 24),
        ), // new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),,
      ),
      body: Column(
        children: [
          if (_selectedIndex == 2) Container() else Container(
              child: _buildSearchBox(),),
          Expanded(
            child:  Container(
              child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                  ? _buildSearchResults()
                  : _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'list',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'alarm',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _searchResult = [];
      _searchAlarmResult = [];
      controller.text = "";
      _selectedIndex = index;
      if(index==0){
        _cryptoProvider.setIsFavPage(false);
      }else{
        _cryptoProvider.setIsFavPage(true);
      }

    });
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Card(
        child:  ListTile(
          leading:  const Icon(Icons.search),
          title:  TextField(
            controller: controller,
            decoration:  const InputDecoration(
              hintText: 'Arama',
              border: InputBorder.none,
            ),
            onChanged: onSearchTextChanged,
          ),
          trailing:  IconButton(
            icon:  const Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }
  void _navigateToCryptoCurrencyDetails(CryptoCurrencyRate value) =>
      Navigator.pushNamed(context, Routes.details, arguments: value);

  Widget _buildSearchResults() {
    return  ListView.builder(
      itemCount:  _searchResult.length,
      itemBuilder: (context, i) =>
        CryptoCurrencyListItem(
            cryptoCurrencyRate: _searchResult[i],
            onTap: () {
              _navigateToCryptoCurrencyDetails?.call(_searchResult[i]);
            },
            helper: null,
            cryptoProvider: _cryptoProvider)

    );
  }


  Future<void> onSearchTextChanged(String text) async {
    if (_selectedIndex == 1) {
      _searchAlarmResult.clear();
    } else {
      _searchResult.clear();
    }

    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if (_selectedIndex == 1) {
      _cryptoProvider.getSearchAlarmList().forEach((alarmDetail) {
        String alarmName = alarmDetail.name.toString();
        if (alarmName.contains(text)) _searchAlarmResult.add(alarmDetail);

      });
    } else {
      _cryptoProvider.getSearchCryptoList().forEach((cryptoDetail) {
        if (cryptoDetail.cryptoCurrency.name.contains(text)) _searchResult.add(cryptoDetail);
      });
    }
    setState(() {});
  }
}