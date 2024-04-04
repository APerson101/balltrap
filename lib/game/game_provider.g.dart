// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveGameSessionHash() => r'a4ab2a6e653039857e5922cec235740e76ea0d0d';

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
    List<String> ids,
    List<PlayerDetails> players,
  ) {
    return SaveGameSessionProvider(
      session,
      ids,
      players,
    );
  }

  @override
  SaveGameSessionProvider getProviderOverride(
    covariant SaveGameSessionProvider provider,
  ) {
    return call(
      provider.session,
      provider.ids,
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
  String? get name => r'saveGameSessionProvider';
}

/// See also [saveGameSession].
class SaveGameSessionProvider extends AutoDisposeFutureProvider<void> {
  /// See also [saveGameSession].
  SaveGameSessionProvider(
    GameSession session,
    List<String> ids,
    List<PlayerDetails> players,
  ) : this._internal(
          (ref) => saveGameSession(
            ref as SaveGameSessionRef,
            session,
            ids,
            players,
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
          ids: ids,
          players: players,
        );

  SaveGameSessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.session,
    required this.ids,
    required this.players,
  }) : super.internal();

  final GameSession session;
  final List<String> ids;
  final List<PlayerDetails> players;

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
        ids: ids,
        players: players,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveGameSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveGameSessionProvider &&
        other.session == session &&
        other.ids == ids &&
        other.players == players;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, session.hashCode);
    hash = _SystemHash.combine(hash, ids.hashCode);
    hash = _SystemHash.combine(hash, players.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SaveGameSessionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `session` of this provider.
  GameSession get session;

  /// The parameter `ids` of this provider.
  List<String> get ids;

  /// The parameter `players` of this provider.
  List<PlayerDetails> get players;
}

class _SaveGameSessionProviderElement
    extends AutoDisposeFutureProviderElement<void> with SaveGameSessionRef {
  _SaveGameSessionProviderElement(super.provider);

  @override
  GameSession get session => (origin as SaveGameSessionProvider).session;
  @override
  List<String> get ids => (origin as SaveGameSessionProvider).ids;
  @override
  List<PlayerDetails> get players =>
      (origin as SaveGameSessionProvider).players;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
