import 'package:flutter_test/flutter_test.dart';
import 'package:blood_donation/main.dart';

void main() {
  testWidgets('App Works', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
  });
}
