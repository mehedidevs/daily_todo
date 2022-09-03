import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {

  final box = GetStorage();
  final key = 'isDarkMode';

  bool loadThemeFromBox() => box.read(key) ?? false;

  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  _saveThemeToBox(bool isDarkMode)=> box.write(key ,isDarkMode);


  void switchTheme(){

    Get.changeThemeMode(loadThemeFromBox()? ThemeMode.light:ThemeMode.dark);
    _saveThemeToBox(!loadThemeFromBox());

  }

}
