// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordini_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ordiniNotifierHash() => r'db333111003eee105eb7735176eaa2c65bf0d52f';

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

abstract class _$OrdiniNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<models.Ordine>> {
  late final int serataId;

  FutureOr<List<models.Ordine>> build(
    int serataId,
  );
}

/// See also [OrdiniNotifier].
@ProviderFor(OrdiniNotifier)
const ordiniNotifierProvider = OrdiniNotifierFamily();

/// See also [OrdiniNotifier].
class OrdiniNotifierFamily extends Family<AsyncValue<List<models.Ordine>>> {
  /// See also [OrdiniNotifier].
  const OrdiniNotifierFamily();

  /// See also [OrdiniNotifier].
  OrdiniNotifierProvider call(
    int serataId,
  ) {
    return OrdiniNotifierProvider(
      serataId,
    );
  }

  @override
  OrdiniNotifierProvider getProviderOverride(
    covariant OrdiniNotifierProvider provider,
  ) {
    return call(
      provider.serataId,
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
  String? get name => r'ordiniNotifierProvider';
}

/// See also [OrdiniNotifier].
class OrdiniNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    OrdiniNotifier, List<models.Ordine>> {
  /// See also [OrdiniNotifier].
  OrdiniNotifierProvider(
    int serataId,
  ) : this._internal(
          () => OrdiniNotifier()..serataId = serataId,
          from: ordiniNotifierProvider,
          name: r'ordiniNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ordiniNotifierHash,
          dependencies: OrdiniNotifierFamily._dependencies,
          allTransitiveDependencies:
              OrdiniNotifierFamily._allTransitiveDependencies,
          serataId: serataId,
        );

  OrdiniNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serataId,
  }) : super.internal();

  final int serataId;

  @override
  FutureOr<List<models.Ordine>> runNotifierBuild(
    covariant OrdiniNotifier notifier,
  ) {
    return notifier.build(
      serataId,
    );
  }

  @override
  Override overrideWith(OrdiniNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrdiniNotifierProvider._internal(
        () => create()..serataId = serataId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serataId: serataId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OrdiniNotifier, List<models.Ordine>>
      createElement() {
    return _OrdiniNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrdiniNotifierProvider && other.serataId == serataId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serataId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrdiniNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<models.Ordine>> {
  /// The parameter `serataId` of this provider.
  int get serataId;
}

class _OrdiniNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OrdiniNotifier,
        List<models.Ordine>> with OrdiniNotifierRef {
  _OrdiniNotifierProviderElement(super.provider);

  @override
  int get serataId => (origin as OrdiniNotifierProvider).serataId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
