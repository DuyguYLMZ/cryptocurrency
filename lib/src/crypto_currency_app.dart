import 'package:crypto_currency/src/navigation/router.dart' as nav;
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

class CryptoCurrencyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CryptoProvider(),
          ),
        ],
        child:   MaterialApp(
      title: 'Cryptocurrencies',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        accentColor: Colors.redAccent,
      ),
      onGenerateRoute: nav.Router().generateRoute,
      initialRoute: nav.Routes.home,
    )
    );

  }
}
