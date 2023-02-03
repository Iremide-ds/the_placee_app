import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//todo: refer to dynamic links docs for proper implementation
class DynamicLinksProvider {
  final String url = 'https://dev.iremide.the_placee';

  // create link
  Future<Uri> createLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(url),
      uriPrefix: "https://iremide.page.link",
      androidParameters: const AndroidParameters(
        packageName: "dev.iremide.the_placee",
        minimumVersion: 0,
      ),
      // iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    return dynamicLink;
  }
}
