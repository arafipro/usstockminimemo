import "package:usstockminimemo/constants/imports.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
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
          title: Text(
            AppLocalizations.of(context)!.settings,
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
