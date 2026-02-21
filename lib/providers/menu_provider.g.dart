// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$menuByIdHash() => r'a23fcc3c91687775220a009a9a835e063b99aa14';

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

/// See also [menuById].
@ProviderFor(menuById)
const menuByIdProvider = MenuByIdFamily();

/// See also [menuById].
class MenuByIdFamily extends Family<AsyncValue<models.Menu?>> {
  /// See also [menuById].
  const MenuByIdFamily();

  /// See also [menuById].
  MenuByIdProvider call(
    int menuId,
  ) {
    return MenuByIdProvider(
      menuId,
    );
  }

  @override
  MenuByIdProvider getProviderOverride(
    covariant MenuByIdProvider provider,
  ) {
    return call(
      provider.menuId,
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
  String? get name => r'menuByIdProvider';
}

/// See also [menuById].
class MenuByIdProvider extends AutoDisposeFutureProvider<models.Menu?> {
  /// See also [menuById].
  MenuByIdProvider(
    int menuId,
  ) : this._internal(
          (ref) => menuById(
            ref as MenuByIdRef,
            menuId,
          ),
          from: menuByIdProvider,
          name: r'menuByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$menuByIdHash,
          dependencies: MenuByIdFamily._dependencies,
          allTransitiveDependencies: MenuByIdFamily._allTransitiveDependencies,
          menuId: menuId,
        );

  MenuByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.menuId,
  }) : super.internal();

  final int menuId;

  @override
  Override overrideWith(
    FutureOr<models.Menu?> Function(MenuByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MenuByIdProvider._internal(
        (ref) => create(ref as MenuByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        menuId: menuId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<models.Menu?> createElement() {
    return _MenuByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuByIdProvider && other.menuId == menuId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, menuId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MenuByIdRef on AutoDisposeFutureProviderRef<models.Menu?> {
  /// The parameter `menuId` of this provider.
  int get menuId;
}

class _MenuByIdProviderElement
    extends AutoDisposeFutureProviderElement<models.Menu?> with MenuByIdRef {
  _MenuByIdProviderElement(super.provider);

  @override
  int get menuId => (origin as MenuByIdProvider).menuId;
}

String _$menusNotifierHash() => r'5cc64278cb6b5e565d55687bee35fa66ab0ad2f1';

/// See also [MenusNotifier].
@ProviderFor(MenusNotifier)
final menusNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MenusNotifier, List<models.Menu>>.internal(
  MenusNotifier.new,
  name: r'menusNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$menusNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MenusNotifier = AutoDisposeAsyncNotifier<List<models.Menu>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
