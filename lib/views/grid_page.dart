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
    // todo1 背景色を修正
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 戻るボタンを表示しない
        // todo2 配色とテキストを修正
        title: const Text("GridPage"),
      ),
      body: Padding(
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
            // todo3 編集機能を追加
            onEditChanged: () async {},
            createdAt: null,
            updatedAt: null,
          ),
        ),
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
