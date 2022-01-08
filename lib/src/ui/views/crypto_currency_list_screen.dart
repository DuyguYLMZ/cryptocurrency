import 'package:crypto_currency/src/di/injector.dart';
import 'package:crypto_currency/src/domain/bloc/crypto_currency_rate_bloc.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/navigation/router.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:crypto_currency/src/ui/controller/sharedpreference.dart';
import 'package:crypto_currency/src/ui/list/crypto_currency_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptoCurrencyListScreen extends StatefulWidget {
  CryptoCurrencyListScreen();

  @override
  _CryptoCurrencyListScreenState createState() =>
      _CryptoCurrencyListScreenState();
}

class _CryptoCurrencyListScreenState extends State<CryptoCurrencyListScreen>  with WidgetsBindingObserver{
  CryptoCurrencyRateBloc _cryptoCurrencyBloc;
  CryptoHelper _helper = CryptoHelper();
  List<CryptoCurrencyRate> favList;
  bool isFavPage;

  CryptoProvider _cryptoProvider;

  @override
  void loadFavs() async {
    favList = await _helper.getCryptoFavouriteLists();
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)  {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        final List<String> favListName=[];
        final List<CryptoCurrencyRate> favList = _cryptoProvider.getFavList();
        if(favList!=null && favList.isNotEmpty){
          for (final CryptoCurrencyRate favCrypto in favList) {
            favListName.add(favCrypto.name);
          }
        }
        FavSharedPreferences.instance.saveFav(favListName);
        break;
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        break;
    }

  }
  @override
  void initState() {
    _cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    FavSharedPreferences.instance.readFav(_cryptoProvider);
    /*_helper.initializeDatabase().then((value) {
      loadFavs();
    });*/
    isFavPage = _cryptoProvider.getFavPage();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cryptoCurrencyBloc = inject<CryptoCurrencyRateBloc>()..loadElements();
  }

  @override
  Widget build(BuildContext context) {
    FavSharedPreferences.instance.readFav(_cryptoProvider);
    return Scaffold(
      body: ViewStateBuilder<List<CryptoCurrencyRate>, CryptoCurrencyRateBloc>(
        bloc: _cryptoCurrencyBloc,
        onLoading: (context) => const LinearProgressIndicator(),
        onSuccess: (context, cryptoCurrencies) => CryptoCurrencyList(
            cryptoCurrencies,
            onValueSelected: _navigateToCryptoCurrencyDetails,
            onRefresh: _cryptoCurrencyBloc.refreshElements,
            helper: _helper,
            favList: favList,
            isFav: isFavPage,
            cryptoProvider: _cryptoProvider),
        onRefreshing: (context, cryptoCurrencies) =>
            CryptoCurrencyList(cryptoCurrencies),
      ),
    );
  }

  void _navigateToCryptoCurrencyDetails(CryptoCurrencyRate value) =>
      Navigator.pushNamed(context, Routes.details, arguments: value);

  @override
  void dispose() {
    _cryptoCurrencyBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
