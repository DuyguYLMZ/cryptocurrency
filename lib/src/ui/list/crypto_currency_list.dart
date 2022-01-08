import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:crypto_currency/src/ui/list/crypto_currency_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/view.dart';

class CryptoCurrencyList extends StatelessWidget {
  final List<CryptoCurrencyRate> cryptoCurrencies;
  final ValueSetter<CryptoCurrencyRate> onValueSelected;
  final VoidCallback onRefresh;
  final CryptoHelper helper;
  final bool isFav;
  List<CryptoCurrencyRate> favList;
  final CryptoProvider cryptoProvider;

   CryptoCurrencyList(this.cryptoCurrencies,
      {Key key,
      this.onValueSelected,
      this.onRefresh,
      this.helper,
      this.favList,
      this.isFav,
      this.cryptoProvider})
      : super(key: key);
   List<CryptoCurrencyRate> cryptoCurrenciesTempList = [];
  @override
  Widget build(BuildContext context) {
    cryptoProvider.setAllCryptoList(cryptoCurrencies);
    if(cryptoProvider.getFavPage()){
      cryptoCurrenciesTempList = cryptoProvider.getFavList();
    }else{
      cryptoCurrenciesTempList = cryptoCurrencies;
    }
    cryptoProvider.setCryptoList(cryptoCurrenciesTempList);
    cryptoProvider.setSearchCryptoList(cryptoCurrenciesTempList);
    return RefreshView(
        onRefresh: onRefresh,
        child: ListView.builder(
            itemCount: cryptoCurrenciesTempList.length,
            itemBuilder: (BuildContext context, int index) =>
                CryptoCurrencyListItem(
                    cryptoCurrencyRate: cryptoCurrenciesTempList[index],
                    onTap: () {
                      onValueSelected?.call(cryptoCurrenciesTempList[index]);
                    },
                    helper: helper,
                    cryptoProvider: cryptoProvider)));
  }
}
