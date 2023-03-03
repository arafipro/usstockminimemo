import "package:usstockminimemo/constants/imports.dart";

class ListModel extends ChangeNotifier {
  List<StockMemo> stockmemos = [];
  // DatabaseHelper dbhelp;ではなく下記通りにする
  final dbhelp = DatabaseHelper();

  Future fetchMemos() async {
    final memos = await dbhelp.getMemoList();
    stockmemos = memos;
    notifyListeners();
  }

  Future deleteMemo(StockMemo memo) async {
    await dbhelp.deleteMemo(memo.id!);
  }
}
