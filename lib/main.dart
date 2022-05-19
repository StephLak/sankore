import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sankore_task/providers/data_provider.dart';
import 'package:sankore_task/views/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
          create: (ctx) => DataProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sankore',
        home: MainScreen(),
      ),
    );
  }
}
