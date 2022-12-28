import 'package:datz_flutter/consts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  CreditsPage({super.key});

  final Uri url = Uri.parse('https://github.com/Krecharles/Datz');

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
            child: Column(
              children: [
                const Text(
                  "If you find a bug, your class is missing, a subject has the wrong coefficient or if you have an improvement idea, feel free to open an issue on GitHub. I will try my best to solve your problems. ",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 64),
                RichText(
                  text: TextSpan(
                    text: 'Get involved on ',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Github",
                          style: const TextStyle(
                              color: CupertinoColors.systemBlue),
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
                ),
                const SizedBox(height: 32),
                const Text(
                  "Made with ❤️",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
