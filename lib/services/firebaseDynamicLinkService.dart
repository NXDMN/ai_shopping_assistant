import 'package:ai_shopping_assistant/screens/product_details/view/product_details_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(String productId) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://norvin.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse('https://www.shopper.com/product?id=${productId}'),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: 'norvin.com.ai_shopping_assistant',
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      // iosParameters: const IOSParameters(
      //   bundleId: iosBundleId,
      //   minimumVersion: '2',
      // ),
    );

    final Uri uri = await dynamicLinks.buildLink(parameters);

    return uri.toString();
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deeplink = dynamicLinkData.link;

      var isProduct = deeplink.pathSegments.contains('product');
      if (isProduct) {
        String id = deeplink.queryParameters['id'] ?? '1';
        Navigator.pushNamed(context, ProductDetailsScreen.id,
            arguments: ProductDetailsScreenArguments(productId: id));
      }
    }).onError((error) {
      print(error);
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deeplink = initialLink.link;

      var isProduct = deeplink.pathSegments.contains('product');
      if (isProduct) {
        String id = deeplink.queryParameters['id'] ?? '1';
        Navigator.pushNamed(context, ProductDetailsScreen.id,
            arguments: ProductDetailsScreenArguments(productId: id));
      }
    }
  }
}
