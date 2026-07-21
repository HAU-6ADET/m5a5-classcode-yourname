// m5a5 - screenshot capture (teacher-canonical, NOT scored).
import 'package:flutter_test/flutter_test.dart';

import 'package:m5a5_haudex_app/dex_app.dart';

import 'support/haudex_golden.dart';

void main() {
  setUpAll(loadHaudexFonts);

  testWidgets('capture: haudex home', (tester) async {
    await captureScreen(tester, const DexApp(), name: 'app');
  });
}
