import 'package:flutter/material.dart';


class BackgroundColorProvider with ChangeNotifier {
  
  Color _backgroundColor = Colors.white; // default color is white

  Color get backgroundColor => _backgroundColor; //color getter

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }// end 'setBackgroundColor' method

}// end 'BackgroundColorProvider' class