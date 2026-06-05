import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  WebSocketChannel? _channel;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _channel?.sink.close();
    super.dispose();
  }

  void _connectToWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(""));
      setState(() {
        isConnected = true;
      });
      _channel!.stream.listen(
        (message) {
          _onReceivedMessage(message);
        },
        onError: (error) {
          setState(() {
            isConnected = false;
          });
          _reconnect();
        },
        onDone: () {
          setState(() {
            isConnected = false;
          });
          _reconnect();
        },
      );
    } catch (e) {
      setState(() {
        isConnected = false;
      });
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _connectToWebSocket();
      }
    });
  }

  void _onReceivedMessage(dynamic message) {
    final Map<String, dynamic> newMessage = {
      "text": message,
      "sender": 'admin',
      "timestamp": DateTime.now(),
    };
    setState(() {
      _messages.add(newMessage);
    });
    _scrollBottom();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || !isConnected) return;
    final String messageText = _messageController.text.trim();
    final Map<String, dynamic> newMessage = {
      "text": messageText,
      "sender": 'driver',
      "timestamp": DateTime.now(),
    };
    setState(() {
      _messages.add(newMessage);
    });
    _channel!.sink.add(messageText);
    _messageController.clear();
    _scrollBottom();
  }

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF111111);
    const yellow = Color(0xFFF6C945);
    const white = Color(0xFFFDFDFB);
    const beige = Color(0xFFF4E7D3);

    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: beige,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF2A2A2A),
              child: Icon(Icons.headset_mic, color: yellow, size: 18),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'CozzyCruise Admin',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? const Color.fromARGB(255, 2, 121, 28)
                        : Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isConnected ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: isConnected ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          if (!isConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.redAccent.withOpacity(0.15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.redAccent, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Reconnecting to support...',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
              ),
            ),

          // ── MESSAGES LIST ──
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.headset_mic,
                          size: 56,
                          color: Colors.white12,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'How can we help you?',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Send a message to start chatting\nwith our support team.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white24, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isDriver = message['sender'] == 'driver';
                      return _buildBubble(message, isDriver, yellow, white);
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: white),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isConnected ? yellow : Colors.white12,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: isConnected ? black : Colors.white24,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBubble(
  Map<String, dynamic> message,
  bool isDriver,
  Color yellow,
  Color white,
) {
  return Align(
    alignment: isDriver ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDriver ? yellow : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isDriver ? 18 : 4),
          bottomRight: Radius.circular(isDriver ? 4 : 18),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isDriver ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message['text'],
            style: TextStyle(
              color: isDriver ? const Color(0xFF111111) : white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message['timestamp'],
            style: TextStyle(
              color: isDriver
                  ? const Color(0xFF111111).withOpacity(0.5)
                  : white.withOpacity(0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    ),
  );
}
}
