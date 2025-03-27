import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart';

void run(HookContext context) {
  String currentDirName = basename(Directory.current.path);
  context.logger.info("Injecting dir_name variable with value:  $currentDirName");
  context.vars['dir_name'] = currentDirName;
}