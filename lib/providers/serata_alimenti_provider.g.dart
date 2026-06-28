// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serata_alimenti_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SerataAlimentiNotifier)
final serataAlimentiProvider = SerataAlimentiNotifierFamily._();

final class SerataAlimentiNotifierProvider
    extends
        $AsyncNotifierProvider<
          SerataAlimentiNotifier,
          List<SerataAlimentoEntry>
        > {
  SerataAlimentiNotifierProvider._({
    required SerataAlimentiNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'serataAlimentiProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serataAlimentiNotifierHash();

  @override
  String toString() {
    return r'serataAlimentiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SerataAlimentiNotifier create() => SerataAlimentiNotifier();

  @override
  bool operator ==(Object other) {
    return other is SerataAlimentiNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serataAlimentiNotifierHash() =>
    r'edfe4d510bc08747e3a1a01d1bc5029c2561e22b';

final class SerataAlimentiNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SerataAlimentiNotifier,
          AsyncValue<List<SerataAlimentoEntry>>,
          List<SerataAlimentoEntry>,
          FutureOr<List<SerataAlimentoEntry>>,
          int
        > {
  SerataAlimentiNotifierFamily._()
    : super(
        retry: null,
        name: r'serataAlimentiProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SerataAlimentiNotifierProvider call(int serataId) =>
      SerataAlimentiNotifierProvider._(argument: serataId, from: this);

  @override
  String toString() => r'serataAlimentiProvider';
}

abstract class _$SerataAlimentiNotifier
    extends $AsyncNotifier<List<SerataAlimentoEntry>> {
  late final _$args = ref.$arg as int;
  int get serataId => _$args;

  FutureOr<List<SerataAlimentoEntry>> build(int serataId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<SerataAlimentoEntry>>,
              List<SerataAlimentoEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SerataAlimentoEntry>>,
                List<SerataAlimentoEntry>
              >,
              AsyncValue<List<SerataAlimentoEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
