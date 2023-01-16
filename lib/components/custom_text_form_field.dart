import 'package:usstockminimemo/constants/imports.dart';

// TextFormFieldコンポーネント
class CustomTextFormField extends StatelessWidget {
/*　引数の詳細
labelText：ラベルテキスト
hintText：ヒントテキスト
maxLines：最大行数
maxLength：最大文字数
validator：バリデーション
keyboardType：入力
*/

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final int maxLines;
  final int? maxLength;
  final dynamic onChanged;
  final dynamic validator;
  final dynamic keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    required this.onChanged,
    required this.validator,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextFormField(
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: appBarColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: appBarColor,
              width: 3.0,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
