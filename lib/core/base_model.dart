import 'package:flutter/material.dart';
import 'package:thakafah_reports/core/viewstate.dart';


class BaseModel with ChangeNotifier {
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  bool systemError = false;
  bool reload = false;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
  void reloadPage() {
    reload= true;
    notifyListeners();
  }


}