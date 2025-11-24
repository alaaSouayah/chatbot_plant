import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';

class ProChat extends StatefulWidget {
  const ProChat({super.key});

  @override
  State<ProChat> createState() => _ProChatState();
}

class _ProChatState extends State<ProChat> {
  List<ChatMessage> messages = [];

  // Replace with your actual Gemini API key (again, **not recommended** for production)
  final String apiKey = "AIzaSyAjgNzZrAUeNvav1tU_dFDEVPImWXNjdkg";

  final ChatUser currentUser = ChatUser(id: "0", firstName: "You");
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "assets/images/ai.jpg", // Optional: Add an avatar image
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Plants Assistant"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        elevation: 0,
      ),
      body: DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            hintText: "des questions sur les plantes?...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.green.shade100,
          containerColor: Colors.green.shade200,
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage userMessage) async {
    setState(() {
      messages.insert(0, userMessage);
    });

    // Show "typing..." placeholder
    final typing = ChatMessage(
      user: geminiUser,
      text: "Typing...",
      createdAt: DateTime.now(),
    );
    setState(() => messages.insert(0, typing));

    // Fetch the response from Gemini API
    final response = await _fetchGeminiResponse(userMessage.text);

    if (response != null) {
      setState(() {
        messages[0] = ChatMessage(
          user: geminiUser,
          text: response,
          createdAt: DateTime.now(),
        );
      });
    } else {
      setState(() {
        messages.removeAt(0); // remove typing
        messages.insert(
          0,
          ChatMessage(
            user: geminiUser,
            text: "❌ Oops! Something went wrong.",
            createdAt: DateTime.now(),
          ),
        );
      });
    }
  }

  Future<String?> _fetchGeminiResponse(String message) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    final generationConfig = {
      "temperature": 1.0,
      "topP": 0.95,
      "topK": 40,
      "maxOutputTokens": 8192,
      "responseMimeType": 'text/plain',
    };

    final data = {
      "generationConfig": generationConfig,
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": message},
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Log the full response body for debugging
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Check if 'candidates' and 'parts' are present in the response
        if (responseBody['candidates'] != null &&
            responseBody['candidates'].isNotEmpty) {
          final candidates = responseBody['candidates'];
          final content = candidates[0]['content'];

          if (content != null && content['parts'] != null) {
            final parts = content['parts'];
            if (parts.isNotEmpty) {
              // Extract the text from the first part
              return parts[0]['text'] ?? "No content returned.";
            }
          }
        }
        return "No valid response content";
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error making request: $e');
      return null;
    }
  }
}
