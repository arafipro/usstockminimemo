import 'package:usstockminimemo/constants/imports.dart';

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
          title: const Text(
            appName,
            style: titleTextStyle20,
          ),
        ),
        body: Column(
          children: [
            // AdBanner(),
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
                        (stockcard) => StockCard(
                          isButtonMode: isButtonMode,
                          stockname: stockcard.name,
                          code: stockcard.code,
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
                                  title: "${stockcard.name}を削除しますか？",
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
          label: const Text(
            '新規登録',
            style: titleTextStyle16,
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
