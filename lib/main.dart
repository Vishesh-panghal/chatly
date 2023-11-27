// ignore_for_file: unused_import

import 'package:chatly/API/Api_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Trending_gif/trending_gif_bloc.dart';
import 'Responsive/homepage.dart';
import 'Screen/Auth/Responsive/desktop_view.dart';
import 'Screen/Auth/Responsive/mobile_view.dart';
import 'Screen/Auth/Screens/WelcomeScreen.dart';
import 'Screen/Personal/profile.dart';
import 'Screen/Personal/settings.dart';
import 'Screen/splashScreen.dart';
import 'Screen/tablet_scaffold.dart';
import 'Screen/userChatScreen.dart';
import 'Screen/widgets/mapWidget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  // } else {
  //   MobileAds.instance.initialize();
  // }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider(
    create: (context) => TrendingGifBloc(apiHelper: ApiHelper()),
    child: const MyApp(),
  ));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(
        mobileScaffold: SplashScreenPage(),
        tabletScaffold: TabletScaffold(),
        desktopScaffld: DesktopAuthScreen(),
      ),
      // home:const MapPage(),
    );
  }

  void initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
