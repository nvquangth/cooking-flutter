import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefHelper {
  factory PrefHelper.getInstance() => _PrefHelper();
}

class _PrefHelper implements PrefHelper {
  static final _PrefHelper _singleton = _PrefHelper._internal();

  factory _PrefHelper() => _singleton;

  _PrefHelper._internal();

  SharedPreferences _prefs;

  Future<SharedPreferences> _getPref() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }
}
