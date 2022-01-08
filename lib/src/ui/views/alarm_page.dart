
import 'package:crypto_currency/constants/theme_data.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/controller/alarmcontroller.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:crypto_currency/src/ui/controller/sharedpreference.dart';
import 'package:crypto_currency/src/ui/models/alarm_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  final CryptoHelper _cryptoHelper = CryptoHelper();
  Future<List<AlarmInfo>> _alarms;
  CryptoProvider _cryptoProvider;
  List<AlarmInfo> _currentAlarms;

  @override
  void initState() {
    _cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    final List<String> favListName=[];
    final List<CryptoCurrencyRate> favList = _cryptoProvider.getFavList();
    if(favList!=null && favList.isNotEmpty){
      for (final CryptoCurrencyRate favCrypto in favList) {
        favListName.add(favCrypto.name);
      }
    }
    FavSharedPreferences.instance.saveFav(favListName);
    _cryptoHelper.initializeDatabase().then((value) {
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() async{
    _alarms = _cryptoHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loadAlarms();
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<AlarmInfo>>(
                future: _alarms,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _currentAlarms = snapshot.data;
                    if(_currentAlarms!=null && _currentAlarms.isNotEmpty){
                      _cryptoProvider.setSearchAlarmList(_currentAlarms);
                      return ListView(
                        children: snapshot.data.map<Widget>((alarm) {
                          final gradientColor =  GradientTemplate
                              .gradientTemplate[0].colors;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColor,
                              ),

                              borderRadius: const BorderRadius.all(Radius.circular(22)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.label,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              alarm.name.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'avenir', fontSize: 20,),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '\$ ${alarm.limitprice}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'avenir',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.white,
                                        onPressed: () {
                                          deleteAlarm(_cryptoHelper,int.parse(alarm.id.toString()));
                                          _cryptoHelper.initializeDatabase().then((value) {
                                            loadAlarms();
                                          });
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    } }
                  return const Center(
                    child: Text(
                      'Alarm Listeniz Boş.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }




}
