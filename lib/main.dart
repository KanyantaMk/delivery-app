import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/locator.dart';
import 'package:food_delivery/common/service_call.dart';
import 'package:food_delivery/utils/local_storage.dart';
import 'package:food_delivery/view/login/welcome_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:food_delivery/view/on_boarding/startup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/globs.dart';
import 'common/my_http_overrides.dart';

SharedPreferences? prefs;
void main() async {
  setUpLocator();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();

  if (Globs.udValueBool(Globs.userLogin)) {
    ServiceCall.userPayload = Globs.udValue(Globs.userPayload);
  }

  runApp(const MyApp(defaultHome: StartupView(),));
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = TColor.primaryText
    ..backgroundColor = TColor.primary
    ..indicatorColor = Colors.yellow
    ..textColor = TColor.primaryText
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = getUserId();
  }

  Future<String?> getUserId() async {
    String? userId = await LocalStorage.getValue("userId");
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: widget.defaultHome,
      navigatorKey: locator<NavigationService>().navigatorKey,
      builder: (context, child) {
        return FutureBuilder<String?>(
          future: _userIdFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else {
                  final String? userId = snapshot.data;
                  if (userId != null && userId.isNotEmpty) {
                    return MaterialApp(
                      title: 'Food Delivery',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        fontFamily: "Metropolis",
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                        // useMaterial3: true,
                      ),
                      home: const MainTabView(),
                      builder: (context, child) {
                        return FlutterEasyLoading(child: child);
                      },
                    );
                  } else {
                    return MaterialApp(
                      title: 'Food Delivery',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        fontFamily: "Metropolis",
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                        // useMaterial3: true,
                      ),
                      home: const WelcomeView(),
                      builder: (context, child) {
                        return FlutterEasyLoading(child: child);
                      },
                    );
                  }
                }
            }
          },
        );
      },
    );
  }
}
