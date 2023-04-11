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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EditModel>(
          create: (_) => EditModel(),
        ),
        ChangeNotifierProvider<SettingsModel>(
          create: (_) => SettingsModel()..getAllSettings(),
        ),
      ],
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            isUpdate
                ? AppLocalizations.of(context)!.edit
                : AppLocalizations.of(context)!.create,
            style: titleTextStyle20,
          ),
          leading: Consumer<SettingsModel>(
            builder: (
              BuildContext context,
              SettingsModel settingsModel,
              Widget? child,
            ) =>
                // 一覧ボタンを設置して設定に対応可能に
                IconButton(
              icon: const Icon(Icons.list_sharp),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: !settingsModel.startDisplayPage
                        ? (context) => const ListPage()
                        : (context) => const GridPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ),
        ),
        // EditModelを呼び出し
        body: Consumer<EditModel>(
          builder: (
            BuildContext context,
            EditModel editModel,
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
                        labelText: AppLocalizations.of(context)!.tickerLabel,
                        hintText: AppLocalizations.of(context)!.tickerRuleText,
                        maxLength: 5,
                        onChanged: (text) {
                          editModel.stockTicker = text;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)!.tickerHintText;
                          } else if (!RegExp(r"^[a-zA-Z]{1,5}$")
                              .hasMatch(value)) {
                            return AppLocalizations.of(context)!.tickerRuleText;
                          }
                        },
                        keyboardType: TextInputType.url,
                      ),
                      CustomTextFormField(
                        controller: nameController,
                        labelText: AppLocalizations.of(context)!.stockNameLabel,
                        onChanged: (text) {
                          editModel.stockName = text;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .stockNameHintText;
                          }
                        },
                        keyboardType: TextInputType.text,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.marketLabel,
                              style: const TextStyle(
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
                                editModel.onChanged(value!);
                                stockmemo?.market = value;
                              },
                              value: isUpdate
                                  ? stockmemo?.market
                                  : editModel.dropdownValue,
                              items: editModel.markets
                                  .map<DropdownMenuItem<String>>(
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
                        labelText: AppLocalizations.of(context)!.memoLabel,
                        maxLines: 10,
                        onChanged: (text) {
                          editModel.stockMemo = text;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)!.memoHintText;
                          }
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        // SettingsModelを呼び出し
                        child: Consumer<SettingsModel>(
                          builder: (
                            BuildContext context,
                            SettingsModel settingsModel,
                            Widget? child,
                          ) =>
                              ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                buttonColor,
                              ),
                            ),
                            onPressed: () async {
                              editModel.startLoading();
                              if (_key.currentState!.validate()) {
                                if (!isUpdate) {
                                  await addMemo(settingsModel, editModel, context);
                                } else {
                                  await updateMemo(settingsModel, editModel, context);
                                }
                              }
                              editModel.endLoading();
                            },
                            child: Text(
                              isUpdate
                                  ? AppLocalizations.of(context)!.done
                                  : AppLocalizations.of(context)!.save,
                              style: buttonTextStyle20,
                            ),
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
    SettingsModel settingsModel,
    EditModel editModel,
    BuildContext context,
  ) async {
    try {
      final navigator = Navigator.push(
        context,
        MaterialPageRoute(
          builder: !settingsModel.startDisplayPage
              ? (context) => const ListPage()
              : (context) => const GridPage(),
        ),
      );
      final dialogResult = showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) =>
            CustomAlertDialog(
          title: AppLocalizations.of(context)!.saved,
          buttonText: "OK",
        ),
      );
      await editModel.addMemo();
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
    SettingsModel settingsModel,
    EditModel editModel,
    BuildContext context,
  ) async {
    try {
      final navigator = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GridPage(),
        ),
      );
      final dialogResult = showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return CustomAlertDialog(
            title: AppLocalizations.of(context)!.updated,
            buttonText: "OK",
          );
        },
      );
      await editModel.updateMemo(stockmemo!);
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
