import 'package:crypto_currency/constants/theme_data.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/controller/alarm_helper.dart';
import 'package:crypto_currency/src/ui/controller/alarmcontroller.dart';
import 'package:crypto_currency/src/ui/models/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


showBottomSheetWidget(
    CryptoHelper _helper, BuildContext context, CryptoCurrencyRate crypto ) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    useRootNavigator: true,
    context: context,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: bottomSheet(_helper,crypto),
          ));
    },
  );

}
Widget bottomSheet(CryptoHelper _helper, CryptoCurrencyRate crypto ) {
  final TextEditingController _textEditingController = TextEditingController();
  return StatefulBuilder(
    builder: (context, setModalState) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            FlatButton(
              onPressed: () async {
                var selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  final now = DateTime.now();
                  var selectedDateTime = DateTime(now.year, now.month, now.day,
                      selectedTime.hour, selectedTime.minute);
                  //_alarmTime = selectedDateTime;
                  setModalState(() {});
                }
              },
              child: Text(
                crypto.name.toString(),
                style: TextStyle(fontSize: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right:30.0),
                    child: Text(
                      "Fiyat",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '0.0',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: const Text(
                      "USD",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                _textEditingController.text!=null && _textEditingController.text!="" ?  onSaveAlarm(_helper, context, crypto,_textEditingController.text): null;
              },
              icon: Icon(Icons.alarm),
              label: Text('Tamam'),
            )
          ],
        ),
      );
    },
  );
}

