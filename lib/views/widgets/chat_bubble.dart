import 'dart:io';
import 'dart:ui';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/views/screens/show_image_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool sentByMe, txtMessage;
  ChatBubble(this.message, {Key? key})
      : sentByMe = message.senderId == FirebaseAuth.instance.currentUser!.uid,
        txtMessage = message.type == 'text',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment:
            sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(message.senderName),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              mainAxisAlignment:
                  sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (sentByMe)
                  Text(
                    timeago.format(message.sentDate),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                if (sentByMe)
                  const SizedBox(
                    width: 10,
                  ),
                Expanded(
                  child: InkWell(
                    onTap: txtMessage
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowImageScreen(message.message),
                              ),
                            );
                          },
                    child: txtMessage
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: sentByMe ? Colors.blue[400] : Colors.grey,
                              borderRadius: BorderRadius.circular(20).subtract(
                                BorderRadius.only(
                                  bottomRight:
                                      Radius.circular(sentByMe ? 20 : 0),
                                  bottomLeft:
                                      Radius.circular(sentByMe ? 0 : 20),
                                ),
                              ),
                            ),
                            child: Text(message.message),
                          )
                        : Hero(
                            tag: message.message,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    sentByMe ? Colors.blue[400] : Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(20).subtract(
                                  BorderRadius.only(
                                    bottomRight:
                                        Radius.circular(sentByMe ? 20 : 0),
                                    bottomLeft:
                                        Radius.circular(sentByMe ? 0 : 20),
                                  ),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    message.message,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                if (!sentByMe)
                  const SizedBox(
                    width: 10,
                  ),
                if (!sentByMe)
                  Text(
                    timeago.format(message.sentDate),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
