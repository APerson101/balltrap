// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveGameSessionHash() => r'140f5b2c8105c261dd456ac77f3f082b52ec3abc';

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

/// See also [saveGameSession].
@ProviderFor(saveGameSession)
const saveGameSessionProvider = SaveGameSessionFamily();

/// See also [saveGameSession].
class SaveGameSessionFamily extends Family<AsyncValue<void>> {
  /// See also [saveGameSession].
  const SaveGameSessionFamily();

  /// See also [saveGameSession].
  SaveGameSessionProvider call(
    GameSession session,
  ) {
    return SaveGameSessionProvider(
      session,
    );
  }

  @override
  SaveGameSessionProvider getProviderOverride(
    covariant SaveGameSessionProvider provider,
  ) {
    return call(
      provider.session,
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
  String? get name => r'saveGameSessionProvider';
}

/// See also [saveGameSession].
class SaveGameSessionProvider extends AutoDisposeFutureProvider<void> {
  /// See also [saveGameSession].
  SaveGameSessionProvider(
    GameSession session,
  ) : this._internal(
          (ref) => saveGameSession(
            ref as SaveGameSessionRef,
            session,
          ),
          from: saveGameSessionProvider,
          name: r'saveGameSessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveGameSessionHash,
          dependencies: SaveGameSessionFamily._dependencies,
          allTransitiveDependencies:
              SaveGameSessionFamily._allTransitiveDependencies,
          session: session,
        );

  SaveGameSessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.session,
  }) : super.internal();

  final GameSession session;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveGameSessionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveGameSessionProvider._internal(
        (ref) => create(ref as SaveGameSessionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        session: session,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveGameSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveGameSessionProvider && other.session == session;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, session.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SaveGameSessionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `session` of this provider.
  GameSession get session;
}

class _SaveGameSessionProviderElement
    extends AutoDisposeFutureProviderElement<void> with SaveGameSessionRef {
  _SaveGameSessionProviderElement(super.provider);

  @override
  GameSession get session => (origin as SaveGameSessionProvider).session;
}

String _$setConfigurationHash() => r'30f8e6d1ec925f6cc0903ee1226e3f75fe85337e';

/// See also [setConfiguration].
@ProviderFor(setConfiguration)
const setConfigurationProvider = SetConfigurationFamily();

/// See also [setConfiguration].
class SetConfigurationFamily extends Family<AsyncValue<void>> {
  /// See also [setConfiguration].
  const SetConfigurationFamily();

  /// See also [setConfiguration].
  SetConfigurationProvider call(
    dynamic players,
  ) {
    return SetConfigurationProvider(
      players,
    );
  }

  @override
  SetConfigurationProvider getProviderOverride(
    covariant SetConfigurationProvider provider,
  ) {
    return call(
      provider.players,
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
  String? get name => r'setConfigurationProvider';
}

/// See also [setConfiguration].
class SetConfigurationProvider extends AutoDisposeFutureProvider<void> {
  /// See also [setConfiguration].
  SetConfigurationProvider(
    dynamic players,
  ) : this._internal(
          (ref) => setConfiguration(
            ref as SetConfigurationRef,
            players,
          ),
          from: setConfigurationProvider,
          name: r'setConfigurationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$setConfigurationHash,
          dependencies: SetConfigurationFamily._dependencies,
          allTransitiveDependencies:
              SetConfigurationFamily._allTransitiveDependencies,
          players: players,
        );

  SetConfigurationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.players,
  }) : super.internal();

  final dynamic players;

  @override
  Override overrideWith(
    FutureOr<void> Function(SetConfigurationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SetConfigurationProvider._internal(
        (ref) => create(ref as SetConfigurationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        players: players,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SetConfigurationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SetConfigurationProvider && other.players == players;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, players.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SetConfigurationRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `players` of this provider.
  dynamic get players;
}

class _SetConfigurationProviderElement
    extends AutoDisposeFutureProviderElement<void> with SetConfigurationRef {
  _SetConfigurationProviderElement(super.provider);

  @override
  dynamic get players => (origin as SetConfigurationProvider).players;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
