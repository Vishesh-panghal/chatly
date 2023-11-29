// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chatly/API/Api_urls.dart';
import 'package:chatly/Data/constants/color_constants.dart';

class AIChatPage extends StatefulWidget {
  static const routeName = '/chat';
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chatbot",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                setState(() {
                  _chatHistory.clear();
                });
              },
              child: const Icon(
                Icons.clear,
                color: Colors.redAccent,
                size: 32,
              )),
          const SizedBox(width: 5),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: ListView.builder(
                itemCount: _chatHistory.length,
                shrinkWrap: false,
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Align(
                      alignment: (_chatHistory[index]["isSender"]
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: (_chatHistory[index]["isSender"]
                              ? const Color(0xFFF69170)
                              : Colors.white),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(_chatHistory[index]["message"],
                            style: TextStyle(
                                fontSize: 15,
                                color: _chatHistory[index]["isSender"]
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Type a message",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                            controller: _chatController,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          if (_chatController.text.isNotEmpty) {
                            _chatHistory.add({
                              "time": DateTime.now(),
                              "message": _chatController.text,
                              "isSender": true,
                            });
                            _chatController.clear();
                          }
                        });
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );
                        getAnswer();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorConstants.whiteShade,
                                Color(0xFFF69170),
                              ]),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 88.0,
                          minHeight: 36.0,
                        ), // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.send,
                          color: ColorConstants.whiteShade,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getAnswer() async {
    const url = api_url.chatbot_url;
    final uri = Uri.parse(url);
    List<Map<String, String>> msg = [];
    for (var i = 0; i < _chatHistory.length; i++) {
      msg.add({"content": _chatHistory[i]["message"]});
    }

    Map<String, dynamic> request = {
      "prompt": {
        "messages": [msg]
      },
      "temperature": 0.25,
      "candidateCount": 1,
      "topP": 1,
      "topK": 1
    };

    final response = await http.post(uri, body: jsonEncode(request));

    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": json.decode(response.body)["candidates"][0]["content"],
        "isSender": false,
      });
    });

    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }
}
