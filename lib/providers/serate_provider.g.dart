// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

final class DatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$databaseHash() => r'b43f5a38382427710fbceefeb419518e859b35ea';

@ProviderFor(SerateNotifier)
final serateProvider = SerateNotifierProvider._();

final class SerateNotifierProvider
    extends $AsyncNotifierProvider<SerateNotifier, List<models.Serata>> {
  SerateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serateNotifierHash();

  @$internal
  @override
  SerateNotifier create() => SerateNotifier();
}

String _$serateNotifierHash() => r'b4f6ca96bc08ffc5ba82b8d3f6db8fe7a5cc1b1e';

abstract class _$SerateNotifier extends $AsyncNotifier<List<models.Serata>> {
  FutureOr<List<models.Serata>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<models.Serata>>, List<models.Serata>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<models.Serata>>, List<models.Serata>>,
              AsyncValue<List<models.Serata>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
