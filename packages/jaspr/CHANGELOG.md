## 0.5.0

- **BREAKING** Added `@client` as replacement for both `@app` and `@island`.

  Components annotated with `@client` act as entry points for the client application and are
  automatically detected, compiled and shipped to the client when using the `Document()` component.

  This combines the behaviour of the now removed `@app` and `@island` annotations, as well as the
  removed `Document.app()` and `Document.islands()` constructors. Use the default `Document()` constructor instead.
 
- **BREAKING** Removed `DeferRenderMixin` as async first builds are no longer permitted on clients.

- Added support for **Flutter element embedding**.

  Flutter apps can now easily be embedded within jaspr sites. The cli supports the `--flutter` argument for both
  the `serve` and `build` commands to specify the entrypoint of the flutter application.

  The complete setup is demonstrated in the [flutter_embedding](https://github.com/schultek/jaspr/tree/main/examples/flutter_embedding) 
  example.

- Fixed handling of initial uri.
- Added `SynchronousFuture`.

## 0.4.0

- **BREAKING** Bindings are no longer singletons. 
  - `ComponentsBinding.instance`, `SchedulerBinding.instance` etc. were removed.
  - You can access the current binding through `BuildContext`s `context.binding` property.

- **BREAKING** Removed `ComponentTester.setUp()`, `BrowserTester.setUp()` and `ServerTester.setUp()`.
  - Use `testComponents()`, `testBrowser()` and `testServer()` instead.

- Requires Dart 3.0 or later.

## 0.3.0

- **BREAKING** The cli is now a separate package: `jaspr_cli`. To migrate run:
  ```shell
    dart pub global deactivate jaspr
    dart pub global activate jaspr_cli
  ```
  The usage stays the same with `jaspr create`, `jaspr serve` and `jaspr build`.

## 0.2.0

**BREAKING**: This is the first major release after the initial publish and contains several breaking changes.

- Update to Dart 2.17
- Rewrite of the rendering system that comes with a lot of improvements in stability and performance.
- Added support for custom backend & server setup.
- Added support for multiple apps on the client as well as island components.
- Added html utility components for common elements.
- Added `Styles` class for writing typed css in dart.
- Various other improvements throughout the framework.

## 0.1.5

- Refactor cli code [#12](https://github.com/schultek/jaspr/pull/12)
- Fixed issue with `jaspr serve`

## 0.1.4

- Added `--port` option to `jaspr serve` ([#6](https://github.com/schultek/jaspr/issues/6))
- Fixed `webdev` dependency constraint ([#5](https://github.com/schultek/jaspr/issues/5))

## 0.1.3

- Fixed domino dependency ([#4](https://github.com/schultek/jaspr/pull/4))
- Fixed build on windows ([#3](https://github.com/schultek/jaspr/issues/3))

## 0.1.2

- Added executable to `pubspec.yaml` ([#2](https://github.com/schultek/jaspr/issues/2))

## 0.1.1

- Fixed template for `jaspr create` ([#1](https://github.com/schultek/jaspr/pull/1))

## 0.1.0

- Initial version
