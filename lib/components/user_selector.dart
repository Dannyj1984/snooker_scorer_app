import 'package:flutter/material.dart';
import 'package:snooker_scorer/model/user.dart';

class UserSelector extends StatefulWidget {
  const UserSelector(
      {super.key,
      required this.users,
      required this.onUserSelected,
      required this.player});

  final List<User> users;
  final Function(User user, int player) onUserSelected;
  final int player;
  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  User? _selectedUser;

  _returnUser(User user) {
    widget.onUserSelected(user, widget.player);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:
          _selectedUser != null ? _selectedUser!.name : widget.users.first.name,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 12,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedUser =
              widget.users.firstWhere((element) => element.name == newValue);
          _returnUser(
              widget.users.firstWhere((element) => element.name == newValue));
        });
      },
      items: widget.users.map<DropdownMenuItem<String>>((User user) {
        return DropdownMenuItem<String>(
          value: user.name,
          child: Text(user.name),
        );
      }).toList(),
    );
  }
}
