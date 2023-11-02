import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyTextFieldWidget extends StatefulWidget {
  @override
  _MyTextFieldWidgetState createState() => _MyTextFieldWidgetState();
}

double height = 70;
late double width;

class _MyTextFieldWidgetState extends State<MyTextFieldWidget> {
  TextEditingController? _textController;

  String title = 'Write your goal';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autofocus: false,
      onEditingComplete: () => FocusManager.instance.primaryFocus?.unfocus(),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onSubmitted: (value) => title = value.isEmpty ? 'Write your goal' : value,
      style: const TextStyle(fontSize: 18),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: title,
        hintStyle: const TextStyle(fontSize: 18, color: Colors.white),
        counterStyle: const TextStyle(fontSize: 18),
        border: InputBorder.none,
      ),
    );
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }
}

class GoalTitle extends StatelessWidget {
  const GoalTitle({
    super.key,
    required this.color2,
  });

  final Color color2;

  @override
  Widget build(BuildContext context) {
    
    width= MediaQuery.of(context).size.width - 50;
    return Container(
      decoration: BoxDecoration(
          color: color2,
          borderRadius: const BorderRadius.all(Radius.circular(100))),
          // TODO: replace below size with the height and width variable and add an onTap function to change it to a fullscreen thing
      height: 70,
      width: MediaQuery.of(context).size.width - 50,
      // height: 70,
      // width: MediaQuery.of(context).size.width - 50,
      // width: MediaQuery.of(context).size.width,
      // margin: const EdgeInsets.fromLTRB(20, 35, 20, 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: MyTextFieldWidget(),
          ),
          // Text('Task: Write an article',
          //     style: TextStyle(fontSize: 18)),
          const Icon(
            FontAwesomeIcons.pen,
            size: 18,
          ),
          const SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}
