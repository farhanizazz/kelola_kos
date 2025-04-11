import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kelola_kos/shared/bindings/global_binding.dart';
import 'package:kelola_kos/utils/services/notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:kelola_kos/configs/routes/route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'configs/pages/page.dart';
import 'configs/themes/theme.dart';
import 'firebase_options.dart';
import 'utils/services/sentry_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      print("✅ Workmanager Task Triggered: $task");

      await Hive.initFlutter();
      await Hive.openBox('notification');
      await NotificationService().init(requestPermission: false);
      await NotificationService().checkAndRescheduleNotifications();
    } catch (e, st) {
      log(e.toString(), name: 'Worker error');
      log(st.toString(), name: 'Worker error');
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("venturo");
  await Hive.openBox('notification');
  await dotenv.load(fileName: ".env");
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  await Workmanager().registerPeriodicTask(
    "reschedule_notifications_id",
    "rescheduleNotificationsTask",
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(minutes: 1),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
  await Workmanager().cancelByUniqueName("reschedule_on_launch");
  await Workmanager().registerOneOffTask(
    "reschedule_on_launch",
    "rescheduleOnLaunch",
    initialDelay: const Duration(seconds: 10),
  );

  tz.initializeTimeZones();
  NotificationService().init();
  GoogleSignInService.init();
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
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: GetMaterialApp(

            title: 'KelolaKos',
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
        );
      },
    );
  }
}
