import 'package:datz_flutter/consts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({super.key});

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  final Uri url = Uri.parse('https://github.com/Krecharles/Datz');
  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logScreenView(screenName: "CreditsPage");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            CupertinoColors.systemBackground.resolveFrom(context).withAlpha(30),
        middle: const Text(
          "Credits",
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: Container(
        decoration: CustomDecorations.primaryGradientDecoration(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Center(
              child: SizedBox(
                width: 600,
                child: Column(
                  children: [
                    const Text(
                      "If you find a bug, your class is missing, a subject has the wrong coefficient or if you have an improvement idea, feel free to open an issue on GitHub. I will try my best to solve your problems. ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 64),
                    buildGithubLine(),
                    const SizedBox(height: 32),
                    const Text(
                      "Made with ❤️",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 64),
                    Center(
                      child: CupertinoButton(
                          color: CupertinoColors.white,
                          child: const Text(
                            "Review",
                            style: TextStyle(color: CupertinoColors.black),
                          ),
                          onPressed: () {
                            final InAppReview inAppReview =
                                InAppReview.instance;

                            inAppReview.openStoreListing(
                                appStoreId: '1367393128');
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText buildGithubLine() {
    return RichText(
      text: TextSpan(
        text: 'Get involved on ',
        style: const TextStyle(fontSize: 24, color: Colors.white),
        children: <TextSpan>[
          TextSpan(
              text: "Github",
              style: const TextStyle(color: CupertinoColors.systemBlue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (await canLaunchUrl(url)) {
                    FirebaseAnalytics.instance.logSelectContent(
                      contentType: "action",
                      itemId: "Visit Github repo",
                    );
                    await launchUrl(url);
                  } else {
                    if (kDebugMode) {
                      print("Cannot open url");
                    }
                  }
                }),
        ],
      ),
    );
  }
}
