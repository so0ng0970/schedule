import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  // true - 시간 , false - 내용
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  const CustomTextField(
      {required this.onSaved,
      required this.isTime,
      required this.label,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      // null 이 return 되면 에러가 없다
      // 에러가 있으면 에러를 string 값으로 리턴해준다
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return '값을 입력해주세요';
        }
        if (isTime) {
          int time = int.parse(value);
          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        }
        return null;
      },
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      maxLength: isTime ? null : 500,
      expands: !isTime,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // 숫자 외 글자  불가능
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
