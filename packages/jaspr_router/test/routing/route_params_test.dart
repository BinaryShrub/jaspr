import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_test/jaspr_test.dart';

import '../utils.dart';

void main() {
  group('router', () {
    setUpAll(() {
      mockHistory();
    });

    testComponents('should resolve route params', (tester) async {
      await tester.pumpComponent(Router(routes: [
        homeRoute(),
        route('/a/:aId'),
      ]));

      expect(find.text('home'), findsOneComponent);

      await tester.router.push('/a/123');
      await pumpEventQueue();

      expect(find.text('a/123'), findsOneComponent);
      expect(find.text('aId=123'), findsOneComponent);

      await tester.router.push('/a/hello');
      await pumpEventQueue();

      expect(find.text('a/hello'), findsOneComponent);
      expect(find.text('aId=hello'), findsOneComponent);

      tester.router.back();
      await pumpEventQueue();

      expect(find.text('a/123'), findsOneComponent);
      expect(find.text('aId=123'), findsOneComponent);
    });
  });
}
