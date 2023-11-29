// ignore_for_file: file_names, camel_case_types, constant_identifier_names

import 'package:chatly/API/api_key.dart';

class api_url {
  static const BASE_URL = 'https://api.giphy.com/v1/gifs/';
  static const trending_url = '${BASE_URL}trending?api_key=${api_key.Gif_KEY}';
  static const search_url = '${BASE_URL}search?api_key=${api_key.Gif_KEY}';
  static const chatbot_url =
      "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=${api_key.chatbot_KEY}";
}
