import 'package:flutter/material.dart';


class BackgroundColorProvider with ChangeNotifier {
  
  // define a default background color
  final Color _defaultBackgroundColor = const Color.fromARGB(255, 255, 255, 255);

  // reference the user-selected background color
  Color? _backgroundColor;

  // getter to return current background color
  Color get backgroundColor {
    // default color if no user-selected color is set
    return _backgroundColor ?? _defaultBackgroundColor;
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }// end 'setBackgroundColor' method

}// end 'BackgroundColorProvider' class