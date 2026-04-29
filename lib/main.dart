import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:yosr_pos/components/loading_indicator.dart';
import 'package:yosr_pos/firebase_options.dart';
import 'package:yosr_pos/services/api_crud_services.dart';
import 'package:yosr_pos/services/firebase_messaging_services.dart';
import 'package:yosr_pos/services/token_manager.dart';
import 'package:yosr_pos/utilities/colors.dart';
import 'package:yosr_pos/view/auth/login.dart';
import 'package:yosr_pos/view/merchant_orders/merchant_orders.dart';
import 'package:yosr_pos/view/restaurnat_orders/restaurant_orders.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/app_binding.dart';
import 'utilities/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ar');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // لو عايز تمنع القلبه خالص خلي بس portraitUp
  ]);


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessagingService fcmService = FirebaseMessagingService();
  fcmService.initialize();

  double currentVersion = 1;
  Get.put(TokenManager(),permanent: true);
  final controller = Get.put(APICrudServices(),permanent: true);

  return await controller.get(endPoint: '/api/v1/commission-conf/version').then((value) {
    if(value.status){
      if((double.tryParse(value.data['version'].toString())??0) >= currentVersion ){
        runApp(const MyApp());
      }else{

        runApp(ForceUpdateApp(url: value.data['url']??'',));
      }
    }else{
      runApp(OutOfService());
    }
  },);


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        title: 'UNO POS',
        locale: const Locale('ar'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.white,
          ),
          fontFamily: Constants.cairoFont,
          useMaterial3: true,
        ),
        builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.autoScale(320, name: 'MOBILE_SMALL'),
            const ResponsiveBreakpoint.autoScale(375, name: 'MOBILE'),
            const ResponsiveBreakpoint.autoScale(480, name: 'MOBILE_LARGE'),

            const ResponsiveBreakpoint.resize(800, name: 'TABLET'),
            const ResponsiveBreakpoint.resize(1200, name: 'DESKTOP'),
          ],
        ),
        home: MainNavigatorChecker()
    );
  }
}

class MainNavigatorChecker extends StatefulWidget {
  const MainNavigatorChecker({super.key});

  @override
  State<MainNavigatorChecker> createState() => _MainNavigatorCheckerState();
}

class _MainNavigatorCheckerState extends State<MainNavigatorChecker> {
  final tokenManagerController = Get.put(TokenManager());
  late final _tokenChecker = tokenManagerController.getToken();
  late final _roleChecker = tokenManagerController.getUserRole();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future.wait([_tokenChecker,_roleChecker]), builder:  (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasData &&snapshot.data?[0] != null && snapshot.data?[1] != null){
          return snapshot.data![1] == 'MERCHANT' ?MerchantOrders() : RestaurantOrders();
        }else{
          return Login();
        }
      }else{
        return SizedBox(
          child: ColoredBox(color: Colors.white,child: Center(child: LoadingIndicator()),),
        );
      }
    },);
  }
}



class ForceUpdateApp extends StatelessWidget {
  final String url;
  const ForceUpdateApp({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        title: 'UNO POS',
        locale: const Locale('ar'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.white,
          ),
          fontFamily: Constants.cairoFont,
          useMaterial3: true,
        ),
        builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.autoScale(320, name: 'MOBILE_SMALL'),
            const ResponsiveBreakpoint.autoScale(375, name: 'MOBILE'),
            const ResponsiveBreakpoint.autoScale(480, name: 'MOBILE_LARGE'),

            const ResponsiveBreakpoint.resize(800, name: 'TABLET'),
            const ResponsiveBreakpoint.resize(1200, name: 'DESKTOP'),
          ],
        ),
        home: UpdateRequiredPage(updateUrl: url)
    );
  }
}
class UpdateRequiredPage extends StatelessWidget {
  final String updateUrl;

  const UpdateRequiredPage({
    super.key,
    required this.updateUrl,
  });

  Future<void> _openUpdateLink() async {
    final uri = Uri.parse(updateUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mainColor,

              mainColor,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 90,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                const Text(
                  "هذه النسخة من التطبيق أصبحت خارج الخدمة",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "يوجد إصدار جديد من التطبيق يحتوي على تحسينات مهمة.\nيرجى التحديث للمتابعة.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _openUpdateLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "تحديث الآن",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: ()async {
                    const String phone = '9647824450715';
                    final Uri url = Uri.parse('https://wa.me/$phone');

                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch WhatsApp';
                    }
                  },
                  child: const Text(
                    "تواصل مع الدعم",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class OutOfService extends StatelessWidget {
  const OutOfService({super.key,});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        title: 'UNO POS',
        locale: const Locale('ar'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.white,
          ),
          fontFamily: Constants.cairoFont,
          useMaterial3: true,
        ),
        builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.autoScale(320, name: 'MOBILE_SMALL'),
            const ResponsiveBreakpoint.autoScale(375, name: 'MOBILE'),
            const ResponsiveBreakpoint.autoScale(480, name: 'MOBILE_LARGE'),

            const ResponsiveBreakpoint.resize(800, name: 'TABLET'),
            const ResponsiveBreakpoint.resize(1200, name: 'DESKTOP'),
          ],
        ),
        home: OutOfServicePage()
    );
  }
}

class OutOfServicePage extends StatelessWidget {

  const OutOfServicePage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mainColor,

              mainColor,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 90,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                const Text(
                  "السيرفر خارج الخدمة مؤقتا",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "السيرفر متوقف حاليا بشكل طارئ ، يرجى المحاولة لاحقا",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
