import 'dart:async';

import 'package:async/async.dart' show Result;
import 'package:jaspr/components.dart';
import 'package:jaspr_test/jaspr_test.dart';
import 'package:mobx_hooks_experiment/mobx_hooks/hooks.dart';
import 'package:mobx_hooks_experiment/mobx_hooks/jaspr_observer.dart';
import 'package:mobx_hooks_experiment/mobx_hooks/mobx_hooks.dart';

void main() {
  group('mobx hooks', () {
    Completer<bool> completer = Completer<bool>();
    final List<Result<int?>> streamValues = [];
    final List<int?> valueChanged = [];
    final List<bool> isEvenAutorunList = [];
    final List<Result<bool>> futureValues = [];
    Object? equalsArg;

    void clearLists() {
      valueChanged.clear();
      isEvenAutorunList.clear();
      streamValues.clear();
      futureValues.clear();
    }

    setUp(() {
      completer = Completer<bool>();
      clearLists();
      equalsArg = null;
    });

    late Obs<int> obs;
    // ignore: unused_local_variable
    late Obs<bool> obs2;
    late StreamController<int> streamController;

    Future<void> executeChecks({ComponentTester? tester}) async {
      Future<void> wait() {
        return tester?.pump() ?? Future.delayed(Duration.zero);
      }

      expect(valueChanged, [null]);
      expect(equalsArg, null);
      expect(isEvenAutorunList, [true]);
      expect(streamValues, [Result.value(0)]);
      expect(futureValues, [Result.value(false)]);
      clearLists();

      obs.value = 2;
      await wait();
      expect(valueChanged, [2]);
      expect(equalsArg, true);
      expect(isEvenAutorunList, [true]);
      expect(streamValues, [Result.value(0)]);
      expect(futureValues, []);
      clearLists();

      streamController.add(3);
      await wait();
      expect(valueChanged, []);
      expect(equalsArg, true);
      expect(isEvenAutorunList, []);
      expect(streamValues, [Result.value(3)]);
      expect(futureValues, []);
      clearLists();

      completer.complete(true);
      obs.value = 3;
      await wait();
      expect(valueChanged, [4]);
      expect(equalsArg, false);
      expect(isEvenAutorunList, [false]);
      expect(streamValues, [Result.value(3)]);
      expect(futureValues, [Result.value(true)]);
      clearLists();
    }

    void flow1() {
      obs = useObs(() => 0);
      final int? previous = usePrevious(obs.value);
      final result = useValueChanged<int, int?>(obs.value, (value, result) {
        expect(previous, value);
        return value + (result ?? obs.value);
      });
      valueChanged.add(result);

      final isEvenMemo = useMemo(() => obs.value % 2 == 0, [obs.value]);
      final isEven = useComputed(() => obs.value % 2 == 0, equals: (a, b) {
        equalsArg = b;
        return a == b;
      });
      expect(isEvenMemo, isEven);
      useAutorun(() {
        isEvenAutorunList.add(obs.value % 2 == 0);
        return null;
      });
    }

    void flow2() {
      streamController = useMemo(() => StreamController<int>());
      useEffect(() => streamController.close, const []);

      final value = useStream<int>(
        streamController.stream,
        initialValue: () => 0,
      );
      streamValues.add(value);
    }

    void flow3() {
      obs2 = useObs(() => true);
      final fut = useFuture(completer.future, initialValue: () => false);
      futureValues.add(fut);

      final isMounted = useIsMounted();
      final previousCallback = usePrevious(isMounted);
      if (previousCallback != null) {
        expect(previousCallback, isMounted);
      }
    }

    test('pure Dart context', () async {
      void hookContext(void Function() func, {HookCtx? rootCtx}) {
        bool scheduled = false;
        late final void Function() _inner;
        void rebuild() {
          if (scheduled) return;
          scheduled = true;
          Future.microtask(_inner);
        }

        final ctx = rootCtx ?? useRef(() => HookCtx(rebuild)).value;
        _inner = () {
          scheduled = false;
          ctx.startTracking();
          func();
          ctx.endTracking();
        };
        _inner();
      }

      final ctx = HookCtx(() {
        throw 'Should not rebuild Root HookCtx';
      });

      hookContext(rootCtx: ctx, () {
        hookContext(() {
          flow1();

          hookContext(flow2);
        });

        hookContext(flow3);
      });

      await executeChecks();
    });

    group('jaspr context', () {
      //   test('App', () async {
      //     await tester.pumpComponent(MobXHooksObserverComponent(child: App()));
      //   });

      testComponents('custom flow', (tester) async {
        await tester.pumpComponent(
          MobXHooksObserverComponent(
            child: Builder(
              builder: (context) sync* {
                yield Builder(
                  builder: (context) sync* {
                    flow1();
                    yield Builder(builder: (context) sync* {
                      flow2();
                      final last = streamValues.last;
                      yield DomComponent(
                        tag: 'div',
                        child: Text('Leaf2 ${last.asValue?.value}'),
                      );
                    });
                  },
                );

                yield Builder(
                  builder: (context) sync* {
                    flow3();
                    final last = futureValues.last;
                    yield DomComponent(
                      tag: 'div',
                      child: Text(
                        'Leaf3 ${last.asValue?.value}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );

        await executeChecks(tester: tester);
      });
    });
  });
}
