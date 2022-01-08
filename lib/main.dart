import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:bloc/bloc.dart';
import 'package:crypto_currency/src/crypto_currency_app.dart';
import 'package:crypto_currency/src/di/injector.dart';
import 'package:crypto_currency/src/ui/controller/cryptoprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/crypto_currency_app.dart';
const EVENTS_KEY = "fetch_events";


/// This "Headless Task" is run when app is terminated.
void main() {
  _ensureFlutterBindingsInitialized();
  _setPortraitMode();
  _injectDependencies();
  _setupBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CryptoCurrencyApp());
}

void _ensureFlutterBindingsInitialized() =>
    WidgetsFlutterBinding.ensureInitialized();

void _setPortraitMode() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void _setupBlocDelegate() => BlocSupervisor.delegate = inject<BlocDelegate>();

void _injectDependencies() => Injector.inject();
