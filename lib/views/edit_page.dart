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
            isUpdate
                ? AppLocalizations.of(context)!.edit
                : AppLocalizations.of(context)!.create,
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
                        labelText: AppLocalizations.of(context)!.tickerLabel,
                        hintText: AppLocalizations.of(context)!.tickerRuleText,
                        maxLength: 5,
                        onChanged: (text) {
                          model.stockTicker = text;
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
                          model.stockName = text;
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
                        labelText: AppLocalizations.of(context)!.memoLabel,
                        maxLines: 10,
                        onChanged: (text) {
                          model.stockMemo = text;
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
                            isUpdate
                                ? AppLocalizations.of(context)!.done
                                : AppLocalizations.of(context)!.save,
                            style: buttonTextStyle20,
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
          // todo ListPageとGridPageを設定によって切り替える
          builder: (context) => const GridPage(),
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
          return CustomAlertDialog(
            title: AppLocalizations.of(context)!.updated,
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
