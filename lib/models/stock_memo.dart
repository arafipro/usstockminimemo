// メモモデル
class StockMemo {
  int? id;
  late String name; // 銘柄名
  late String ticker; // 証券コード
  late String market; // 市場
  late String memo; // メモ
  late String createdAt; // 登録日時
  late String updatedAt; // 更新日時

  StockMemo(
    this.name,
    this.ticker,
    this.market,
    this.memo,
    this.createdAt,
    this.updatedAt,
  );
  StockMemo.withId(
    this.id,
    this.name,
    this.ticker,
    this.market,
    this.memo,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map["id"] = id;
    }
    map["name"] = name;
    map["ticker"] = ticker;
    map["market"] = market;
    map["memo"] = memo;
    map["createdAt"] = createdAt;
    map["updatedAt"] = updatedAt;

    return map;
  }

  StockMemo.fromMapObject(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    ticker = map["ticker"];
    market = map["market"];
    memo = map["memo"];
    createdAt = map["createdAt"];
    updatedAt = map["updatedAt"];
  }
}
