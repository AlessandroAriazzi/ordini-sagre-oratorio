// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thermal_printer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThermalPrinterNotifier)
final thermalPrinterProvider = ThermalPrinterNotifierProvider._();

final class ThermalPrinterNotifierProvider
    extends
        $AsyncNotifierProvider<ThermalPrinterNotifier, ThermalPrinterConfig> {
  ThermalPrinterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'thermalPrinterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$thermalPrinterNotifierHash();

  @$internal
  @override
  ThermalPrinterNotifier create() => ThermalPrinterNotifier();
}

String _$thermalPrinterNotifierHash() =>
    r'b58e93a70980ecf3a74b03d088958dd5f1e2c2ae';

abstract class _$ThermalPrinterNotifier
    extends $AsyncNotifier<ThermalPrinterConfig> {
  FutureOr<ThermalPrinterConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ThermalPrinterConfig>, ThermalPrinterConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ThermalPrinterConfig>,
                ThermalPrinterConfig
              >,
              AsyncValue<ThermalPrinterConfig>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
