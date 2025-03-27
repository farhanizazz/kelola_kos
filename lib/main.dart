import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kelola_kos/shared/bindings/global_binding.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:kelola_kos/configs/routes/route.dart';

import 'configs/pages/page.dart';
import 'configs/themes/theme.dart';
import 'firebase_options.dart';
import 'utils/services/sentry_services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("venturo");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GlobalBinding().dependencies();
  /// Change your options.dns with your project !!!!
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://30fca41e405dfa6b23883af045e4658e@o4505883092975616.ingest.sentry.io/4506539099095040';
      options.tracesSampleRate = 1.0;
      options.beforeSend = filterSentryErrorBeforeSend;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            color: Get.theme.colorScheme.surface,
            child: SafeArea(
              child: GetMaterialApp(
                title: 'Venturo Core',
                debugShowCheckedModeBanner: false,
                locale: const Locale('id', 'ID'),
                fallbackLocale: const Locale('id', 'ID'),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('id', 'ID'),
                ],
                // initialBinding: , Jika memiliki global bindding
                initialRoute: Routes.splashRoute,
                theme: MaterialTheme.lightTheme(),
                darkTheme: MaterialTheme.darkTheme(),
                themeMode: ThemeMode.system,
                getPages: Pages.pages,
              ),
            ),
          ),
        );
      },
    );
  }
}
