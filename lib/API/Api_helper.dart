// ignore_for_file: depend_on_referenced_packages, file_names, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:chatly/API/Api_urls.dart';
import 'package:http/http.dart' as http;

import 'package:chatly/API/myException.dart';

//===========================GIF API======================================//
class ApiHelper {
  Future<dynamic> getApiData({required String url}) async {
    try {
      var res = await http.get(
        Uri.parse(url),
      );
      return returnDataResponse(res);
    } on SocketException {
      throw FetchDataException(body: "Internet Error");
    }
  }
}

dynamic returnDataResponse(http.Response res) {
  switch (res.statusCode) {
    case 200:
      var mData = res.body;
      return jsonDecode(mData);
    case 400:
      throw BadRequestException(body: res.body.toString());
    case 401:
    case 403:
      throw UnAuthrisedException(body: res.body.toString());
    case 404:
      throw UnAuthrisedException(
          body:
              "The particular GIF or Sticker you are requesting was not found. This occurs, for example, if you request a GIF by using an id that does not exist.");
    case 407:
      throw UnAuthrisedException(body: res.body.toString());
    case 414:
      throw FetchDataException(
          body: "The length of the search query exceeds 50 characters.");
    case 500:
      throw FetchDataException(body: "Error while communicating to server");
    default:
      throw FetchDataException(body: "Unknown error:- ${res.body}");
  }
}

//===============================ChatBot API===================================//

void chatbotApi(String msg) async {
  const url = api_url.chatbot_url;
  final uri = Uri.parse(url);
  Map<String, dynamic> request = {
    "prompt": {
      "messages": msg,
    },
    "temperature": 0.25,
    "candidateCount": 1,
    "topP": 1,
    "topK": 1,
  };

  final response = await http.post(uri, body: jsonEncode(request));
}
