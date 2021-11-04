import 'package:get/get.dart';

class AuthModeMiddleware extends GetMiddleware {
  ///middleware with the higher priority will be executed first
  @override
  int? get priority => 2;

  bool isLogin = false;

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return super.onPageBuildStart(page);
  }
}
