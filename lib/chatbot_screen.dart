import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class Chatbot_Screen extends StatefulWidget {
  const Chatbot_Screen({super.key});

  @override
  State<Chatbot_Screen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<Chatbot_Screen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool isConnected = false;
  bool isConnecting = true;
  String connectionStatus = "Initialisation...";

  final String clientId = const Uuid().v4();

  final String broker = 'test.mosquitto.org';
  final int port = 1883;
  late MqttServerClient client;

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    setupMqtt();
  }

  void _addSystemMessage(String text) {
    if (mounted) {
      setState(() {
        messages.add({"from": "system", "text": text});
      });
    }
  }

  Future<void> setupMqtt() async {
    try {
      _updateStatus("Configuration du client MQTT...");

      client = MqttServerClient.withPort(broker, 'flutter-$clientId', port);
      client.logging(on: false);
      client.keepAlivePeriod = 20;
      client.autoReconnect = false;
      client.connectTimeoutPeriod = 10000;

      client.onConnected = () {
        print('✅ Callback: Connected');
        _onConnected();
      };

      client.onDisconnected = () {
        print('⚠️ Callback: Disconnected');
        _onDisconnected();
      };

      client.onSubscribed = (String topic) {
        print('✅ Callback: Subscribed to $topic');
      };

      final connMsg = MqttConnectMessage()
          .withClientIdentifier('flutter-$clientId')
          .startClean()
          .withWillQos(MqttQos.atMostOnce);
      client.connectionMessage = connMsg;

      print('🔌 Début connexion à $broker:$port');
      await client.connect();

      int attempts = 0;
      while (client.connectionStatus?.state == MqttConnectionState.connecting && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }

      final state = client.connectionStatus?.state;

      if (state == MqttConnectionState.connected) {
        _onConnected();
      } else {
        throw Exception('Connexion échouée. État: $state');
      }

    } catch (e) {
      print('❌ Erreur setupMqtt: $e');
      _addSystemMessage("Erreur de connexion: $e\n\nVérifiez votre réseau ou le serveur MQTT.");

      if (mounted) {
        setState(() {
          isConnecting = false;
          isConnected = false;
        });
      }
    }
  }

  void _onConnected() {
    if (mounted) {
      setState(() {
        isConnected = true;
        isConnecting = false;
      });
    }

    _messageSubscription?.cancel();

    final topic = 'chat/response/$clientId';
    client.subscribe(topic, MqttQos.atLeastOnce);
    print('✅ Abonné à : $topic');

    _messageSubscription = client.updates?.listen(
          (List<MqttReceivedMessage<MqttMessage>> c) {
        final msg = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(msg.payload.message);

        try {
          final data = jsonDecode(payload);
          print('💬 Réponse bot: ${data["reply"]}');

          if (mounted) {
            setState(() {
              messages.add({"from": "bot", "text": data["reply"] ?? ""});
            });
          }
        } catch (e) {
          print('⚠️ Erreur parsing réponse: $e');
        }
      },
      onError: (dynamic error) {
        print('⚠️ Erreur stream: $error');
      },
    );
  }

  void _onDisconnected() {
    print('🔴 Déconnecté');
    _messageSubscription?.cancel();
    _messageSubscription = null;

    if (mounted) {
      setState(() {
        isConnected = false;
      });
      _addSystemMessage("Déconnecté du serveur");
    }
  }

  void _updateStatus(String status) {
    if (mounted) {
      setState(() {
        connectionStatus = status;
      });
    }
  }

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (!isConnected || client.connectionStatus?.state != MqttConnectionState.connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Non connecté au serveur MQTT'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      messages.add({"from": "user", "text": text});
    });
    _controller.clear();

    final payload = jsonEncode({
      "message": text,
      "clientId": clientId,
    });

    final topic = 'chat/request/$clientId';
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    try {
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      print('📤 Message envoyé sur $topic');
    } catch (e) {
      print('❌ Erreur envoi: $e');
      _addSystemMessage("Erreur d'envoi: $e");
      setState(() {
        messages.removeLast();
      });
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    client.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (isConnecting)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDarkMode ? Colors.white : Colors.blue,
                    ),
                  )
                else
                  Icon(
                    isConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: isConnected ? Colors.green : Colors.red,
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center()
                : ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, i) {
                final m = messages[i];
                final isUser = m["from"] == "user";
                final isSystem = m["from"] == "system";

                if (isSystem) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.blue[900]?.withOpacity(0.3)
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDarkMode ? Colors.blue[700]! : Colors.blue.shade200,
                        ),
                      ),
                      child: Text(
                        m["text"] ?? "",
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.blue[200] : Colors.blue[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? (isDarkMode ? Colors.blue[700] : Colors.blue[200])
                          : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m["text"] ?? "",
                      style: TextStyle(
                        color: isUser
                            ? (isDarkMode ? Colors.white : Colors.black)
                            : (isDarkMode ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: isConnected,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintText: isConnected ? 'Tapez votre message...' : '',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        filled: true,
                        fillColor: isConnected
                            ? (isDarkMode ? Colors.grey[800] : Colors.grey[100])
                            : (isDarkMode ? Colors.grey[900] : Colors.grey[200]),
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: isConnected ? sendMessage : null,
                    color: isConnected
                        ? (isDarkMode ? Colors.blue[300] : Colors.blue)
                        : (isDarkMode ? Colors.grey[700] : Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
