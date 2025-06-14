import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ticket_app/firebase_options.dart';
import 'package:ticket_app/page/page_tiket.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Ticket App",
      debugShowCheckedModeBanner: false,
      home:PageTiket(),
    );
  }
}
