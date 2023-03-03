import "package:usstockminimemo/constants/imports.dart";

class EditPage extends StatelessWidget {
  final StockMemo? stockmemo;
  EditPage({
    super.key,
    required this.stockmemo,
  });
  final _key = GlobalKey<FormState>();

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isUpdate = stockmemo != null;
    final nameController = TextEditingController();
    final tickerController = TextEditingController();
    final memoController = TextEditingController();

    if (isUpdate) {
      nameController.text = stockmemo!.name;
      tickerController.text = stockmemo!.ticker;
      memoController.text = stockmemo!.memo;
    }

    return ChangeNotifierProvider<EditModel>(
      create: (_) => EditModel(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            isUpdate ? "$appNameShort - 編集" : "$appNameShort - 新規作成",
            style: titleTextStyle20,
          ),
          leading: IconButton(
            icon: const Icon(Icons.list_sharp),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (
                    context,
                  ) =>
                      const ListPage(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ),
        body: Consumer<EditModel>(
          builder: (
            BuildContext context,
            EditModel model,
            Widget? child,
          ) =>
              Column(
            children: [
              AdBanner(),
              Expanded(
                child: Form(
                  key: _key,
                  child: ListView(
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: tickerController,
                        labelText: "ティッカー",
                        hintText: "5文字までの半角英字を入力してください",
                        maxLength: 5,
                        onChanged: (text) {
                          model.stockTicker = text;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "ティッカーを入力してください";
                          } else if (!RegExp(r"^[a-zA-Z]{1,5}$")
                              .hasMatch(value)) {
                            return "5文字までの半角英字を入力してください";
                          }
                        },
                        keyboardType: TextInputType.url,
                      ),
                      CustomTextFormField(
                        controller: nameController,
                        labelText: "銘柄名",
                        onChanged: (text) {
                          model.stockName = text;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "銘柄名を入力してください";
                          }
                        },
                        keyboardType: TextInputType.text,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: const Text(
                              "市場",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            subtitle: DropdownButton<String>(
                              isExpanded: true,
                              underline: Container(
                                height: 1,
                                color: Colors.black26,
                              ),
                              onChanged: (String? value) {
                                model.onChanged(value!);
                                stockmemo?.market = value;
                              },
                              value: isUpdate
                                  ? stockmemo?.market
                                  : model.dropdownValue,
                              items:
                                  model.markets.map<DropdownMenuItem<String>>(
                                (String text) {
                                  return DropdownMenuItem<String>(
                                    value: text,
                                    child: Text(text),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        controller: memoController,
                        labelText: "メモ",
                        maxLines: 10,
                        onChanged: (text) {
                          model.stockMemo = text;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "メモを入力してください";
                          }
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              buttonColor,
                            ),
                          ),
                          onPressed: () async {
                            model.startLoading();
                            if (_key.currentState!.validate()) {
                              if (!isUpdate) {
                                await addMemo(model, context);
                              } else {
                                await updateMemo(model, context);
                              }
                            }
                            model.endLoading();
                          },
                          child: Text(
                            isUpdate ? "編集完了" : "保存",
                            style: titleTextStyle20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addMemo(
    EditModel model,
    BuildContext context,
  ) async {
    try {
      final navigator = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ListPage(),
        ),
      );
      final dialogResult = showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) =>
            const CustomAlertDialog(
          title: "保存しました",
          buttonText: "OK",
        ),
      );
      await model.addMemo();
      await dialogResult;
      await navigator;
    } catch (e) {
      showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return CustomAlertDialog(
            title: e.toString(),
            buttonText: "OK",
          );
        },
      );
    }
  }

  Future updateMemo(
    EditModel model,
    BuildContext context,
  ) async {
    try {
      final navigator = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ListPage(),
        ),
      );
      final dialogResult = showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return const CustomAlertDialog(
            title: "変更しました",
            buttonText: "OK",
          );
        },
      );
      await model.updateMemo(stockmemo!);
      await dialogResult;
      await navigator;
    } catch (e) {
      showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return CustomAlertDialog(
            title: e.toString(),
            buttonText: "OK",
          );
        },
      );
    }
  }
}
