import 'package:usstockminimemo/constants/imports.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      // 全ての設定値を取得
      create: (_) => SettingsModel()..getAllSettings(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            "設定",
            style: titleTextStyle20,
          ),
        ),
        body: Consumer(
          builder: (
            BuildContext context,
            SettingsModel model,
            Widget? child,
          ) =>
              ListView(
            children: [
              ListTile(
                title: const Text('いきなり入力'),
                subtitle: const Text('起動時に新規登録を表示する'),
                trailing: Switch(
                  value: model.startEditPage,
                  onChanged: (value) => model.setStartEditPage(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
