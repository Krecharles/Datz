import 'package:datz_flutter/consts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        middle: Text(
          AppLocalizations.of(context)!.credits,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      child: Container(
        decoration: CustomDecorations.primaryGradientDecoration(context),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
                child: Center(
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      children: [
                        buildGithubLine(),
                        const SizedBox(height: 96),
                        Text(
                          AppLocalizations.of(context)!.reviewIncentive,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: CupertinoButton(
                              color: CupertinoColors.white,
                              child: Text(
                                AppLocalizations.of(context)!.review,
                                style: const TextStyle(
                                    color: CupertinoColors.black),
                              ),
                              onPressed: () {
                                FirebaseAnalytics.instance.logEvent(
                                  name: "PressReviewButton",
                                );

                                final InAppReview inAppReview =
                                    InAppReview.instance;

                                inAppReview.openStoreListing(
                                    appStoreId: '1367393128');
                              }),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          AppLocalizations.of(context)!.madeWithLove,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
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
        text: AppLocalizations.of(context)!.creditsBigTextPreGH,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        children: <TextSpan>[
          TextSpan(
              text: "Github",
              style: const TextStyle(color: CupertinoColors.systemBlue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (await canLaunchUrl(url)) {
                    FirebaseAnalytics.instance.logEvent(
                      name: "PressVisitGHButton",
                    );
                    await launchUrl(url);
                  } else {
                    if (kDebugMode) {
                      print("Cannot open url");
                    }
                  }
                }),
          TextSpan(text: AppLocalizations.of(context)!.creditsBigTextPostGH),
        ],
      ),
    );
  }
}
