// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allSessionsFakeHash() => r'bd3263da3a0577377f84dfadf82cbbdc6bd43f99';

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
String _$playerSearchHash() => r'c0435d0975096b07d94078fbe2200fe2204644c5';

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

/// See also [playerSearch].
@ProviderFor(playerSearch)
const playerSearchProvider = PlayerSearchFamily();

/// See also [playerSearch].
class PlayerSearchFamily extends Family<AsyncValue<List<PlayerDetails>>> {
  /// See also [playerSearch].
  const PlayerSearchFamily();

  /// See also [playerSearch].
  PlayerSearchProvider call(
    String playerName,
  ) {
    return PlayerSearchProvider(
      playerName,
    );
  }

  @override
  PlayerSearchProvider getProviderOverride(
    covariant PlayerSearchProvider provider,
  ) {
    return call(
      provider.playerName,
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
  String? get name => r'playerSearchProvider';
}

/// See also [playerSearch].
class PlayerSearchProvider
    extends AutoDisposeFutureProvider<List<PlayerDetails>> {
  /// See also [playerSearch].
  PlayerSearchProvider(
    String playerName,
  ) : this._internal(
          (ref) => playerSearch(
            ref as PlayerSearchRef,
            playerName,
          ),
          from: playerSearchProvider,
          name: r'playerSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playerSearchHash,
          dependencies: PlayerSearchFamily._dependencies,
          allTransitiveDependencies:
              PlayerSearchFamily._allTransitiveDependencies,
          playerName: playerName,
        );

  PlayerSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playerName,
  }) : super.internal();

  final String playerName;

  @override
  Override overrideWith(
    FutureOr<List<PlayerDetails>> Function(PlayerSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerSearchProvider._internal(
        (ref) => create(ref as PlayerSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playerName: playerName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PlayerDetails>> createElement() {
    return _PlayerSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerSearchProvider && other.playerName == playerName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playerName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlayerSearchRef on AutoDisposeFutureProviderRef<List<PlayerDetails>> {
  /// The parameter `playerName` of this provider.
  String get playerName;
}

class _PlayerSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<PlayerDetails>>
    with PlayerSearchRef {
  _PlayerSearchProviderElement(super.provider);

  @override
  String get playerName => (origin as PlayerSearchProvider).playerName;
}

String _$addGameSessionHash() => r'ab50e89fd55ed8ec73eca8b1bf1e001537268f95';

/// See also [addGameSession].
@ProviderFor(addGameSession)
const addGameSessionProvider = AddGameSessionFamily();

/// See also [addGameSession].
class AddGameSessionFamily extends Family<AsyncValue> {
  /// See also [addGameSession].
  const AddGameSessionFamily();

  /// See also [addGameSession].
  AddGameSessionProvider call(
    GameSession session,
  ) {
    return AddGameSessionProvider(
      session,
    );
  }

  @override
  AddGameSessionProvider getProviderOverride(
    covariant AddGameSessionProvider provider,
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
  String? get name => r'addGameSessionProvider';
}

/// See also [addGameSession].
class AddGameSessionProvider extends AutoDisposeFutureProvider<Object?> {
  /// See also [addGameSession].
  AddGameSessionProvider(
    GameSession session,
  ) : this._internal(
          (ref) => addGameSession(
            ref as AddGameSessionRef,
            session,
          ),
          from: addGameSessionProvider,
          name: r'addGameSessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addGameSessionHash,
          dependencies: AddGameSessionFamily._dependencies,
          allTransitiveDependencies:
              AddGameSessionFamily._allTransitiveDependencies,
          session: session,
        );

  AddGameSessionProvider._internal(
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
    FutureOr<Object?> Function(AddGameSessionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddGameSessionProvider._internal(
        (ref) => create(ref as AddGameSessionRef),
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
  AutoDisposeFutureProviderElement<Object?> createElement() {
    return _AddGameSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddGameSessionProvider && other.session == session;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, session.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddGameSessionRef on AutoDisposeFutureProviderRef<Object?> {
  /// The parameter `session` of this provider.
  GameSession get session;
}

class _AddGameSessionProviderElement
    extends AutoDisposeFutureProviderElement<Object?> with AddGameSessionRef {
  _AddGameSessionProviderElement(super.provider);

  @override
  GameSession get session => (origin as AddGameSessionProvider).session;
}

String _$addTemplateHash() => r'a41d4eecee57e366eaed9f60a55aabe5f3d74d5d';

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

String _$getAllPlayersHash() => r'bdb8c6cdec1c744e4e94efb9164dda8c923c35f4';

/// See also [getAllPlayers].
@ProviderFor(getAllPlayers)
final getAllPlayersProvider =
    AutoDisposeFutureProvider<List<PlayerDetails>>.internal(
  getAllPlayers,
  name: r'getAllPlayersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllPlayersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllPlayersRef = AutoDisposeFutureProviderRef<List<PlayerDetails>>;
String _$deletePlayerHash() => r'937513dfc857a7e505d074b52623f6cae7bf894e';

/// See also [deletePlayer].
@ProviderFor(deletePlayer)
const deletePlayerProvider = DeletePlayerFamily();

/// See also [deletePlayer].
class DeletePlayerFamily extends Family<AsyncValue<bool>> {
  /// See also [deletePlayer].
  const DeletePlayerFamily();

  /// See also [deletePlayer].
  DeletePlayerProvider call(
    PlayerDetails player,
  ) {
    return DeletePlayerProvider(
      player,
    );
  }

  @override
  DeletePlayerProvider getProviderOverride(
    covariant DeletePlayerProvider provider,
  ) {
    return call(
      provider.player,
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
  String? get name => r'deletePlayerProvider';
}

/// See also [deletePlayer].
class DeletePlayerProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deletePlayer].
  DeletePlayerProvider(
    PlayerDetails player,
  ) : this._internal(
          (ref) => deletePlayer(
            ref as DeletePlayerRef,
            player,
          ),
          from: deletePlayerProvider,
          name: r'deletePlayerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deletePlayerHash,
          dependencies: DeletePlayerFamily._dependencies,
          allTransitiveDependencies:
              DeletePlayerFamily._allTransitiveDependencies,
          player: player,
        );

  DeletePlayerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.player,
  }) : super.internal();

  final PlayerDetails player;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeletePlayerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeletePlayerProvider._internal(
        (ref) => create(ref as DeletePlayerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        player: player,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeletePlayerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeletePlayerProvider && other.player == player;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, player.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeletePlayerRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `player` of this provider.
  PlayerDetails get player;
}

class _DeletePlayerProviderElement
    extends AutoDisposeFutureProviderElement<bool> with DeletePlayerRef {
  _DeletePlayerProviderElement(super.provider);

  @override
  PlayerDetails get player => (origin as DeletePlayerProvider).player;
}

String _$savePlayerDetailsHash() => r'af2d0da174c452621500ab075c76e7d3cc03574b';

/// See also [savePlayerDetails].
@ProviderFor(savePlayerDetails)
const savePlayerDetailsProvider = SavePlayerDetailsFamily();

/// See also [savePlayerDetails].
class SavePlayerDetailsFamily extends Family<AsyncValue<bool>> {
  /// See also [savePlayerDetails].
  const SavePlayerDetailsFamily();

  /// See also [savePlayerDetails].
  SavePlayerDetailsProvider call(
    PlayerDetails player,
  ) {
    return SavePlayerDetailsProvider(
      player,
    );
  }

  @override
  SavePlayerDetailsProvider getProviderOverride(
    covariant SavePlayerDetailsProvider provider,
  ) {
    return call(
      provider.player,
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
  String? get name => r'savePlayerDetailsProvider';
}

/// See also [savePlayerDetails].
class SavePlayerDetailsProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [savePlayerDetails].
  SavePlayerDetailsProvider(
    PlayerDetails player,
  ) : this._internal(
          (ref) => savePlayerDetails(
            ref as SavePlayerDetailsRef,
            player,
          ),
          from: savePlayerDetailsProvider,
          name: r'savePlayerDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$savePlayerDetailsHash,
          dependencies: SavePlayerDetailsFamily._dependencies,
          allTransitiveDependencies:
              SavePlayerDetailsFamily._allTransitiveDependencies,
          player: player,
        );

  SavePlayerDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.player,
  }) : super.internal();

  final PlayerDetails player;

  @override
  Override overrideWith(
    FutureOr<bool> Function(SavePlayerDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SavePlayerDetailsProvider._internal(
        (ref) => create(ref as SavePlayerDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        player: player,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _SavePlayerDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SavePlayerDetailsProvider && other.player == player;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, player.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SavePlayerDetailsRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `player` of this provider.
  PlayerDetails get player;
}

class _SavePlayerDetailsProviderElement
    extends AutoDisposeFutureProviderElement<bool> with SavePlayerDetailsRef {
  _SavePlayerDetailsProviderElement(super.provider);

  @override
  PlayerDetails get player => (origin as SavePlayerDetailsProvider).player;
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
String _$playerStatsHash() => r'22ae1535b2651492f62536c4d5b6566fbd88b886';

/// See also [playerStats].
@ProviderFor(playerStats)
const playerStatsProvider = PlayerStatsFamily();

/// See also [playerStats].
class PlayerStatsFamily extends Family<AsyncValue<List<GameSession>>> {
  /// See also [playerStats].
  const PlayerStatsFamily();

  /// See also [playerStats].
  PlayerStatsProvider call(
    PlayerDetails player,
  ) {
    return PlayerStatsProvider(
      player,
    );
  }

  @override
  PlayerStatsProvider getProviderOverride(
    covariant PlayerStatsProvider provider,
  ) {
    return call(
      provider.player,
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
  String? get name => r'playerStatsProvider';
}

/// See also [playerStats].
class PlayerStatsProvider extends AutoDisposeFutureProvider<List<GameSession>> {
  /// See also [playerStats].
  PlayerStatsProvider(
    PlayerDetails player,
  ) : this._internal(
          (ref) => playerStats(
            ref as PlayerStatsRef,
            player,
          ),
          from: playerStatsProvider,
          name: r'playerStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playerStatsHash,
          dependencies: PlayerStatsFamily._dependencies,
          allTransitiveDependencies:
              PlayerStatsFamily._allTransitiveDependencies,
          player: player,
        );

  PlayerStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.player,
  }) : super.internal();

  final PlayerDetails player;

  @override
  Override overrideWith(
    FutureOr<List<GameSession>> Function(PlayerStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerStatsProvider._internal(
        (ref) => create(ref as PlayerStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        player: player,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GameSession>> createElement() {
    return _PlayerStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerStatsProvider && other.player == player;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, player.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlayerStatsRef on AutoDisposeFutureProviderRef<List<GameSession>> {
  /// The parameter `player` of this provider.
  PlayerDetails get player;
}

class _PlayerStatsProviderElement
    extends AutoDisposeFutureProviderElement<List<GameSession>>
    with PlayerStatsRef {
  _PlayerStatsProviderElement(super.provider);

  @override
  PlayerDetails get player => (origin as PlayerStatsProvider).player;
}

String _$loadTemplateInfoHash() => r'cbc262af22969915635d843135b6f3caafe06239';

/// See also [loadTemplateInfo].
@ProviderFor(loadTemplateInfo)
const loadTemplateInfoProvider = LoadTemplateInfoFamily();

/// See also [loadTemplateInfo].
class LoadTemplateInfoFamily extends Family<AsyncValue<List<GameSession>>> {
  /// See also [loadTemplateInfo].
  const LoadTemplateInfoFamily();

  /// See also [loadTemplateInfo].
  LoadTemplateInfoProvider call(
    GameTemplate template,
  ) {
    return LoadTemplateInfoProvider(
      template,
    );
  }

  @override
  LoadTemplateInfoProvider getProviderOverride(
    covariant LoadTemplateInfoProvider provider,
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
  String? get name => r'loadTemplateInfoProvider';
}

/// See also [loadTemplateInfo].
class LoadTemplateInfoProvider
    extends AutoDisposeFutureProvider<List<GameSession>> {
  /// See also [loadTemplateInfo].
  LoadTemplateInfoProvider(
    GameTemplate template,
  ) : this._internal(
          (ref) => loadTemplateInfo(
            ref as LoadTemplateInfoRef,
            template,
          ),
          from: loadTemplateInfoProvider,
          name: r'loadTemplateInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loadTemplateInfoHash,
          dependencies: LoadTemplateInfoFamily._dependencies,
          allTransitiveDependencies:
              LoadTemplateInfoFamily._allTransitiveDependencies,
          template: template,
        );

  LoadTemplateInfoProvider._internal(
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
    FutureOr<List<GameSession>> Function(LoadTemplateInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadTemplateInfoProvider._internal(
        (ref) => create(ref as LoadTemplateInfoRef),
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
  AutoDisposeFutureProviderElement<List<GameSession>> createElement() {
    return _LoadTemplateInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadTemplateInfoProvider && other.template == template;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, template.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoadTemplateInfoRef on AutoDisposeFutureProviderRef<List<GameSession>> {
  /// The parameter `template` of this provider.
  GameTemplate get template;
}

class _LoadTemplateInfoProviderElement
    extends AutoDisposeFutureProviderElement<List<GameSession>>
    with LoadTemplateInfoRef {
  _LoadTemplateInfoProviderElement(super.provider);

  @override
  GameTemplate get template => (origin as LoadTemplateInfoProvider).template;
}

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
String _$getIdsHash() => r'87c9e39e2ba78887d316d3756a557d1fe574740d';

/// See also [getIds].
@ProviderFor(getIds)
const getIdsProvider = GetIdsFamily();

/// See also [getIds].
class GetIdsFamily extends Family<AsyncValue<(String?, int?, int?)>> {
  /// See also [getIds].
  const GetIdsFamily();

  /// See also [getIds].
  GetIdsProvider call(
    bool deviceID,
  ) {
    return GetIdsProvider(
      deviceID,
    );
  }

  @override
  GetIdsProvider getProviderOverride(
    covariant GetIdsProvider provider,
  ) {
    return call(
      provider.deviceID,
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
  String? get name => r'getIdsProvider';
}

/// See also [getIds].
class GetIdsProvider extends AutoDisposeFutureProvider<(String?, int?, int?)> {
  /// See also [getIds].
  GetIdsProvider(
    bool deviceID,
  ) : this._internal(
          (ref) => getIds(
            ref as GetIdsRef,
            deviceID,
          ),
          from: getIdsProvider,
          name: r'getIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getIdsHash,
          dependencies: GetIdsFamily._dependencies,
          allTransitiveDependencies: GetIdsFamily._allTransitiveDependencies,
          deviceID: deviceID,
        );

  GetIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deviceID,
  }) : super.internal();

  final bool deviceID;

  @override
  Override overrideWith(
    FutureOr<(String?, int?, int?)> Function(GetIdsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetIdsProvider._internal(
        (ref) => create(ref as GetIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deviceID: deviceID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(String?, int?, int?)> createElement() {
    return _GetIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetIdsProvider && other.deviceID == deviceID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deviceID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetIdsRef on AutoDisposeFutureProviderRef<(String?, int?, int?)> {
  /// The parameter `deviceID` of this provider.
  bool get deviceID;
}

class _GetIdsProviderElement
    extends AutoDisposeFutureProviderElement<(String?, int?, int?)>
    with GetIdsRef {
  _GetIdsProviderElement(super.provider);

  @override
  bool get deviceID => (origin as GetIdsProvider).deviceID;
}

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
String _$getTabletIdHash() => r'1d8b5be495bebc5d08db85f77f784307cce7e738';

/// See also [getTabletId].
@ProviderFor(getTabletId)
final getTabletIdProvider = AutoDisposeFutureProvider<int?>.internal(
  getTabletId,
  name: r'getTabletIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getTabletIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetTabletIdRef = AutoDisposeFutureProviderRef<int?>;
String _$setTabletIdHash() => r'fb4a5e453f3f599fe9b05a6d01e55ee3ed85b642';

/// See also [setTabletId].
@ProviderFor(setTabletId)
const setTabletIdProvider = SetTabletIdFamily();

/// See also [setTabletId].
class SetTabletIdFamily extends Family<AsyncValue<void>> {
  /// See also [setTabletId].
  const SetTabletIdFamily();

  /// See also [setTabletId].
  SetTabletIdProvider call(
    int id,
  ) {
    return SetTabletIdProvider(
      id,
    );
  }

  @override
  SetTabletIdProvider getProviderOverride(
    covariant SetTabletIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'setTabletIdProvider';
}

/// See also [setTabletId].
class SetTabletIdProvider extends AutoDisposeFutureProvider<void> {
  /// See also [setTabletId].
  SetTabletIdProvider(
    int id,
  ) : this._internal(
          (ref) => setTabletId(
            ref as SetTabletIdRef,
            id,
          ),
          from: setTabletIdProvider,
          name: r'setTabletIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$setTabletIdHash,
          dependencies: SetTabletIdFamily._dependencies,
          allTransitiveDependencies:
              SetTabletIdFamily._allTransitiveDependencies,
          id: id,
        );

  SetTabletIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<void> Function(SetTabletIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SetTabletIdProvider._internal(
        (ref) => create(ref as SetTabletIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SetTabletIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SetTabletIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SetTabletIdRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  int get id;
}

class _SetTabletIdProviderElement extends AutoDisposeFutureProviderElement<void>
    with SetTabletIdRef {
  _SetTabletIdProviderElement(super.provider);

  @override
  int get id => (origin as SetTabletIdProvider).id;
}

String _$testHash() => r'4ea05c2a06adbb4c41ebc510c99a0118131e1992';

/// See also [test].
@ProviderFor(test)
final testProvider = AutoDisposeFutureProvider<dynamic>.internal(
  test,
  name: r'testProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$testHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TestRef = AutoDisposeFutureProviderRef<dynamic>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
