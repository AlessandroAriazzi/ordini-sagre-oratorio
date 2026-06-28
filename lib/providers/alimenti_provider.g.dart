// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimenti_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlimentiNotifier)
final alimentiProvider = AlimentiNotifierProvider._();

final class AlimentiNotifierProvider
    extends $AsyncNotifierProvider<AlimentiNotifier, List<Alimento>> {
  AlimentiNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alimentiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alimentiNotifierHash();

  @$internal
  @override
  AlimentiNotifier create() => AlimentiNotifier();
}

String _$alimentiNotifierHash() => r'4deb4e7d0c2887de679d4e0c372fe122c0b55727';

abstract class _$AlimentiNotifier extends $AsyncNotifier<List<Alimento>> {
  FutureOr<List<Alimento>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Alimento>>, List<Alimento>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Alimento>>, List<Alimento>>,
              AsyncValue<List<Alimento>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
