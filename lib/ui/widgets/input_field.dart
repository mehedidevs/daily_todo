import 'package:daily_todo/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 10),

            decoration: BoxDecoration(
                border: Border.all(color: blueish, width: 1.0),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,

                    cursorColor: Get.isDarkMode ? Colors.blue : Colors.brown,
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                        hintText: hint,

                        hintStyle: subTitleStyle,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0))),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
