// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/src/all_elements.dart' as a_e;

import 'package:reactiontester/main.dart' as main_func;
import 'package:reactiontester/keys.dart' as keys;
import 'package:reactiontester/main/main_offline.dart' as main_offline;
import 'package:reactiontester/main/main_online.dart' as main_online;
import 'package:reactiontester/games/colour_reflexes.dart' as colour_reflexes;
import 'package:reactiontester/games/text_reflexes.dart' as text_reflexes;

void main() {
  testWidgets(
    'Does Main Online UI Load (Text)',
    (WidgetTester tester) async {
      int cAvgTest = 6713199; // "foo" to hex to decimal
      int tAvgTest = 6447474; // "bar" to hex to decimal
      await tester.pumpWidget(
        const MaterialApp(
          home: main_online.MainOnline(
            isTest: true,
            isLast: true,
          ),
        ),
      );

      List<String> expectedWidgets = [
        'ReactionTester',
        'Colour Matching',
        'How fast can you\r\nlink colours together ?',
        'Psst. You can swipe to get more info ->',
        'How do I play this game ?',
        'You will be given one colour \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
        'Font Matching',
        'How fast can you\r\nreunite fonts together ?',
        'Psst. You can swipe to get more info ->',
        'How do I play this game ?',
        'You will be given one sentence \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
        'About this app',
        'About this app\'s developper',
      ];
      for (String expectedText in expectedWidgets) {
        expectLater(
          find.text(
            expectedText,
            findRichText: true,
            skipOffstage: false,
          ),
          findsWidgets,
        );
      }
    },
  );

  testWidgets(
    'Does Main Offline UI Load (Text)',
    (WidgetTester tester) async {
      int cAvgTest = 6713199; // "foo" to hex to decimal
      int tAvgTest = 6447474; // "bar" to hex to decimal
      await tester.pumpWidget(
        const MaterialApp(
          home: main_offline.MainOffline(
            isTest: true,
          ),
        ),
      );

      List<String> expectedWidgets = [
        'ReactionTester',
        'Colour Matching',
        'How fast can you\r\nlink colours together ?',
        'Psst. You can swipe to get more info ->',
        'How do I play this game ?',
        'You will be given one colour \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
        'Font Matching',
        'How fast can you\r\nreunite fonts together ?',
        'Psst. You can swipe to get more info ->',
        'How do I play this game ?',
        'You will be given one sentence \r\n You will have three buttons to choose from \r\n Be quick though ! Your reaction time is measured',
        'About this app',
        'About this app\'s developper',
      ];
      for (String expectedText in expectedWidgets) {
        expectLater(
          find.text(
            expectedText,
            findRichText: true,
            skipOffstage: false,
          ),
          findsWidgets,
        );
      }
    },
  );

  testWidgets(
    'Does Colour Matching UI Load (Buttons)',
    (WidgetTester tester) async {
      int cAvgTest = 6713199; // "foo" to hex to decimal
      int tAvgTest = 6447474; // "bar" to hex to decimal
      await tester.pumpWidget(
        const MaterialApp(
          home: colour_reflexes.colourReflexes(),
        ),
      );

      List<Type> expectedWidgets = [
        FloatingActionButton,
        FloatingActionButton,
        FloatingActionButton,
        IconButton,
      ];
      List<IconData> expectedIcons = [
        Icons.add,
        Icons.add,
        Icons.add,
        Icons.monochrome_photos,
      ];

      for (var i = 0; i < expectedWidgets.length; i++) {
        expectLater(
          find.widgetWithIcon(
            expectedWidgets[i],
            expectedIcons[i],
          ),
          findsWidgets,
        );
      }
    },
  );

  testWidgets(
    'Does Colour Matching UI Load (Tooltips)',
    (WidgetTester tester) async {
      int cAvgTest = 6713199; // "foo" to hex to decimal
      int tAvgTest = 6447474; // "bar" to hex to decimal
      await tester.pumpWidget(
        const MaterialApp(
          home: colour_reflexes.colourReflexes(),
        ),
      );

      List<String> expectedWidgets = [
        'Button 1',
        'Button 2',
        'Button 3',
        'Toggle b/w',
      ];
      for (String expectedTooltips in expectedWidgets) {
        expectLater(
          find.byTooltip(
            expectedTooltips,
            skipOffstage: false,
          ),
          findsWidgets,
        );
      }
    },
  );

  testWidgets(
    'Does Font Matching UI Load (Text)',
    (WidgetTester tester) async {
      int cAvgTest = 6713199; // "foo" to hex to decimal
      int tAvgTest = 6447474; // "bar" to hex to decimal
      await tester.pumpWidget(
        const MaterialApp(
          home: text_reflexes.textReflexes(),
        ),
      );

      List<String> expectedWidgets = [
        'The quick brown',
        'fox jumps over',
        'the lazy dog',
      ];
      for (String expectedText in expectedWidgets) {
        expectLater(
          find.text(
            expectedText,
            findRichText: true,
            skipOffstage: false,
          ),
          findsWidgets,
        );
      }
    },
  );

  testWidgets(
    'Does Font Matching UI Load (Buttons)',
    (WidgetTester tester) async {
      int cAvgTest = 6713199; // "foo" to hex to decimal
      int tAvgTest = 6447474; // "bar" to hex to decimal
      await tester.pumpWidget(
        const MaterialApp(
          home: text_reflexes.textReflexes(),
        ),
      );

      expectLater(
        find.widgetWithText(FloatingActionButton, 'T'),
        findsNWidgets(3),
      );
    },
  );
}
