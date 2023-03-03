import "package:usstockminimemo/constants/imports.dart";
import "package:intl/intl.dart";

class EditModel extends ChangeNotifier {
  List<String> markets = ["NYSE", "NASDAQ"];
  String _dropdownValue = "NYSE";
  String get dropdownValue => _dropdownValue;

  String stockName = "";
  String stockTicker = "";
  String stockMarket = "";
  String stockMemo = "";
  // datetime型をDateFormatで日時のフォーマットを整える
  String stockCreatedAt =
      DateFormat("yyyy/MM/dd HH:mm").format(DateTime.now()).toString();
  String stockUpdatedAt = "";

  bool isLoading = false;

  final dbhelp = DatabaseHelper();

  onChanged(String newValue) {
    _dropdownValue = newValue;
    notifyListeners();
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addMemo() async {
    StockMemo newMemo = StockMemo(
      stockName,
      stockTicker,
      // stockMarketはdropdownmenuの選択された値を代入
      stockMarket = _dropdownValue,
      stockMemo,
      stockCreatedAt,
      // 新規登録時は更新日時も同日同時間を登録
      stockUpdatedAt = stockCreatedAt,
    );
    await dbhelp.insertMemo(newMemo);
  }

  Future updateMemo(StockMemo memo) async {
    // stockNameが変更されない場合は元の値を代入
    if (stockName.isEmpty) {
      stockName = memo.name;
    }
    // stockTickerが変更されない場合は元の値を代入
    if (stockTicker.isEmpty) {
      stockTicker = memo.ticker;
    }
    // stockMarketが変更されない場合は元の値を代入
    if (stockMarket.isEmpty) {
      stockMarket = memo.market;
    }
    // stockMemoが変更されない場合は元の値を代入
    if (stockMemo.isEmpty) {
      stockMemo = memo.memo;
    }

    StockMemo changeMemo = StockMemo.withId(
      memo.id,
      stockName,
      stockTicker,
      stockMarket,
      stockMemo,
      // 新規登録以降は登録日時を変更することはないので元の価を代入
      stockCreatedAt = memo.createdAt,
      // datetime型をDateFormatで日時のフォーマットを整える
      stockUpdatedAt =
          DateFormat("yyyy/MM/dd HH:mm").format(DateTime.now()).toString(),
    );

    if (memo.id != null) {
      await dbhelp.updateMemo(changeMemo);
    } else {
      throw ("IDなし");
    }
  }
}
