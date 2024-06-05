// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveGameSessionHash() => r'0d3370f187118654b583f032b476e6737c9a6850';

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

String _$incrementCreditHash() => r'ba7d13e930cd79ba4116289f419dc2524026bf69';

/// See also [incrementCredit].
@ProviderFor(incrementCredit)
const incrementCreditProvider = IncrementCreditFamily();

/// See also [incrementCredit].
class IncrementCreditFamily extends Family<AsyncValue<void>> {
  /// See also [incrementCredit].
  const IncrementCreditFamily();

  /// See also [incrementCredit].
  IncrementCreditProvider call(
    PlayerDetails player, {
    bool isDown = true,
  }) {
    return IncrementCreditProvider(
      player,
      isDown: isDown,
    );
  }

  @override
  IncrementCreditProvider getProviderOverride(
    covariant IncrementCreditProvider provider,
  ) {
    return call(
      provider.player,
      isDown: provider.isDown,
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
  String? get name => r'incrementCreditProvider';
}

/// See also [incrementCredit].
class IncrementCreditProvider extends AutoDisposeFutureProvider<void> {
  /// See also [incrementCredit].
  IncrementCreditProvider(
    PlayerDetails player, {
    bool isDown = true,
  }) : this._internal(
          (ref) => incrementCredit(
            ref as IncrementCreditRef,
            player,
            isDown: isDown,
          ),
          from: incrementCreditProvider,
          name: r'incrementCreditProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$incrementCreditHash,
          dependencies: IncrementCreditFamily._dependencies,
          allTransitiveDependencies:
              IncrementCreditFamily._allTransitiveDependencies,
          player: player,
          isDown: isDown,
        );

  IncrementCreditProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.player,
    required this.isDown,
  }) : super.internal();

  final PlayerDetails player;
  final bool isDown;

  @override
  Override overrideWith(
    FutureOr<void> Function(IncrementCreditRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IncrementCreditProvider._internal(
        (ref) => create(ref as IncrementCreditRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        player: player,
        isDown: isDown,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _IncrementCreditProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncrementCreditProvider &&
        other.player == player &&
        other.isDown == isDown;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, player.hashCode);
    hash = _SystemHash.combine(hash, isDown.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IncrementCreditRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `player` of this provider.
  PlayerDetails get player;

  /// The parameter `isDown` of this provider.
  bool get isDown;
}

class _IncrementCreditProviderElement
    extends AutoDisposeFutureProviderElement<void> with IncrementCreditRef {
  _IncrementCreditProviderElement(super.provider);

  @override
  PlayerDetails get player => (origin as IncrementCreditProvider).player;
  @override
  bool get isDown => (origin as IncrementCreditProvider).isDown;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
