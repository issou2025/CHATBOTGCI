import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/ai_service.dart';
import 'services/chat_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(AIService()),
      child: MaterialApp(
        title: 'Flutter AI Chatbot',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.indigo,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.indigo,
        ),
        themeMode: ThemeMode.system,
        home: const ChatScreen(),
      ),
    );
  }
}
