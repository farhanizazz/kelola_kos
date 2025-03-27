import 'dart:developer';
import 'dart:io';
import 'package:mason/mason.dart';
import 'package:path/path.dart';

void run(HookContext context) {
  String currentDirName = basename(Directory.current.path);
  context.logger
      .info("Injecting dir_name variable with value:  $currentDirName");
  context.vars['dir_name'] = currentDirName;

  // Retrieve the feature name from context variables
  String? featureName = context.vars['featureName'];
  if (featureName == null || featureName.isEmpty) {
    context.logger
        .err("Feature name is not provided in context.vars['feature_name'].");
        throw Error();
  }
  // Construct the expected path to the feature directory
  String featurePath =
      join(Directory.current.path, 'lib', 'features', featureName);

  // Check if the directory exists
  if (Directory(featurePath).existsSync()) {
    context.logger.info("Feature directory exists: $featurePath");
  } else {
    context.logger.err("Feature directory does not exist: $featurePath");
    throw Error();
  }
}
