import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/main.dart';

class MyCheckBoxTask extends StatelessWidget {
  final bool isSelected;
  final GestureTapCallback checkBoxOnTap;
  MyCheckBoxTask({required this.isSelected, required this.checkBoxOnTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: checkBoxOnTap,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? primaryColor : null),
        child: isSelected
            ? Icon(
                CupertinoIcons.check_mark,
                color: secondryTextColor,
                size: 10,
              )
            : null,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_state_picture.png',
            height: 170,
            width: 170,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Your task list is empty',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
          )
        ],
      ),
    );
  }
}
