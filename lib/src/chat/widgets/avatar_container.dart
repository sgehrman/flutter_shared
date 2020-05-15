import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/chat/chat_models.dart';

class AvatarContainer extends StatelessWidget {
  const AvatarContainer({
    @required this.user,
    this.onPress,
    this.onLongPress,
    this.isUser,
  });

  final ChatUser user;
  final bool isUser;
  final Function(ChatUser) onPress;
  final Function(ChatUser) onLongPress;

  ImageProvider avatarImage() {
    if (user.avatar != null && user.avatar.isNotEmpty) {
      return NetworkImage(user.avatar);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(user),
      onLongPress: () => onLongPress(user),
      child: CircleAvatar(
        backgroundImage: avatarImage(),
        backgroundColor: isUser
            ? Utils.darken(Colors.blue, .2)
            : Utils.darken(Colors.green, .2),
        foregroundColor: Colors.white,
        child: Text(user.initials),
      ),
    );
  }
}