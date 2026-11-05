import 'package:flutter/material.dart';
import 'features/home/store_home_page.dart';
import 'theme/nova_theme.dart';

void main() => runApp(const NovaStoreApp());

class NovaStoreApp extends StatelessWidget {
  const NovaStoreApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NOVA STORE',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: novaSurface,
      colorScheme: ColorScheme.fromSeed(seedColor: novaGreen),
      fontFamily: 'sans-serif',
    ),
    home: const StoreHomePage(),
  );
}
