// Basic smoke test for the Projects app.
import 'package:flutter_test/flutter_test.dart';
import 'package:projects/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const ProjectsApp());
    // Verify the app title is shown
    expect(find.text('Projects'), findsOneWidget);
  });
}
