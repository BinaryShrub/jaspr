part of framework;

/// Main app binding, controls the root component and global state
mixin ComponentsBinding on BindingBase {
  /// The currently active uri.
  /// On the server, this is the requested uri. On the client, this is the
  /// currently visited uri in the browser.
  Uri get currentUri;

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  static ComponentsBinding? _instance;
  static ComponentsBinding? get instance => _instance;

  /// Whether the current app is run on the client (in the browser)
  bool get isClient;

  /// Sets [app] as the new root of the component tree and performs an initial build
  Future<void> attachRootComponent(Component app, {required String attachTo}) async {
    var buildOwner = _rootElements[attachTo]?._owner ?? BuildOwner();
    return buildOwner.lockState(() async {
      buildOwner._isFirstBuild = true;

      var builder = attachBuilder(attachTo);

      var element = _Root(child: app, builder: builder).createElement();
      element._owner = buildOwner;

      element.mount(null, null);

      if (element._asyncFirstBuild != null) {
        await element._asyncFirstBuild;
      }

      _rootElements[attachTo] = element;
      buildOwner._isFirstBuild = false;

      didAttachRootElement(element, to: attachTo);
    });
  }

  @protected
  void didAttachRootElement(Element element, {required String to});

  /// The [Element] that is at the root of the hierarchy.
  ///
  /// This is initialized the first time [runApp] is called.
  Map<String, DomNode> get rootElements => _rootElements;
  final Map<String, DomNode> _rootElements = {};

  DomBuilder attachBuilder(String to);

  final Map<GlobalKey, Element> _globalKeyRegistry = {};

  void _registerGlobalKey(GlobalKey key, Element element) {
    _globalKeyRegistry[key] = element;
  }

  void _unregisterGlobalKey(GlobalKey key, Element element) {
    if (_globalKeyRegistry[key] == element) {
      _globalKeyRegistry.remove(key);
    }
  }
}

class _Root extends Component {
  _Root({required this.child, required this.builder});

  final Component child;
  final DomBuilder builder;

  @override
  _RootElement createElement() => _RootElement(this);
}

class _RootElement extends SingleChildElement with DomNode {
  _RootElement(_Root component) : super(component);

  @override
  _Root get component => super.component as _Root;

  @override
  DomBuilder get builder => component.builder;

  @override
  void _firstBuild() {
    mountNode();
    super._firstBuild();
  }

  @override
  Component build() => InheritedDomBuilder(builder: builder, child: component.child);

  @override
  void renderNode(DomBuilder builder) {
    builder.setRootNode(this);
  }
}
