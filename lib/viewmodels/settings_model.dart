import "package:usstockminimemo/constants/imports.dart";

class SettingsModel with ChangeNotifier {
  // いきなり入力初期値
  bool _startEditPage = true;
  // いきなり入力getter
  bool get startEditPage => _startEditPage;

  Future<void> getAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // いきなり入力
    final startEditPageValue = prefs.getBool("startEditPage") ?? false;
    _startEditPage = startEditPageValue;
    notifyListeners();
  }

  // いきなり入力設定変更
  Future<void> setStartEditPage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("startEditPage", value);
    _startEditPage = value;
    notifyListeners();
  }
}
