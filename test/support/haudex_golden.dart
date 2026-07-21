// HAUDEX golden-capture support (teacher-canonical, overlaid onto each clone).
//
// This is how a Flutter activity produces the mobile screenshot the AI design
// feedback looks at - the Flutter mirror of the web "render a preview" step.
// It is NOT a pixel-comparison test: the grade sweep runs `flutter test
// --update-goldens`, so `captureScreen` simply WRITES the PNG (it never fails
// on pixels). Behaviour is scored by the ordinary widget tests; this only
// captures the picture.
//
// Two details make the screenshot look real in headless CI:
//   1. A real font is loaded (without it, `flutter test` renders every glyph as
//      a black box). Roboto-Regular.ttf is bundled next to this file and mapped
//      onto the default family so Text renders normally.
//   2. The screen is wrapped in a `device_frame` phone bezel at a phone surface
//      size, so the capture is a believable mobile preview.
//
// Students never see this file; it is added to the clone by the grade sweep.
import 'dart:io';

import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The phone we simulate for every screenshot.
final DeviceInfo kHaudexDevice = Devices.ios.iPhone13;

/// Load the fonts once so Text (and icons) render as real glyphs, not boxes.
Future<void> loadHaudexFonts() async {
  // 1. Text: the bundled Roboto, mapped onto every family Material asks for.
  final bytes = File('test/support/Roboto-Regular.ttf').readAsBytesSync();
  for (final family in ['Roboto', 'packages/device_frame/Roboto']) {
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }

  // 2. Material icons: not bundled (the .otf is large), so we load it from the
  //    Flutter SDK if we can find it - both CI (subosito/flutter-action sets
  //    FLUTTER_ROOT) and a normal install ship it. Best-effort: if it is not
  //    found, icons render as boxes but text is unaffected.
  final root = Platform.environment['FLUTTER_ROOT'];
  final candidates = <String?>[
    if (root != null) '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    // Derive the SDK root from the running dart binary (.../flutter/bin/cache/dart-sdk/bin/dart).
    _deriveMaterialIconsPath(Platform.resolvedExecutable),
  ];
  for (final path in candidates) {
    if (path != null && File(path).existsSync()) {
      final iconBytes = File(path).readAsBytesSync();
      await (FontLoader('MaterialIcons')
            ..addFont(Future.value(ByteData.view(iconBytes.buffer))))
          .load();
      break;
    }
  }
}

String? _deriveMaterialIconsPath(String dartExe) {
  final marker = '/bin/cache/dart-sdk/';
  final i = dartExe.indexOf(marker);
  if (i < 0) return null;
  final flutterRoot = dartExe.substring(0, i);
  return '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
}

/// Render [screen] inside a phone frame and save it as `screenshots/<name>.png`.
///
/// Call this from a `testWidgets` whose description starts with `capture:` so
/// the grade sweep excludes it from the scored test count.
Future<void> captureScreen(
  WidgetTester tester,
  Widget screen, {
  required String name,
}) async {
  tester.view.physicalSize = const Size(1170, 2532); // iPhone-ish @ dpr 3
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: DeviceFrame(device: kHaudexDevice, screen: screen),
    ),
  );
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(DeviceFrame),
    matchesGoldenFile('screenshots/$name.png'),
  );
}
