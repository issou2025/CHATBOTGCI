import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_provider.dart';
import '../models/message.dart';
import '../widgets/error_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot G\u00e9nie Civil IA'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final Message msg = provider.messages[index];
                  final isUser = msg.role == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft:
                              Radius.circular(isUser ? 16 : 0),
                          bottomRight:
                              Radius.circular(isUser ? 0 : 16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(
                          color: isUser
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (provider.error != null) ErrorMessage(provider.error!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ecrire votre question',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            final text = _controller.text;
                            _controller.clear();
                            provider.send(text);
                          },
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
