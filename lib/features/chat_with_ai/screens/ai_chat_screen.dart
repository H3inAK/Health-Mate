import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'dart:convert';

import '../../edu_blogs/constants/constants.dart';

final translator = GoogleTranslator();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isEnglish = true;
  bool _isLoading = false;

  final List<String> _faqQuestions = [
    'What are the best practices for maintaining a healthy diet?',
    'How much exercise should I get each week?',
    'What are the benefits of drinking enough water?',
    'How can I improve my sleep habits?',
    'What should I do to reduce stress and anxiety?',
  ];

  Future<String> _translate(String text, String toLang) async {
    final result = await translator.translate(text, to: toLang);
    return result.text;
  }

  Future<void> _sendMessage(String text) async {
    String translatedText;

    setState(() {
      _messages.add(
          {'role': 'user', 'content': text}); // Display the original message
      _isLoading = true;
    });
    _controller.clear();

    // If the selected language is Myanmar, translate the input to English
    if (_isEnglish) {
      translatedText = text;
    } else {
      translatedText = await _translate(text, 'en');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    final response = await http.post(
      Uri.parse('$apiHost/healthmateai'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': translatedText}),
    );

    String reply;
    if (response.statusCode == 200) {
      // Translate the bot's response to the user's selected language
      final serverReply = jsonDecode(response.body)['data']['message'];
      reply = await _translate(serverReply, _isEnglish ? 'en' : 'my');
    } else {
      reply = 'Failed to get a response from the server.';
    }

    setState(() {
      _messages.add({'role': 'bot', 'content': reply});
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Mate AI'),
        elevation: 1,
        actions: [
          ToggleButtons(
            isSelected: [_isEnglish, !_isEnglish],
            onPressed: (int index) {
              setState(() {
                _isEnglish = index == 0;
              });
            },
            constraints: const BoxConstraints(
                maxHeight: 35, maxWidth: 40, minHeight: 35, minWidth: 40),
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.onSurface
                : null,
            children: const [
              Text('EN'),
              Text('MN'),
            ],
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _messages.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello ${FirebaseAuth.instance.currentUser?.displayName}!\nHow can I assist you with your health or habit today?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Here are some frequently asked questions:',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 20),
                              // Display a list of FAQs
                              ..._faqQuestions.map((question) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      onPressed: () => _sendMessage(question),
                                      child: Text(
                                        question,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isUser = message['role'] == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: isUser ? 10 : 20,
                                left: isUser ? 20 : 10,
                                top: 4,
                                bottom: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: isUser
                                      ? const Radius.circular(22)
                                      : const Radius.circular(0),
                                  topLeft: const Radius.circular(22),
                                  topRight: const Radius.circular(22),
                                  bottomRight: isUser
                                      ? const Radius.circular(0)
                                      : const Radius.circular(22),
                                ),
                              ),
                              child: Text(
                                message['content']!,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                if (_isLoading)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Healthmate AI is thinking...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Container(
              decoration: Theme.of(context).brightness == Brightness.light
                  ? BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 18,
                        offset: const Offset(1, 2),
                      ),
                    ])
                  : BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceBright
                            .withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 24,
                        offset: const Offset(1, 2),
                      ),
                    ]),
              child: TextField(
                controller: _controller,
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    _sendMessage(text);
                  }
                },
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Ask anything about your health ...',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendMessage(_controller.text);
                      }
                    },
                    icon: Icon(
                      Icons.telegram,
                      size: 40,
                      color: _controller.text.isNotEmpty
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
