// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';

import '../../Data/Modal/chatRoomModal.dart';
import '../../firebase/firebaseProvider.dart';

class ChatBubble extends StatefulWidget {
  msgModal message;
  ChatBubble({
    required this.message,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    var currUser = FirebaseProvider.currUsrId;
    return widget.message.fromId == currUser ? fromMsgWidget() : toMsgWidget();
  }

  Widget fromMsgWidget() {
    var sentTime = TimeOfDay.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.message.sent),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Text(
            sentTime.format(context),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF69170),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.message.message,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.done_all_outlined,
                  size: 18,
                  color:
                      widget.message.read.isEmpty ? Colors.grey : Colors.blue,
                ),
                // Container(
                //   padding: const EdgeInsets.only(right: 22),
                //   child: Text(
                //     sentTime.format(context),
                //     style: const TextStyle(fontSize: 10, color: Colors.black),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget toMsgWidget() {
    if (widget.message.read.isEmpty) {
      FirebaseProvider.updateReadTime(
          widget.message.msgId, widget.message.fromId);
    }

    var sentTime = TimeOfDay.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.message.sent),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(widget.message.message),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: Text(
            sentTime.format(context),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
