import 'package:flutter_test/flutter_test.dart';
import 'package:fabric_inspector/main.dart';

void main() {
  testWidgets('home screen shows the app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const FabricInspectorApp());

    expect(find.text('Kumaş Delik Tespiti'), findsOneWidget);
  });
}
