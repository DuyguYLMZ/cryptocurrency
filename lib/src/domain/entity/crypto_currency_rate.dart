import 'package:crypto_currency/src/domain/entity/crypto_currency.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_supply.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_trend.dart';
import 'package:crypto_currency/src/domain/entity/money.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CryptoCurrencyRate extends Equatable {
  final CryptoCurrency cryptoCurrency;
  final Supply supply;
  final Money price;
  final double marketCap;
  final TrendHistory trendHistory;
  final int id;
  final String name;
  final double cryptoprice;
  final String symbol;
   bool isFav = false;

  CryptoCurrencyRate(
      {this.cryptoCurrency,
      this.supply,
      this.price,
      this.marketCap,
      this.trendHistory,
      this.id,
      this.name,
      this.cryptoprice,
      this.symbol,
      this.isFav});

  @override
  List<Object> get props =>
      [cryptoCurrency, supply, price, marketCap, trendHistory];

  bool isSatisfiedBy(String query) {
    return _nameContainsQuery(query) || _symbolContainsQuery(query);
  }

  bool _nameContainsQuery(String query) =>
      cryptoCurrency.name.toLowerCase().contains(query.toLowerCase());

  bool _symbolContainsQuery(String query) =>
      cryptoCurrency.symbol.toLowerCase().contains(query.toLowerCase());

  factory CryptoCurrencyRate.fromMap(Map<String, dynamic> json) =>
      CryptoCurrencyRate(
        id: int.parse(json['id'].toString()),
        name: json['name'].toString(),
        symbol: json['symbol'].toString(),
        cryptoprice: double.parse(json["cryptoprice"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "cryptoprice": cryptoprice,
        "supply": supply,
        "cryptoCurrency": cryptoCurrency,
        "price": price,
        "marketCap": marketCap,
        "trendHistory": trendHistory,
        "isFav": isFav,
      };
}
