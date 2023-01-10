import 'package:usstockminimemo/constants/imports.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ErrorPage"),
      ),
      body: const Center(
        child: Text(
          "ErrorPage",
          style: TextStyle(
            color: Colors.red,
            fontSize: 40.0,
          ),
        ),
      ),
    );
  }
}
