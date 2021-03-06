import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:to_do/pages/detalleLista.dart';
import 'package:to_do/pages/home.dart';
import 'package:to_do/pages/informacion.dart';
import 'package:to_do/pages/opciones.dart';
import 'package:to_do/services/SharedPref.dart';

import 'i18n/localizations_delegate.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  //SharedPref.setPrimeraVez(true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  static void setColor(BuildContext context, MaterialColor color) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setColor(color);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale _locale;
  MaterialColor _color;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setColor(MaterialColor color) {
    setState(() {
      _color = color;
    });
  }



  @override
  void didChangeDependencies() async {
    setState(() {
      _locale= SharedPref.getLocale();
      _color=SharedPref.getColor();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: _color,
      ),
      home: Home(),
      routes: {
        'home': (BuildContext context) => Home(),
        'detalles': (BuildContext context) => DetalleLista(),
        'opciones': (BuildContext context) => OpcionesPage(),
        'informacion': (BuildContext context) => InformacionPage(),
      },
      locale: _locale,
      supportedLocales: [
        Locale('en',''),
        Locale('es','')
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale?.languageCode == locale?.languageCode &&
              supportedLocale?.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales?.first;
      },
    );
  }
}