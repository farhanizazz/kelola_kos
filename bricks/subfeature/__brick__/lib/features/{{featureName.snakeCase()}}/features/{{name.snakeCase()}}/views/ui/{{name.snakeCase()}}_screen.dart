import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:{{dir_name}}/features/{{name.snakeCase()}}/constants/{{name.snakeCase()}}_assets_constant.dart';

class {{name.pascalCase()}}Screen extends StatelessWidget {
  {{name.pascalCase()}}Screen({Key? key}) : super(key: key);

  final assetsConstant = {{name.pascalCase()}}AssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
