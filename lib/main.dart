import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'home_page.dart';
import 'favorites_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent.shade100),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          elevation: 2,
          shadowColor: Colors.black26,
          centerTitle: true,
          backgroundColor: Colors.pinkAccent.shade100,
          titleTextStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.pink[50], // Fons clar
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pinkAccent.shade100, brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          elevation: 2,
          shadowColor: Colors.black54,
          centerTitle: true,
          backgroundColor: Colors.pink.shade800, // AppBar fosc
          titleTextStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.grey[900], // Fons fosc
      ),
      themeMode: themeProvider.themeMode,
      home: HomePage(favoritesService: FavoritesService()),
    );
  }
}