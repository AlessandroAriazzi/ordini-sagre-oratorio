// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordini_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrdiniNotifier)
final ordiniProvider = OrdiniNotifierFamily._();

final class OrdiniNotifierProvider
    extends $AsyncNotifierProvider<OrdiniNotifier, List<models.Ordine>> {
  OrdiniNotifierProvider._({
    required OrdiniNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ordiniProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ordiniNotifierHash();

  @override
  String toString() {
    return r'ordiniProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrdiniNotifier create() => OrdiniNotifier();

  @override
  bool operator ==(Object other) {
    return other is OrdiniNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ordiniNotifierHash() => r'ed1fb3e4ec31a00764d946b25097b8c92f6e4f55';

final class OrdiniNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          OrdiniNotifier,
          AsyncValue<List<models.Ordine>>,
          List<models.Ordine>,
          FutureOr<List<models.Ordine>>,
          int
        > {
  OrdiniNotifierFamily._()
    : super(
        retry: null,
        name: r'ordiniProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrdiniNotifierProvider call(int serataId) =>
      OrdiniNotifierProvider._(argument: serataId, from: this);

  @override
  String toString() => r'ordiniProvider';
}

abstract class _$OrdiniNotifier extends $AsyncNotifier<List<models.Ordine>> {
  late final _$args = ref.$arg as int;
  int get serataId => _$args;

  FutureOr<List<models.Ordine>> build(int serataId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<models.Ordine>>, List<models.Ordine>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<models.Ordine>>, List<models.Ordine>>,
              AsyncValue<List<models.Ordine>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
