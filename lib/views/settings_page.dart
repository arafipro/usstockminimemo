import "package:usstockminimemo/constants/imports.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  // バージョン情報を取得
  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      // 全ての設定値を取得
      create: (_) => SettingsModel()..getAllSettings(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          automaticallyImplyLeading: false, // 戻るボタンを表示しない
          title: Text(
            AppLocalizations.of(context)!.settings,
            style: titleTextStyle20,
          ),
          leading: Consumer(
            builder: (
              BuildContext context,
              SettingsModel model,
              Widget? child,
            ) =>
                IconButton(
              icon: const Icon(Icons.list_sharp),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: !model.startDisplayPage
                        ? (context) => const ListPage()
                        : (context) => const GridPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
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
                title: Text(
                  AppLocalizations.of(context)!.startupTitle,
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.startupSubTitle,
                ),
                trailing: Switch(
                  value: model.startEditPage,
                  onChanged: (value) => model.setStartEditPage(value),
                ),
              ),
              ListTile(
                // todo 多言語化の設定
                title: const Text("ListPageとGridPageの切り替え"
                    // AppLocalizations.of(context)!.startupTitle,
                    ),
                subtitle: const Text("ListPageとGridPageの切り替えます"
                    // AppLocalizations.of(context)!.startupSubTitle,
                    ),
                trailing: Switch(
                  value: model.startDisplayPage,
                  onChanged: (value) => model.setStartDisplayPage(value),
                ),
              ),
              FutureBuilder<PackageInfo>(
                future: _getPackageInfo(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<PackageInfo> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text("ERROR");
                  } else if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }
                  final data = snapshot.data!;
                  return ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    subtitle: Text(data.version),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
