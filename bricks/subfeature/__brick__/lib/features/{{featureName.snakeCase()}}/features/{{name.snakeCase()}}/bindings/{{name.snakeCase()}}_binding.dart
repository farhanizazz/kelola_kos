import 'package:get/get.dart';
import 'package:{{dir_name}}/features/{{featureName.snakeCase()}}/features/{{name.snakeCase()}}/controllers/{{name.snakeCase()}}_controller.dart';

class {{name.pascalCase()}}Binding extends Bindings {
  @override
  void dependencies() {
    Get.put({{name.pascalCase()}}Controller());
  }
}