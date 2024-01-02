import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:campus_connect/models/user.dart';
import 'package:campus_connect/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatUserId;

  const ChatScreen({Key? key, required this.chatUserId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.chatUserId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return Text(userData['Username']);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatId(currentUser.uid, widget.chatUserId))
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(messageData['message']),
                      subtitle: Text(
                        messageData['sender'] == currentUser.uid
                            ? 'You'
                            : messageData['senderUsername'],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(currentUser);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(User currentUser) {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      String chatId = getChatId(currentUser.uid, widget.chatUserId);

      Map<String, dynamic> messageData = {
        'message': message,
        'sender': currentUser.uid,
        'senderUsername': currentUser.username,
        'timestamp': FieldValue.serverTimestamp(),
      };

      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      messageController.clear();
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  String getChatId(String uid1, String uid2) {
    List<String> uids = [uid1, uid2];
    uids.sort();
    return '${uids[0]}_${uids[1]}';
  }
}
