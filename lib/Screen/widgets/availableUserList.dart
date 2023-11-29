// ignore_for_file: prefer_const_constructors, avoid_print, sort_child_properties_last, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data/Modal/chatRoomModal.dart';
import '../../Data/Modal/userModal.dart';
import '../../Data/constants/color_constants.dart';
import '../../firebase/firebaseProvider.dart';
import '../userChatScreen.dart';

class ChatMessageList extends StatelessWidget {
  ChatMessageList({
    super.key,
    required this.size,
    this.fontSize = 15,
    this.fontWeight = FontWeight.normal,
  });

  final Size size;
  final double fontSize;
  final FontWeight fontWeight;

  bool showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.01,
      ),
      width: size.width,
      // height: size.height*0.646,
      decoration: const BoxDecoration(
        color: ColorConstants.whiteShade,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          topLeft: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          searchBarWidget(fontSize: fontSize, size: size),
          SizedBox(height: size.height * 0.02),
          Divider(),
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: FutureBuilder<List<RegisterModal>>(
              future: FirebaseProvider.getAllUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print({'length:-${snapshot.data?.length}'});
                  return Center(
                    child: Text('Error:- ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var currUsr = snapshot.data![index];
                      return StreamBuilder(
                        stream:
                            FirebaseProvider.getChatLastMessage(currUsr.uId!),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            var msg = snapshot.data!.docs;
                            msgModal? lastMessage;
                            if (msg.isNotEmpty) {
                              lastMessage = msgModal.fromJson(msg[0].data());
                            }
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(
                                  'https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg',
                                ),
                                radius: fontSize * 2,
                              ),
                              title: InkWell(
                                onTap: () {
                                  if (MediaQuery.of(context).orientation ==
                                      Orientation.portrait) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          name:
                                              '${currUsr.uFirstName} ${currUsr.uLastName}',
                                          toId: currUsr.uId.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  currUsr.uFirstName,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.manrope().fontFamily,
                                    fontSize: fontSize * 1.2,
                                    fontWeight: fontWeight,
                                    color: ColorConstants.blackShade,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                msg.isEmpty
                                    ? currUsr.uLastName
                                    : msgModal.fromJson(msg[0].data()).message,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.manrope().fontFamily,
                                  fontSize: fontSize / 1.4,
                                  color: ColorConstants.blackShade,
                                ),
                              ),
                              trailing: Column(
                                children: [
                                  msg.isNotEmpty
                                      ? Text(lastMessage!.sent)
                                      : SizedBox(
                                          width: 0,
                                          height: 0,
                                        ),
                                  msg.isNotEmpty
                                      ? showReadStatus(
                                          lastMessage!, currUsr.uId!)
                                      : SizedBox(),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showReadStatus(msgModal lastmsg, String chatUserId) {
    if (lastmsg.fromId == FirebaseProvider.currUsrId) {
      return Icon(
        Icons.done_all_outlined,
        size: fontSize,
        color: lastmsg.read != "" ? Colors.blue : Colors.grey,
      );
    } else {
      return StreamBuilder(
        stream: FirebaseProvider.getUnreadCount(chatUserId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var messages = snapshot.data!.docs;
            if (messages.isEmpty) {
              return SizedBox(
                child: Text(
                  '${messages.length}',
                  style: TextStyle(color: Colors.black),
                ),
              );
            } else {
              Container(
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '${messages.length}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                decoration:
                    BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
              );
            }
          }
          return SizedBox(
            child: Text('None'),
          );
        },
      );
    }
  }
}

class searchBarWidget extends StatefulWidget {
  const searchBarWidget({super.key, required this.fontSize, required this.size});
  final Size size;
  final double fontSize;

  @override
  State<searchBarWidget> createState() => _searchBarWidgetState();
}

class _searchBarWidgetState extends State<searchBarWidget> {
  bool showSearchBar = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showSearchBar = !showSearchBar;
            });
          },
          child: Icon(
            Icons.search,
            size: widget.fontSize * 2,
          ),
        ),
        if (showSearchBar)
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(6),
            width: widget.size.width * 0.4,
            decoration: BoxDecoration(
              color: ColorConstants.yellowShade, // ColorConstants.yellowShade,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Direct Message',
                  style: TextStyle(
                    fontFamily: 'Manrope', // GoogleFonts.manrope().fontFamily,
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // ColorConstants.blackShade,
                  ),
                ),
              ],
            ),
          ),
        if (!showSearchBar)
          Container(
            padding: const EdgeInsets.all(6),
            width: widget.size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Groupe',
                  style: TextStyle(
                    fontFamily: 'Manrope', // GoogleFonts.manrope().fontFamily,
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color:
                        ColorConstants.blackShade, // ColorConstants.blackShade,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
