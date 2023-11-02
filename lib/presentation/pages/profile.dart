// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:habithubtest/data/data_providers/profile_repo.dart';

import 'package:habithubtest/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController textFieldController = TextEditingController();
  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  var val = true;
  UserDb userDbData = UserDb();
  @override
  Widget build(BuildContext context) {
    Future<void> displayDialog({String? docId}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Username'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100.0),
              child: Column(
                children: [
                  TextField(
                    controller: textFieldController,
                    decoration: const InputDecoration(
                        hintText: 'Type your new Username'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Close',
                ),
                onPressed: () async {
                  textFieldController.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: () {
                  if (textFieldController.text.isEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    userDbData.updateUsername(textFieldController.text);
                    textFieldController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Update',
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyan,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(5, 5),
                          blurRadius: 10,
                          spreadRadius: 0),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      size: 70,
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                  future: userDbData.getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var nullableData = snapshot.data?.data();
                      if (nullableData == null) {
                        return const Text('Username');
                      } else {
                        Map<String, dynamic> data =
                            nullableData as Map<String, dynamic>;
                        return Text(
                          data['username'],
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 30,
                            overflow: TextOverflow.fade,
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text('Unable to fetch Username');
                    }
                  }),
              const SizedBox(
                height: 32,
              ),
              const Spacer(),
              InkWell(
                onTap: () => displayDialog(),
                child: const ProfileTile(
                    // function: () => displayDialog,
                    leading: Icon(Icons.person),
                    center: Text(
                      'Edit Username',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: Icon(Icons.edit)),
              ),
              ProfileTile(
                // function: () {},
                leading: const Icon(Icons.notifications_active),
                center: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                trailing: Switch(
                  value: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                ),
              ),
              const ProfileTile(
                // function: () {},
                leading: Icon(Icons.info_outline),
                center: Text(
                  'Version',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                trailing: Text(
                  '1.0',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              InkWell(
                onTap: () => AuthService().signOut(),
                child: const ProfileTile(
                  // function: () => AuthService().signOut(),
                  leading: Icon(Icons.exit_to_app),
                  center: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              InkWell(
                onTap: () => userDbData.deleteAccount(),
                child: const ProfileTile(
                    // function: () => userDbData.deleteAccount(),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    center: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.red,
                    )),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget center;
  // var function;
  const ProfileTile({
    Key? key,
    required this.leading,
    required this.trailing,
    required this.center,
    // required this.function,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading,
              const SizedBox(
                width: 12,
              ),
              center,
              const Spacer(),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
