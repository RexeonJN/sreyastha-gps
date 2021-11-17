import 'package:get/get.dart';

import 'package:sreyastha_gps/app/modules/FAQ/bindings/faq_binding.dart';
import 'package:sreyastha_gps/app/modules/FAQ/views/faq_view.dart';
import 'package:sreyastha_gps/app/modules/about/bindings/about_binding.dart';
import 'package:sreyastha_gps/app/modules/about/views/about_view.dart';
import 'package:sreyastha_gps/app/modules/add_marker/bindings/add_marker_binding.dart';
import 'package:sreyastha_gps/app/modules/add_marker/views/add_marker_view.dart';
import 'package:sreyastha_gps/app/modules/add_route/bindings/add_route_binding.dart';
import 'package:sreyastha_gps/app/modules/add_route/views/add_route_view.dart';
import 'package:sreyastha_gps/app/modules/add_track/bindings/add_track_binding.dart';
import 'package:sreyastha_gps/app/modules/add_track/views/add_track_view.dart';
import 'package:sreyastha_gps/app/modules/authentication/bindings/authentication_binding.dart';
import 'package:sreyastha_gps/app/modules/authentication/views/authentication_view.dart';
import 'package:sreyastha_gps/app/modules/contact_us/bindings/contact_us_binding.dart';
import 'package:sreyastha_gps/app/modules/contact_us/views/contact_us_view.dart';
import 'package:sreyastha_gps/app/modules/home/bindings/home_binding.dart';
import 'package:sreyastha_gps/app/modules/home/views/home_view.dart';
import 'package:sreyastha_gps/app/modules/payment/bindings/payment_binding.dart';
import 'package:sreyastha_gps/app/modules/payment/views/payment_view.dart';
import 'package:sreyastha_gps/app/modules/privacy_policy/bindings/privacy_policy_binding.dart';
import 'package:sreyastha_gps/app/modules/privacy_policy/views/privacy_policy_view.dart';
import 'package:sreyastha_gps/app/modules/profile/bindings/profile_binding.dart';
import 'package:sreyastha_gps/app/modules/profile/middlewares/auth_middleware.dart';
import 'package:sreyastha_gps/app/modules/profile/views/profile_view.dart';
import 'package:sreyastha_gps/app/modules/saved/bindings/saved_binding.dart';
import 'package:sreyastha_gps/app/modules/saved/views/saved_view.dart';
import 'package:sreyastha_gps/app/modules/settings/bindings/settings_binding.dart';
import 'package:sreyastha_gps/app/modules/settings/views/settings_view.dart';
import 'package:sreyastha_gps/app/modules/terms_and_conditions/bindings/terms_and_conditions_binding.dart';
import 'package:sreyastha_gps/app/modules/terms_and_conditions/views/terms_and_conditions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MARKER,
      page: () => AddMarkerView(),
      binding: AddMarkerBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.SAVED,
      page: () => SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TRACK,
      page: () => AddTrackView(),
      binding: AddTrackBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ROUTE,
      page: () => AddRouteView(),
      binding: AddRouteBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),
  ];
}
