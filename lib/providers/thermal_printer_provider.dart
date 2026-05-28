import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'thermal_printer_provider.g.dart';

class ThermalPrinterConfig {
  final String? name;
  final String? address;
  final String connectionType; // 'USB' or 'NETWORK'
  final int port;
  final String? vendorId;
  final String? productId;

  const ThermalPrinterConfig({
    this.name,
    this.address,
    this.connectionType = 'NETWORK',
    this.port = 9100,
    this.vendorId,
    this.productId,
  });

  bool get isConfigured {
    if (connectionType == 'CUPS') return name != null && name!.isNotEmpty;
    if (connectionType == 'USB') return (address != null && address!.isNotEmpty) || (name != null && name!.isNotEmpty);
    return address != null && address!.isNotEmpty;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'connectionType': connectionType,
        'port': port,
        'vendorId': vendorId,
        'productId': productId,
      };

  factory ThermalPrinterConfig.fromJson(Map<String, dynamic> json) =>
      ThermalPrinterConfig(
        name: json['name'] as String?,
        address: json['address'] as String?,
        connectionType: json['connectionType'] as String? ?? 'NETWORK',
        port: json['port'] as int? ?? 9100,
        vendorId: json['vendorId'] as String?,
        productId: json['productId'] as String?,
      );
}

Future<File> _thermalSettingsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/thermal_printer_settings.json');
}

Future<ThermalPrinterConfig> _loadThermalConfig() async {
  try {
    final file = await _thermalSettingsFile();
    if (!await file.exists()) return const ThermalPrinterConfig();
    final raw = await file.readAsString();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return ThermalPrinterConfig.fromJson(json);
  } catch (e) {
    debugPrint('ThermalPrinter load error: $e');
    return const ThermalPrinterConfig();
  }
}

Future<void> _saveThermalConfig(ThermalPrinterConfig config) async {
  try {
    final file = await _thermalSettingsFile();
    await file.writeAsString(jsonEncode(config.toJson()));
  } catch (e) {
    debugPrint('ThermalPrinter save error: $e');
  }
}

@riverpod
class ThermalPrinterNotifier extends _$ThermalPrinterNotifier {
  @override
  Future<ThermalPrinterConfig> build() => _loadThermalConfig();

  Future<void> saveNetworkPrinter({
    required String address,
    required int port,
    String? name,
  }) async {
    final config = ThermalPrinterConfig(
      name: name ?? address,
      address: address,
      connectionType: 'NETWORK',
      port: port,
    );
    await _saveThermalConfig(config);
    state = AsyncData(config);
  }

  Future<void> saveUsbPrinter({
    required String name,
    required String address,
    String? vendorId,
    String? productId,
  }) async {
    final config = ThermalPrinterConfig(
      name: name,
      address: address,
      connectionType: 'USB',
      vendorId: vendorId,
      productId: productId,
    );
    await _saveThermalConfig(config);
    state = AsyncData(config);
  }

  Future<void> saveCupsPrinter({required String name}) async {
    final config = ThermalPrinterConfig(name: name, connectionType: 'CUPS');
    await _saveThermalConfig(config);
    state = AsyncData(config);
  }

  Future<void> clear() async {
    const config = ThermalPrinterConfig();
    await _saveThermalConfig(config);
    state = const AsyncData(ThermalPrinterConfig());
  }
}
