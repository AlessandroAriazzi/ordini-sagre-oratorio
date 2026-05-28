// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MenusNotifier)
final menusProvider = MenusNotifierProvider._();

final class MenusNotifierProvider
    extends $AsyncNotifierProvider<MenusNotifier, List<models.Menu>> {
  MenusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'menusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$menusNotifierHash();

  @$internal
  @override
  MenusNotifier create() => MenusNotifier();
}

String _$menusNotifierHash() => r'5cc64278cb6b5e565d55687bee35fa66ab0ad2f1';

abstract class _$MenusNotifier extends $AsyncNotifier<List<models.Menu>> {
  FutureOr<List<models.Menu>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<models.Menu>>, List<models.Menu>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<models.Menu>>, List<models.Menu>>,
              AsyncValue<List<models.Menu>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(menuById)
final menuByIdProvider = MenuByIdFamily._();

final class MenuByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<models.Menu?>,
          models.Menu?,
          FutureOr<models.Menu?>
        >
    with $FutureModifier<models.Menu?>, $FutureProvider<models.Menu?> {
  MenuByIdProvider._({
    required MenuByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'menuByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$menuByIdHash();

  @override
  String toString() {
    return r'menuByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<models.Menu?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<models.Menu?> create(Ref ref) {
    final argument = this.argument as int;
    return menuById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$menuByIdHash() => r'a23fcc3c91687775220a009a9a835e063b99aa14';

final class MenuByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<models.Menu?>, int> {
  MenuByIdFamily._()
    : super(
        retry: null,
        name: r'menuByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MenuByIdProvider call(int menuId) =>
      MenuByIdProvider._(argument: menuId, from: this);

  @override
  String toString() => r'menuByIdProvider';
}
