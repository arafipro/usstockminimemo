import "package:usstockminimemo/constants/imports.dart";

class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.appName,
          style: loadTextStyle,
        ),
      ),
    );
  }
}
