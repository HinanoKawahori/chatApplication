import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.postText,
    required this.userName,
  });

  final String postText;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(postText), // Display the task name
        subtitle: Text(userName), // Display the user name as subtitle
      ),
    );
  }
}
