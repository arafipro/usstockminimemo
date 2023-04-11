import "package:usstockminimemo/constants/imports.dart";

class SettingsModel with ChangeNotifier {
  // いきなり入力初期値
  bool _startEditPage = true;
  // いきなり入力getter
  bool get startEditPage => _startEditPage;

  // 一覧表示切替初期値
  bool _startDisplayPage = true;
  // 一覧表示切替初期値getter
  bool get startDisplayPage => _startDisplayPage;

  Future<void> getAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // いきなり入力
    final startEditPageValue = prefs.getBool("startEditPage") ?? false;
    _startEditPage = startEditPageValue;
    // 一覧表示切替
    final startDisplayPageValue = prefs.getBool("startDisplayPage") ?? false;
    _startDisplayPage = startDisplayPageValue;
    notifyListeners();
  }

  // いきなり入力設定変更
  Future<void> setStartEditPage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("startEditPage", value);
    _startEditPage = value;
    notifyListeners();
  }

  // 一覧表示切替設定変更
  Future<void> setStartDisplayPage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("startDisplayPage", value);
    _startDisplayPage = value;
    notifyListeners();
  }
}
