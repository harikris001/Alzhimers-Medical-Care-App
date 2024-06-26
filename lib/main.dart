import 'package:alzhcare/screens/main_screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

void main() {
  OpenAI.apiKey = 'YOUR_API_KEY_HERE';
  runApp(MyApp());
}

@immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlzhCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(size: 30.0, color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17.0),
        ),
        iconTheme: iconThemeData.copyWith(color: Colors.black),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black),
              shadowColor: MaterialStateProperty.all(Colors.grey)),
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        hintColor: Colors.grey,
        inputDecorationTheme: inputDecorationTheme,
        drawerTheme: drawerThemeData.copyWith(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData(
        appBarTheme: appBarTheme,
        iconTheme: iconThemeData,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.white),
              shadowColor: MaterialStateProperty.all(Colors.white)),
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: textTheme,
        hintColor: Colors.grey,
        inputDecorationTheme: inputDecorationTheme,
        drawerTheme: drawerThemeData,
      ),
      home: const MainScreen(),
    );
  }

  TextTheme textTheme = const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  );

  IconThemeData iconThemeData = const IconThemeData(color: Colors.white);

  InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      focusColor: Colors.grey,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIconColor: Colors.grey);

  AppBarTheme appBarTheme = const AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(size: 30.0, color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17.0),
  );

  DrawerThemeData drawerThemeData = DrawerThemeData(
    backgroundColor: Colors.black,
    scrimColor: Colors.grey.withOpacity(0.18),
  );
}
