import "package:usstockminimemo/constants/imports.dart";

class ListPage extends StatelessWidget {
  const ListPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const bool isButtonMode = true;
    return ChangeNotifierProvider<ListModel>(
      create: (_) => ListModel()..fetchMemos(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          automaticallyImplyLeading: false, // 戻るボタンを表示しない
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                // 画面遷移の動きを変更
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                    ) {
                      return const SettingsPage();
                    },
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      const Offset begin = Offset(1.0, 0.0); // 右から左
                      // final Offset begin = Offset(-1.0, 0.0); // 左から右
                      const Offset end = Offset.zero;
                      final Animatable<Offset> tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(
                        CurveTween(curve: Curves.easeInOut),
                      );
                      final Animation<Offset> offsetAnimation =
                          animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ],

          title: Text(
            AppLocalizations.of(context)!.appName,
            style: titleTextStyle20,
          ),
        ),
        body: Column(
          children: [
            AdBanner(),
            Expanded(
              child: Consumer<ListModel>(
                builder: (
                  BuildContext context,
                  ListModel model,
                  Widget? child,
                ) {
                  final stockmemos = model.stockmemos;
                  final stockcards = stockmemos
                      .map(
                        (stockcard) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: StockCard(
                            isButtonMode: isButtonMode,
                            stockname: stockcard.name,
                            ticker: stockcard.ticker,
                            market: stockcard.market,
                            memo: stockcard.memo,
                            createdAt: stockcard.createdAt,
                            updatedAt: stockcard.updatedAt,
                            onDeleteChanged: () async {
                              await showDialog(
                                context: context,
                                builder: (
                                  BuildContext context,
                                ) {
                                  return CustomAlertDialog(
                                    title: AppLocalizations.of(context)!.checkDelete,
                                    buttonText: "OK",
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await model.deleteMemo(stockcard);
                                      await model.fetchMemos();
                                    },
                                  );
                                },
                              );
                            },
                            onEditChanged: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(
                                    stockmemo: stockcard,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList();
                  return ListView(
                    key: GlobalKey(),
                    children: stockcards,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) =>
                    EditPage(
                  stockmemo: null,
                ),
                fullscreenDialog: true,
              ),
            );
          },
          label: Text(
            AppLocalizations.of(context)!.newMemo,
            style: buttonTextStyle16,
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
