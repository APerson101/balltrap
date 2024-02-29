// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allSessionsFakeHash() => r'af21ae4f5fcf12d2275ef875006792d86c56c6bd';

/// See also [allSessionsFake].
@ProviderFor(allSessionsFake)
final allSessionsFakeProvider =
    AutoDisposeFutureProvider<List<GameSession>>.internal(
  allSessionsFake,
  name: r'allSessionsFakeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allSessionsFakeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllSessionsFakeRef = AutoDisposeFutureProviderRef<List<GameSession>>;
String _$allSessionsHash() => r'361dcfd6234c5de55760a959e89df79d9ddf76ae';

/// See also [allSessions].
@ProviderFor(allSessions)
final allSessionsProvider =
    AutoDisposeFutureProvider<List<GameSession>>.internal(
  allSessions,
  name: r'allSessionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allSessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllSessionsRef = AutoDisposeFutureProviderRef<List<GameSession>>;
String _$addGameSessionHash() => r'd37b55def276b0f649f60dc3cf8422394167a2ae';

/// See also [addGameSession].
@ProviderFor(addGameSession)
final addGameSessionProvider = AutoDisposeFutureProvider<Object?>.internal(
  addGameSession,
  name: r'addGameSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addGameSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddGameSessionRef = AutoDisposeFutureProviderRef<Object?>;
String _$addTemplateHash() => r'a41d4eecee57e366eaed9f60a55aabe5f3d74d5d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [addTemplate].
@ProviderFor(addTemplate)
const addTemplateProvider = AddTemplateFamily();

/// See also [addTemplate].
class AddTemplateFamily extends Family<AsyncValue<bool>> {
  /// See also [addTemplate].
  const AddTemplateFamily();

  /// See also [addTemplate].
  AddTemplateProvider call(
    GameTemplate template,
  ) {
    return AddTemplateProvider(
      template,
    );
  }

  @override
  AddTemplateProvider getProviderOverride(
    covariant AddTemplateProvider provider,
  ) {
    return call(
      provider.template,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addTemplateProvider';
}

/// See also [addTemplate].
class AddTemplateProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [addTemplate].
  AddTemplateProvider(
    GameTemplate template,
  ) : this._internal(
          (ref) => addTemplate(
            ref as AddTemplateRef,
            template,
          ),
          from: addTemplateProvider,
          name: r'addTemplateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addTemplateHash,
          dependencies: AddTemplateFamily._dependencies,
          allTransitiveDependencies:
              AddTemplateFamily._allTransitiveDependencies,
          template: template,
        );

  AddTemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.template,
  }) : super.internal();

  final GameTemplate template;

  @override
  Override overrideWith(
    FutureOr<bool> Function(AddTemplateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddTemplateProvider._internal(
        (ref) => create(ref as AddTemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        template: template,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _AddTemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddTemplateProvider && other.template == template;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, template.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddTemplateRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `template` of this provider.
  GameTemplate get template;
}

class _AddTemplateProviderElement extends AutoDisposeFutureProviderElement<bool>
    with AddTemplateRef {
  _AddTemplateProviderElement(super.provider);

  @override
  GameTemplate get template => (origin as AddTemplateProvider).template;
}

String _$removeTemplateHash() => r'b72d1c7d4210a265a40767d9a54ee6eb45ac0af5';

/// See also [removeTemplate].
@ProviderFor(removeTemplate)
const removeTemplateProvider = RemoveTemplateFamily();

/// See also [removeTemplate].
class RemoveTemplateFamily extends Family<AsyncValue<bool>> {
  /// See also [removeTemplate].
  const RemoveTemplateFamily();

  /// See also [removeTemplate].
  RemoveTemplateProvider call(
    GameTemplate template,
  ) {
    return RemoveTemplateProvider(
      template,
    );
  }

  @override
  RemoveTemplateProvider getProviderOverride(
    covariant RemoveTemplateProvider provider,
  ) {
    return call(
      provider.template,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'removeTemplateProvider';
}

/// See also [removeTemplate].
class RemoveTemplateProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [removeTemplate].
  RemoveTemplateProvider(
    GameTemplate template,
  ) : this._internal(
          (ref) => removeTemplate(
            ref as RemoveTemplateRef,
            template,
          ),
          from: removeTemplateProvider,
          name: r'removeTemplateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$removeTemplateHash,
          dependencies: RemoveTemplateFamily._dependencies,
          allTransitiveDependencies:
              RemoveTemplateFamily._allTransitiveDependencies,
          template: template,
        );

  RemoveTemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.template,
  }) : super.internal();

  final GameTemplate template;

  @override
  Override overrideWith(
    FutureOr<bool> Function(RemoveTemplateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoveTemplateProvider._internal(
        (ref) => create(ref as RemoveTemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        template: template,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _RemoveTemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoveTemplateProvider && other.template == template;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, template.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoveTemplateRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `template` of this provider.
  GameTemplate get template;
}

class _RemoveTemplateProviderElement
    extends AutoDisposeFutureProviderElement<bool> with RemoveTemplateRef {
  _RemoveTemplateProviderElement(super.provider);

  @override
  GameTemplate get template => (origin as RemoveTemplateProvider).template;
}

String _$getAllTemplatesHash() => r'a1953f8439329fd5a3c28e29fdc4e6b5cb25bcc4';

/// See also [getAllTemplates].
@ProviderFor(getAllTemplates)
final getAllTemplatesProvider =
    AutoDisposeFutureProvider<List<GameTemplate>>.internal(
  getAllTemplates,
  name: r'getAllTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllTemplatesRef = AutoDisposeFutureProviderRef<List<GameTemplate>>;
String _$getSQLConnectionHash() => r'963fed51c006c91893b905772df3df955c8a6004';

/// See also [getSQLConnection].
@ProviderFor(getSQLConnection)
final getSQLConnectionProvider =
    AutoDisposeFutureProvider<MySQLConnection>.internal(
  getSQLConnection,
  name: r'getSQLConnectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSQLConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSQLConnectionRef = AutoDisposeFutureProviderRef<MySQLConnection>;
String _$saveSQLIpAddressHash() => r'0e76633583b7f1b078ab0cf6a35086ae405aaa9d';

/// See also [saveSQLIpAddress].
@ProviderFor(saveSQLIpAddress)
const saveSQLIpAddressProvider = SaveSQLIpAddressFamily();

/// See also [saveSQLIpAddress].
class SaveSQLIpAddressFamily extends Family<AsyncValue<bool>> {
  /// See also [saveSQLIpAddress].
  const SaveSQLIpAddressFamily();

  /// See also [saveSQLIpAddress].
  SaveSQLIpAddressProvider call(
    String ip,
    int port,
  ) {
    return SaveSQLIpAddressProvider(
      ip,
      port,
    );
  }

  @override
  SaveSQLIpAddressProvider getProviderOverride(
    covariant SaveSQLIpAddressProvider provider,
  ) {
    return call(
      provider.ip,
      provider.port,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveSQLIpAddressProvider';
}

/// See also [saveSQLIpAddress].
class SaveSQLIpAddressProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [saveSQLIpAddress].
  SaveSQLIpAddressProvider(
    String ip,
    int port,
  ) : this._internal(
          (ref) => saveSQLIpAddress(
            ref as SaveSQLIpAddressRef,
            ip,
            port,
          ),
          from: saveSQLIpAddressProvider,
          name: r'saveSQLIpAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveSQLIpAddressHash,
          dependencies: SaveSQLIpAddressFamily._dependencies,
          allTransitiveDependencies:
              SaveSQLIpAddressFamily._allTransitiveDependencies,
          ip: ip,
          port: port,
        );

  SaveSQLIpAddressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ip,
    required this.port,
  }) : super.internal();

  final String ip;
  final int port;

  @override
  Override overrideWith(
    FutureOr<bool> Function(SaveSQLIpAddressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveSQLIpAddressProvider._internal(
        (ref) => create(ref as SaveSQLIpAddressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ip: ip,
        port: port,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _SaveSQLIpAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveSQLIpAddressProvider &&
        other.ip == ip &&
        other.port == port;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ip.hashCode);
    hash = _SystemHash.combine(hash, port.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SaveSQLIpAddressRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `ip` of this provider.
  String get ip;

  /// The parameter `port` of this provider.
  int get port;
}

class _SaveSQLIpAddressProviderElement
    extends AutoDisposeFutureProviderElement<bool> with SaveSQLIpAddressRef {
  _SaveSQLIpAddressProviderElement(super.provider);

  @override
  String get ip => (origin as SaveSQLIpAddressProvider).ip;
  @override
  int get port => (origin as SaveSQLIpAddressProvider).port;
}

String _$getIpAddressHash() => r'1accda5391f3095d88c20ec5bee83b0a75014dac';

/// See also [getIpAddress].
@ProviderFor(getIpAddress)
final getIpAddressProvider = AutoDisposeFutureProvider<String?>.internal(
  getIpAddress,
  name: r'getIpAddressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getIpAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetIpAddressRef = AutoDisposeFutureProviderRef<String?>;
String _$getIpPortHash() => r'b8c201b9976040aca71b49dbb61e6b02a7dd791d';

/// See also [getIpPort].
@ProviderFor(getIpPort)
final getIpPortProvider = AutoDisposeFutureProvider<int?>.internal(
  getIpPort,
  name: r'getIpPortProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getIpPortHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetIpPortRef = AutoDisposeFutureProviderRef<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
