import 'package:usstockminimemo/constants/imports.dart';
import 'package:intl/intl.dart';

class EditModel extends ChangeNotifier {
  List<String> markets = ["東証プライム", "東証スタンダード", "東証グロース", "その他"];
  String _dropdownValue = "東証プライム";
  String get dropdownValue => _dropdownValue;

  String stockName = '';
  String stockCode = '';
  String stockMarket = '';
  String stockMemo = '';
  // datetime型をDateFormatで日時のフォーマットを整える
  String stockCreatedAt =
      DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()).toString();
  String stockUpdatedAt = '';

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
      stockCode,
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
    // stockCodeが変更されない場合は元の値を代入
    if (stockCode.isEmpty) {
      stockCode = memo.code;
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
      stockCode,
      stockMarket,
      stockMemo,
      // 新規登録以降は登録日時を変更することはないので元の価を代入
      stockCreatedAt = memo.createdAt,
      // datetime型をDateFormatで日時のフォーマットを整える
      stockUpdatedAt =
          DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()).toString(),
    );

    if (memo.id != null) {
      await dbhelp.updateMemo(changeMemo);
    } else {
      throw ('IDなし');
    }
  }
}
