import "package:usstockminimemo/constants/imports.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      // 全ての設定値を取得
      create: (_) => SettingsModel()..getAllSettings(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Delegate には、flutter_localizations 標準のものだけを設定
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(
            "ja",
            // "",
          ), // Japanese
          Locale(
            "en",
            // "",
          ), // English
        ],
        home: Consumer(
          builder: (
            BuildContext context,
            SettingsModel model,
            Widget? child,
          ) =>
              // 起動時にオープニング画面を表示
              FutureBuilder(
            future: Future.delayed(
              const Duration(
                milliseconds: 500,
              ),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: LoadPage(),
                );
              } else {
                return Scaffold(
                  // いきなり入力の設定値を取得
                  body: model.startEditPage
                      ? EditPage(
                          stockmemo: null,
                        )
                      : const ListPage(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
