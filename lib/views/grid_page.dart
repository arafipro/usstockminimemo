import "package:usstockminimemo/constants/imports.dart";

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<StockMemo> stockmemos = [];
  final dbhelp = DatabaseHelper();

  void _refreshMemos() async {
    final data = await dbhelp.getMemoList();
    setState(() {
      stockmemos = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMemos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bool isButtonMode = false;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 戻るボタンを表示しない
        backgroundColor: appBarColor,
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
          "${AppLocalizations.of(context)!.appName} G",
          style: titleTextStyle20,
        ),
      ),
      body: Column(
        children: [
          AdBanner(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: stockmemos.length,
                itemBuilder: (context, index) => StockCard(
                  isButtonMode: isButtonMode,
                  stockname: stockmemos[index].name,
                  ticker: stockmemos[index].ticker,
                  market: stockmemos[index].market,
                  memo: stockmemos[index].memo,
                  onDeleteChanged: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          title: "${stockmemos[index].name}を削除しますか？",
                          buttonText: "OK",
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await dbhelp.deleteMemo(stockmemos[index].id!);
                            _refreshMemos();
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
                          stockmemo: stockmemos[index],
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  createdAt: null,
                  updatedAt: null,
                ),
              ),
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
    );
  }
}
