import 'package:build/build.dart';

import 'src/client/client_module_builder.dart';
import 'src/client/client_part_builder.dart';
import 'src/client/client_registry_builder.dart';
import 'src/imports/analyzing_builder.dart';
import 'src/imports/imports_builder.dart';
import 'src/imports/stubs_builder.dart';

Builder buildClientModule(BuilderOptions options) => ClientModuleBuilder(options);
Builder buildClientPart(BuilderOptions options) => ClientPartBuilder(options);
Builder buildClientRegistry(BuilderOptions options) => ClientRegistryBuilder(options);

Builder findPlatformImports(BuilderOptions options) => ImportsAnalyzingBuilder(options);
Builder writePlatformImports(BuilderOptions options) => ImportsOutputBuilder(options);
Builder buildPlatformStubs(BuilderOptions options) => ImportsStubsBuilder(options);
