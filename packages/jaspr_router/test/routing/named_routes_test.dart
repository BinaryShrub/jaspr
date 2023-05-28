import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_test/jaspr_test.dart';

import '../utils.dart';

void main() {
  group('router', () {
    setUpAll(() {
      mockHistory();
    });

    testComponents('should push named route', (tester) async {
      await tester.pumpComponent(Router(routes: [
        homeRoute(),
        route('/a', [], 'alicia'),
        route('/b', [], 'bob'),
      ]));

      expect(find.text('home'), findsOneComponent);

      await tester.router.pushNamed('alicia');
      await pumpEventQueue();

      expect(find.text('a'), findsOneComponent);

      await tester.router.pushNamed('bob');
      await pumpEventQueue();

      expect(find.text('b'), findsOneComponent);

      tester.router.back();
      await pumpEventQueue();

      expect(find.text('a'), findsOneComponent);
    });

    testComponents('should replace named route', (tester) async {
      await tester.pumpComponent(Router(routes: [
        homeRoute(),
        route('/a', [], 'alicia'),
        route('/b', [], 'bob'),
      ]));

      expect(find.text('home'), findsOneComponent);

      await tester.router.pushNamed('alicia');
      await pumpEventQueue();

      expect(find.text('a'), findsOneComponent);

      await tester.router.replaceNamed('bob');
      await pumpEventQueue();

      expect(find.text('b'), findsOneComponent);

      tester.router.back();
      await pumpEventQueue();

      expect(find.text('home'), findsOneComponent);
    });
  });
}
