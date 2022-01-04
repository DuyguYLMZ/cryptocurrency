
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/models/alarm_info.dart';
import 'package:flutter/material.dart';

 onSaveAlarm(CryptoHelper alarmHelper,BuildContext context,CryptoCurrencyRate crypto,String text) {

 var alarmInfo = AlarmInfo(
      id: crypto.id,
     alarmDateTime: DateTime.now(),
     title: 'alarm',
     price: crypto.price.toString(),
     name: crypto.name,
     limitprice:text
  );
  alarmHelper.insertAlarm(alarmInfo);
  Navigator.pop(context);
  //loadAlarms();
}

 deleteAlarm( CryptoHelper alarmHelper,int id) {
  alarmHelper.delete(id);
  //unsubscribe for notification
 // loadAlarms();
}
