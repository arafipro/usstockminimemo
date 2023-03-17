import "package:usstockminimemo/constants/imports.dart";

class StockCard extends StatelessWidget {
/*　引数の詳細
isButtonMode：編集・削除の操作をボタンかジェスチャーか変更するためのトリガー引数
true => ボタン、false => ジェスチャー
stockname   ：銘柄名
ticker        ：証券コード
market      ：市場
memo        ：メモ
createdAt   ：新規日時
updatedAt   ：更新日時
*/

  final bool isButtonMode;
  final String? stockname;
  final String? ticker;
  final String? market;
  final String? memo;
  final dynamic onDeleteChanged;
  final dynamic onEditChanged;
  final String? createdAt;
  final String? updatedAt;

  const StockCard({
    super.key,
    required this.isButtonMode,
    required this.stockname,
    required this.ticker,
    required this.market,
    required this.memo,
    required this.onDeleteChanged,
    required this.onEditChanged,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        widthFactor: 200,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stockname!, // 銘柄名
                  style: fontSize18,
                ),
                sizedBoxWidth8,
                Text(
                  "(${ticker!.toUpperCase()})", // ティッカー
                  style: fontSize16,
                ),
              ],
            ),
            sizedBoxHeight8,
            Text(
              market!, // 市場
              style: fontSize14,
            ),
            sizedBoxHeight8,
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                memo!, // メモ
                style: fontSize16,
              ),
            ),
            sizedBoxHeight8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.createdAt}:$createdAt",
                  style: fontSize14,
                ),
                Text(
                  "${AppLocalizations.of(context)!.updatedAt}:$updatedAt",
                  style: fontSize14,
                ),
              ],
            ),
            isButtonMode
                ? ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(
                          Icons.edit,
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.edit,
                          style: buttonTextStyle16,
                        ),
                        onPressed: onEditChanged,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(
                          Icons.delete,
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.delete,
                          style: buttonTextStyle16,
                        ),
                        onPressed: onDeleteChanged,
                      ),
                    ],
                  )
                : sizedBoxHeight8,
          ],
        ),
      ),
    );
  }
}
