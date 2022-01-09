import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavSharedPreferences {
  FavSharedPreferences._privateConstructor();

  static final FavSharedPreferences instance =
      FavSharedPreferences._privateConstructor();

  Future<void> saveFav(List<String> cryptoCurrencyList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favStringName", cryptoCurrencyList);
  }

  Future<void> readFav(CryptoProvider cryptoProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cryptoCurrencyList =
        await prefs.getStringList("favStringName");
    if (cryptoCurrencyList != null && cryptoCurrencyList.isNotEmpty) {
      cryptoProvider.setFavList(cryptoCurrencyList);
    }
  }

  Future<void> saveAlarm(List<String> alarmList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("alarmStringName", alarmList);
  }

  Future<void> readAlarm(CryptoProvider cryptoProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarmList = await prefs.getStringList("alarmStringName");

  }
}
