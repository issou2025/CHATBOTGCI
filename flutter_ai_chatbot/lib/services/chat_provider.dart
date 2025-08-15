import 'package:flutter/material.dart';
import '../models/message.dart';
import 'ai_service.dart';

class ChatProvider extends ChangeNotifier {
  final AIService _service;
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  ChatProvider(this._service);

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    _messages.add(Message(role: 'user', content: text));
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final reply = await _service.sendMessage(text);
      _messages.add(Message(role: 'assistant', content: reply));
    } catch (e) {
      _error = 'Erreur lors de la requ\u00eate';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
