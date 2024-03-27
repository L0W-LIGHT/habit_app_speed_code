// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannedPage extends StatelessWidget {
  final String qrCodeLink;

  const ScannedPage({Key? key, required this.qrCodeLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Scanned QR Code Link:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              qrCodeLink,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(qrCodeLink)) {
                  await launch(qrCodeLink);
                } else {
                  throw 'Could not launch $qrCodeLink';
                }
              },
              child: const Text('Open Link'),
            ),
          ],
        ),
      ),
    );
  }
}
