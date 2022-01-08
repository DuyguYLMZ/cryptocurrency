import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/common/money_format.dart';
import 'package:crypto_currency/src/ui/common/trend_icon.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:crypto_currency/src/ui/controller/favouritecryptocontroller.dart';
import 'package:crypto_currency/src/ui/controller/sharedpreference.dart';
import 'package:crypto_currency/src/ui/models/crypto.dart';
import 'package:crypto_currency/src/ui/widgets/bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CryptoCurrencyListItem extends StatelessWidget {
  final CryptoCurrencyRate cryptoCurrencyRate;
  final GestureTapCallback onTap;
  final CryptoHelper helper;

  final CryptoProvider cryptoProvider;

  const CryptoCurrencyListItem(
      {Key key,
      @required this.cryptoCurrencyRate,
      this.onTap,
      this.helper,
      this.cryptoProvider})
      : assert(cryptoCurrencyRate != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CryptoCurrencyRate> favList;
    return Material(
      child: InkWell(onTap: onTap, child: pageView(context)),
    );
  }

  Widget pageView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          _CryptoCurrencyImage(cryptoCurrencyRate),
          const SizedBox(width: 16.0),
          Expanded(child: _CryptoCurrencyName(cryptoCurrencyRate)),
          const SizedBox(width: 16.0),
          _CryptoCurrencyRate(cryptoCurrencyRate),
          const SizedBox(width: 16.0),
          _CryptoFavAlarm(helper, cryptoCurrencyRate, cryptoProvider)
        ],
      ),
    );
  }
}

class _CryptoCurrencyImage extends StatelessWidget {
  final CryptoCurrencyRate cryptoCurrencyRate;

  const _CryptoCurrencyImage(this.cryptoCurrencyRate, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/${cryptoCurrencyRate.cryptoCurrency.symbol.toLowerCase()}.svg',
      placeholderBuilder: (context) => const CircleAvatar(),
    );
  }
}

class _CryptoCurrencyName extends StatelessWidget {
  final CryptoCurrencyRate cryptoCurrencyRate;

  const _CryptoCurrencyName(this.cryptoCurrencyRate, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          cryptoCurrencyRate.cryptoCurrency.symbol,
          style: context.subhead,
        ),
        const SizedBox(height: 2),
        Text(
          cryptoCurrencyRate.cryptoCurrency.name,
          style: context.caption,
        )
      ],
    );
  }
}

class _CryptoCurrencyRate extends StatelessWidget {
  final MoneyFormat moneyFormat = MoneyFormat();
  final CryptoCurrencyRate cryptoCurrencyRate;

  _CryptoCurrencyRate(this.cryptoCurrencyRate, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(moneyFormat.format(cryptoCurrencyRate.price)),
        const SizedBox(width: 16.0),
        TrendIcon(cryptoCurrencyRate.trendHistory.hour.trend),
      ],
    );
  }
}

class _CryptoFavAlarm extends StatefulWidget {
  final CryptoHelper _helper;
  final CryptoCurrencyRate cryptoCurrencyRate;
  final CryptoProvider cryptoProvider;

  const _CryptoFavAlarm(
      this._helper, this.cryptoCurrencyRate, this.cryptoProvider,
      {Key key})
      : super(key: key);

  @override
  _CryptoFavAlarmState createState() => _CryptoFavAlarmState();
}



class _CryptoFavAlarmState extends State<_CryptoFavAlarm> {

  @override
  Widget build(BuildContext context) {
    FavSharedPreferences.instance.readFav(widget.cryptoProvider);
    final List<CryptoCurrencyRate> _favList = widget.cryptoProvider.getFavList();
    return Row(
      children: <Widget>[
        IconButton(
          icon: _favList != null && _favList.length > 0
              ? Icon(
                  widget.cryptoProvider.getCryptoFavInfo(widget.cryptoCurrencyRate)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 20)
              : Icon(Icons.favorite_border, size: 20),
          color: Colors.red,
          onPressed: () {
            setState(() {
              if (widget.cryptoProvider
                  .getCryptoFavInfo(widget.cryptoCurrencyRate)) {
                widget.cryptoProvider
                    .addFavList(widget.cryptoCurrencyRate, false);
                removeFav(widget._helper, widget.cryptoCurrencyRate.id);
                final List<String> favListName=[];
                final List<CryptoCurrencyRate> favList = widget.cryptoProvider.getFavList();
                if(favList!=null && favList.isNotEmpty){
                  for (final CryptoCurrencyRate favCrypto in favList) {
                    favListName.add(favCrypto.name);
                  }
                }
                FavSharedPreferences.instance.saveFav(favListName);
              } else {
                widget.cryptoProvider
                    .addFavList(widget.cryptoCurrencyRate, true);
                onSaveFavList(widget._helper, widget.cryptoCurrencyRate);
             }
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.alarm_add_rounded,
            color: Colors.white70,
            size: 20,
          ),
          onPressed: () {
            showBottomSheetWidget(
                widget._helper, context, widget.cryptoCurrencyRate);
          },
        ),
      ],
    );
  }
}

extension _ContextExt on BuildContext {
  Color get dividerColor => Theme.of(this).dividerColor;

  TextStyle get subhead => Theme.of(this).textTheme.caption;

  TextStyle get caption => Theme.of(this).textTheme.caption;
}
