import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/models/crypto.dart';


onSaveFavList( CryptoHelper _favouriteListHelper,CryptoCurrencyRate cryptoInfo) {
  _favouriteListHelper.insertFavouriteList(cryptoInfo);
}

removeFav( CryptoHelper _favouriteListHelper,int id) {
  _favouriteListHelper.deleteFav(id);
}
