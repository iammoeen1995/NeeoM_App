import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const NeeoMApp());
}

class NeeoMApp extends StatelessWidget {
  const NeeoMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeeoM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
      ),
      home: const PinSecurityGate(),
    );
  }
}

class PinSecurityGate extends StatefulWidget {
  const PinSecurityGate({super.key});

  @override
  State<PinSecurityGate> createState() => _PinSecurityGateState();
}

class _PinSecurityGateState extends State<PinSecurityGate> {
  bool _isAuthenticated = false;
  String _enteredPin = "";
  final String _correctPin = "717171";
  String _errorMessage = "";

  void _onKeyPress(String digit) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = "";
      });

      if (_enteredPin.length == 6) {
        if (_enteredPin == _correctPin) {
          setState(() {
            _isAuthenticated = true;
          });
        } else {
          setState(() {
            _errorMessage = "Galat PIN! Dubara koshish karein.";
            _enteredPin = "";
          });
        }
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return const NeeoMHomeScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.lock_rounded, size: 50, color: Color(0xFF38BDF8)),
            const SizedBox(height: 16),
            const Text(
              "NeeoM",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 6),
            const Text("Private Space", style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                bool isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? const Color(0xFF38BDF8) : Colors.white12,
                    border: Border.all(color: Colors.white30),
                  ),
                );
              }),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  for (var row in [
                    ["1", "2", "3"],
                    ["4", "5", "6"],
                    ["7", "8", "9"],
                    ["", "0", "DEL"]
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((key) {
                          if (key.isEmpty) return const SizedBox(width: 70, height: 70);
                          if (key == "DEL") {
                            return IconButton(
                              icon: const Icon(Icons.backspace_outlined, size: 26),
                              onPressed: _onDelete,
                            );
                          }
                          return InkWell(
                            borderRadius: BorderRadius.circular(35),
                            onTap: () => _onKeyPress(key),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF131D2E),
                              ),
                              child: Center(
                                child: Text(key, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NeeoMHomeScreen extends StatefulWidget {
  const NeeoMHomeScreen({super.key});

  @override
  State<NeeoMHomeScreen> createState() => _NeeoMHomeScreenState();
}

class _NeeoMHomeScreenState extends State<NeeoMHomeScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List> _messages = [
    {"isMe": false, "text": "NeeoM App ready ho gaya ❤️", "time": "Just now"}
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({"isMe": true, "text": _msgController.text.trim(), "time": "Just now"});
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF131D2E),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF0284C7),
              child: Icon(Icons.favorite, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("NeeoM Partner", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text("Online", style: TextStyle(fontSize: 11, color: Color(0xFF22C55E))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final bool isMe = m["isMe"];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m["text"], style: const TextStyle(fontSize: 15)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF131D2E),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: "Message...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF38BDF8)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
