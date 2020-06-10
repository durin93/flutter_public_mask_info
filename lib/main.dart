import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publicmaskinfo/model/store.dart';
import 'package:publicmaskinfo/ui/view/main_page.dart';
import 'package:publicmaskinfo/viewmodel/store_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      ChangeNotifierProvider.value(
          value: StoreModel(),
          child: PublicMaskInfoApp())
  );
  }

class PublicMaskInfoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'public mask info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}