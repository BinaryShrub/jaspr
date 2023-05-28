import 'package:jaspr/components.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_test/jaspr_test.dart';

import 'utils.dart';

final counter = StateProvider((ref) => 0);

void main() {
  group('context.read', () {
    testComponents(
      'context.read returns provider state',
      (tester) async {
        await tester.pumpComponent(providerApp((context) sync* {
          yield Text('${context.read(counter)}');
        }));

        expect(find.text('0'), findsOneComponent);
        expect(find.text('1'), findsNothing);
      },
    );

    testComponents(
      'context.read returns overridden provider state',
      (tester) async {
        await tester.pumpComponent(providerApp((context) sync* {
          yield Text('a ${context.read(counter)}');
          yield ProviderScope(
            overrides: [counter.overrideWith((ref) => 1)],
            child: Builder(builder: (context) sync* {
              yield Text('b ${context.read(counter)}');
            }),
          );
        }));

        expect(find.text('a 0'), findsOneComponent);
        expect(find.text('b 1'), findsOneComponent);
      },
    );
  });
}
