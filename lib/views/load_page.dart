import "package:usstockminimemo/constants/imports.dart";

class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Text(
          appName,
          style: loadTextStyle,
        ),
      ),
    );
  }
}
