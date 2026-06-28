// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SerateTable extends Serate with TableInfo<$SerateTable, SerataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SerateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titoloMeta = const VerificationMeta('titolo');
  @override
  late final GeneratedColumn<String> titolo = GeneratedColumn<String>(
    'titolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, titolo, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'serate';
  @override
  VerificationContext validateIntegrity(
    Insertable<SerataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titolo')) {
      context.handle(
        _titoloMeta,
        titolo.isAcceptableOrUnknown(data['titolo']!, _titoloMeta),
      );
    } else if (isInserting) {
      context.missing(_titoloMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SerataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SerataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titolo'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $SerateTable createAlias(String alias) {
    return $SerateTable(attachedDatabase, alias);
  }
}

class SerataData extends DataClass implements Insertable<SerataData> {
  final int id;
  final String titolo;
  final DateTime data;
  const SerataData({
    required this.id,
    required this.titolo,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titolo'] = Variable<String>(titolo);
    map['data'] = Variable<DateTime>(data);
    return map;
  }

  SerateCompanion toCompanion(bool nullToAbsent) {
    return SerateCompanion(
      id: Value(id),
      titolo: Value(titolo),
      data: Value(data),
    );
  }

  factory SerataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SerataData(
      id: serializer.fromJson<int>(json['id']),
      titolo: serializer.fromJson<String>(json['titolo']),
      data: serializer.fromJson<DateTime>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titolo': serializer.toJson<String>(titolo),
      'data': serializer.toJson<DateTime>(data),
    };
  }

  SerataData copyWith({int? id, String? titolo, DateTime? data}) => SerataData(
    id: id ?? this.id,
    titolo: titolo ?? this.titolo,
    data: data ?? this.data,
  );
  SerataData copyWithCompanion(SerateCompanion data) {
    return SerataData(
      id: data.id.present ? data.id.value : this.id,
      titolo: data.titolo.present ? data.titolo.value : this.titolo,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SerataData(')
          ..write('id: $id, ')
          ..write('titolo: $titolo, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titolo, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SerataData &&
          other.id == this.id &&
          other.titolo == this.titolo &&
          other.data == this.data);
}

class SerateCompanion extends UpdateCompanion<SerataData> {
  final Value<int> id;
  final Value<String> titolo;
  final Value<DateTime> data;
  const SerateCompanion({
    this.id = const Value.absent(),
    this.titolo = const Value.absent(),
    this.data = const Value.absent(),
  });
  SerateCompanion.insert({
    this.id = const Value.absent(),
    required String titolo,
    required DateTime data,
  }) : titolo = Value(titolo),
       data = Value(data);
  static Insertable<SerataData> custom({
    Expression<int>? id,
    Expression<String>? titolo,
    Expression<DateTime>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titolo != null) 'titolo': titolo,
      if (data != null) 'data': data,
    });
  }

  SerateCompanion copyWith({
    Value<int>? id,
    Value<String>? titolo,
    Value<DateTime>? data,
  }) {
    return SerateCompanion(
      id: id ?? this.id,
      titolo: titolo ?? this.titolo,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titolo.present) {
      map['titolo'] = Variable<String>(titolo.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SerateCompanion(')
          ..write('id: $id, ')
          ..write('titolo: $titolo, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $AlimentiTable extends Alimenti
    with TableInfo<$AlimentiTable, AlimentoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlimentiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prezzoDefaultMeta = const VerificationMeta(
    'prezzoDefault',
  );
  @override
  late final GeneratedColumn<double> prezzoDefault = GeneratedColumn<double>(
    'prezzo_default',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, categoria, prezzoDefault];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alimenti';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlimentoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('prezzo_default')) {
      context.handle(
        _prezzoDefaultMeta,
        prezzoDefault.isAcceptableOrUnknown(
          data['prezzo_default']!,
          _prezzoDefaultMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prezzoDefaultMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlimentoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlimentoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      prezzoDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prezzo_default'],
      )!,
    );
  }

  @override
  $AlimentiTable createAlias(String alias) {
    return $AlimentiTable(attachedDatabase, alias);
  }
}

class AlimentoData extends DataClass implements Insertable<AlimentoData> {
  final int id;
  final String nome;
  final String categoria;
  final double prezzoDefault;
  const AlimentoData({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.prezzoDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['categoria'] = Variable<String>(categoria);
    map['prezzo_default'] = Variable<double>(prezzoDefault);
    return map;
  }

  AlimentiCompanion toCompanion(bool nullToAbsent) {
    return AlimentiCompanion(
      id: Value(id),
      nome: Value(nome),
      categoria: Value(categoria),
      prezzoDefault: Value(prezzoDefault),
    );
  }

  factory AlimentoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlimentoData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoria: serializer.fromJson<String>(json['categoria']),
      prezzoDefault: serializer.fromJson<double>(json['prezzoDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'categoria': serializer.toJson<String>(categoria),
      'prezzoDefault': serializer.toJson<double>(prezzoDefault),
    };
  }

  AlimentoData copyWith({
    int? id,
    String? nome,
    String? categoria,
    double? prezzoDefault,
  }) => AlimentoData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    categoria: categoria ?? this.categoria,
    prezzoDefault: prezzoDefault ?? this.prezzoDefault,
  );
  AlimentoData copyWithCompanion(AlimentiCompanion data) {
    return AlimentoData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      prezzoDefault: data.prezzoDefault.present
          ? data.prezzoDefault.value
          : this.prezzoDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlimentoData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('prezzoDefault: $prezzoDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, categoria, prezzoDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlimentoData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoria == this.categoria &&
          other.prezzoDefault == this.prezzoDefault);
}

class AlimentiCompanion extends UpdateCompanion<AlimentoData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> categoria;
  final Value<double> prezzoDefault;
  const AlimentiCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoria = const Value.absent(),
    this.prezzoDefault = const Value.absent(),
  });
  AlimentiCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String categoria,
    required double prezzoDefault,
  }) : nome = Value(nome),
       categoria = Value(categoria),
       prezzoDefault = Value(prezzoDefault);
  static Insertable<AlimentoData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? categoria,
    Expression<double>? prezzoDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoria != null) 'categoria': categoria,
      if (prezzoDefault != null) 'prezzo_default': prezzoDefault,
    });
  }

  AlimentiCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? categoria,
    Value<double>? prezzoDefault,
  }) {
    return AlimentiCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      prezzoDefault: prezzoDefault ?? this.prezzoDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (prezzoDefault.present) {
      map['prezzo_default'] = Variable<double>(prezzoDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlimentiCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('prezzoDefault: $prezzoDefault')
          ..write(')'))
        .toString();
  }
}

class $SerataAlimentiTable extends SerataAlimenti
    with TableInfo<$SerataAlimentiTable, SerataAlimentoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SerataAlimentiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serataIdMeta = const VerificationMeta(
    'serataId',
  );
  @override
  late final GeneratedColumn<int> serataId = GeneratedColumn<int>(
    'serata_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alimentoIdMeta = const VerificationMeta(
    'alimentoId',
  );
  @override
  late final GeneratedColumn<int> alimentoId = GeneratedColumn<int>(
    'alimento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prezzoMeta = const VerificationMeta('prezzo');
  @override
  late final GeneratedColumn<double> prezzo = GeneratedColumn<double>(
    'prezzo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantitaMeta = const VerificationMeta(
    'quantita',
  );
  @override
  late final GeneratedColumn<int> quantita = GeneratedColumn<int>(
    'quantita',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serataId,
    alimentoId,
    prezzo,
    quantita,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'serata_alimenti';
  @override
  VerificationContext validateIntegrity(
    Insertable<SerataAlimentoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serata_id')) {
      context.handle(
        _serataIdMeta,
        serataId.isAcceptableOrUnknown(data['serata_id']!, _serataIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serataIdMeta);
    }
    if (data.containsKey('alimento_id')) {
      context.handle(
        _alimentoIdMeta,
        alimentoId.isAcceptableOrUnknown(data['alimento_id']!, _alimentoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alimentoIdMeta);
    }
    if (data.containsKey('prezzo')) {
      context.handle(
        _prezzoMeta,
        prezzo.isAcceptableOrUnknown(data['prezzo']!, _prezzoMeta),
      );
    } else if (isInserting) {
      context.missing(_prezzoMeta);
    }
    if (data.containsKey('quantita')) {
      context.handle(
        _quantitaMeta,
        quantita.isAcceptableOrUnknown(data['quantita']!, _quantitaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SerataAlimentoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SerataAlimentoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serataId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serata_id'],
      )!,
      alimentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alimento_id'],
      )!,
      prezzo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prezzo'],
      )!,
      quantita: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantita'],
      )!,
    );
  }

  @override
  $SerataAlimentiTable createAlias(String alias) {
    return $SerataAlimentiTable(attachedDatabase, alias);
  }
}

class SerataAlimentoData extends DataClass
    implements Insertable<SerataAlimentoData> {
  final int id;
  final int serataId;
  final int alimentoId;
  final double prezzo;
  final int quantita;
  const SerataAlimentoData({
    required this.id,
    required this.serataId,
    required this.alimentoId,
    required this.prezzo,
    required this.quantita,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serata_id'] = Variable<int>(serataId);
    map['alimento_id'] = Variable<int>(alimentoId);
    map['prezzo'] = Variable<double>(prezzo);
    map['quantita'] = Variable<int>(quantita);
    return map;
  }

  SerataAlimentiCompanion toCompanion(bool nullToAbsent) {
    return SerataAlimentiCompanion(
      id: Value(id),
      serataId: Value(serataId),
      alimentoId: Value(alimentoId),
      prezzo: Value(prezzo),
      quantita: Value(quantita),
    );
  }

  factory SerataAlimentoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SerataAlimentoData(
      id: serializer.fromJson<int>(json['id']),
      serataId: serializer.fromJson<int>(json['serataId']),
      alimentoId: serializer.fromJson<int>(json['alimentoId']),
      prezzo: serializer.fromJson<double>(json['prezzo']),
      quantita: serializer.fromJson<int>(json['quantita']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serataId': serializer.toJson<int>(serataId),
      'alimentoId': serializer.toJson<int>(alimentoId),
      'prezzo': serializer.toJson<double>(prezzo),
      'quantita': serializer.toJson<int>(quantita),
    };
  }

  SerataAlimentoData copyWith({
    int? id,
    int? serataId,
    int? alimentoId,
    double? prezzo,
    int? quantita,
  }) => SerataAlimentoData(
    id: id ?? this.id,
    serataId: serataId ?? this.serataId,
    alimentoId: alimentoId ?? this.alimentoId,
    prezzo: prezzo ?? this.prezzo,
    quantita: quantita ?? this.quantita,
  );
  SerataAlimentoData copyWithCompanion(SerataAlimentiCompanion data) {
    return SerataAlimentoData(
      id: data.id.present ? data.id.value : this.id,
      serataId: data.serataId.present ? data.serataId.value : this.serataId,
      alimentoId: data.alimentoId.present
          ? data.alimentoId.value
          : this.alimentoId,
      prezzo: data.prezzo.present ? data.prezzo.value : this.prezzo,
      quantita: data.quantita.present ? data.quantita.value : this.quantita,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SerataAlimentoData(')
          ..write('id: $id, ')
          ..write('serataId: $serataId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('prezzo: $prezzo, ')
          ..write('quantita: $quantita')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serataId, alimentoId, prezzo, quantita);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SerataAlimentoData &&
          other.id == this.id &&
          other.serataId == this.serataId &&
          other.alimentoId == this.alimentoId &&
          other.prezzo == this.prezzo &&
          other.quantita == this.quantita);
}

class SerataAlimentiCompanion extends UpdateCompanion<SerataAlimentoData> {
  final Value<int> id;
  final Value<int> serataId;
  final Value<int> alimentoId;
  final Value<double> prezzo;
  final Value<int> quantita;
  const SerataAlimentiCompanion({
    this.id = const Value.absent(),
    this.serataId = const Value.absent(),
    this.alimentoId = const Value.absent(),
    this.prezzo = const Value.absent(),
    this.quantita = const Value.absent(),
  });
  SerataAlimentiCompanion.insert({
    this.id = const Value.absent(),
    required int serataId,
    required int alimentoId,
    required double prezzo,
    this.quantita = const Value.absent(),
  }) : serataId = Value(serataId),
       alimentoId = Value(alimentoId),
       prezzo = Value(prezzo);
  static Insertable<SerataAlimentoData> custom({
    Expression<int>? id,
    Expression<int>? serataId,
    Expression<int>? alimentoId,
    Expression<double>? prezzo,
    Expression<int>? quantita,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serataId != null) 'serata_id': serataId,
      if (alimentoId != null) 'alimento_id': alimentoId,
      if (prezzo != null) 'prezzo': prezzo,
      if (quantita != null) 'quantita': quantita,
    });
  }

  SerataAlimentiCompanion copyWith({
    Value<int>? id,
    Value<int>? serataId,
    Value<int>? alimentoId,
    Value<double>? prezzo,
    Value<int>? quantita,
  }) {
    return SerataAlimentiCompanion(
      id: id ?? this.id,
      serataId: serataId ?? this.serataId,
      alimentoId: alimentoId ?? this.alimentoId,
      prezzo: prezzo ?? this.prezzo,
      quantita: quantita ?? this.quantita,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serataId.present) {
      map['serata_id'] = Variable<int>(serataId.value);
    }
    if (alimentoId.present) {
      map['alimento_id'] = Variable<int>(alimentoId.value);
    }
    if (prezzo.present) {
      map['prezzo'] = Variable<double>(prezzo.value);
    }
    if (quantita.present) {
      map['quantita'] = Variable<int>(quantita.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SerataAlimentiCompanion(')
          ..write('id: $id, ')
          ..write('serataId: $serataId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('prezzo: $prezzo, ')
          ..write('quantita: $quantita')
          ..write(')'))
        .toString();
  }
}

class $OrdiniTable extends Ordini with TableInfo<$OrdiniTable, OrdineData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdiniTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serataIdMeta = const VerificationMeta(
    'serataId',
  );
  @override
  late final GeneratedColumn<int> serataId = GeneratedColumn<int>(
    'serata_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dataOraMeta = const VerificationMeta(
    'dataOra',
  );
  @override
  late final GeneratedColumn<DateTime> dataOra = GeneratedColumn<DateTime>(
    'data_ora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totaleMeta = const VerificationMeta('totale');
  @override
  late final GeneratedColumn<double> totale = GeneratedColumn<double>(
    'totale',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, serataId, numero, dataOra, totale];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordini';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdineData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serata_id')) {
      context.handle(
        _serataIdMeta,
        serataId.isAcceptableOrUnknown(data['serata_id']!, _serataIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serataIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    }
    if (data.containsKey('data_ora')) {
      context.handle(
        _dataOraMeta,
        dataOra.isAcceptableOrUnknown(data['data_ora']!, _dataOraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataOraMeta);
    }
    if (data.containsKey('totale')) {
      context.handle(
        _totaleMeta,
        totale.isAcceptableOrUnknown(data['totale']!, _totaleMeta),
      );
    } else if (isInserting) {
      context.missing(_totaleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdineData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdineData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serataId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serata_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      dataOra: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_ora'],
      )!,
      totale: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}totale'],
      )!,
    );
  }

  @override
  $OrdiniTable createAlias(String alias) {
    return $OrdiniTable(attachedDatabase, alias);
  }
}

class OrdineData extends DataClass implements Insertable<OrdineData> {
  final int id;
  final int serataId;
  final int numero;
  final DateTime dataOra;
  final double totale;
  const OrdineData({
    required this.id,
    required this.serataId,
    required this.numero,
    required this.dataOra,
    required this.totale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serata_id'] = Variable<int>(serataId);
    map['numero'] = Variable<int>(numero);
    map['data_ora'] = Variable<DateTime>(dataOra);
    map['totale'] = Variable<double>(totale);
    return map;
  }

  OrdiniCompanion toCompanion(bool nullToAbsent) {
    return OrdiniCompanion(
      id: Value(id),
      serataId: Value(serataId),
      numero: Value(numero),
      dataOra: Value(dataOra),
      totale: Value(totale),
    );
  }

  factory OrdineData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdineData(
      id: serializer.fromJson<int>(json['id']),
      serataId: serializer.fromJson<int>(json['serataId']),
      numero: serializer.fromJson<int>(json['numero']),
      dataOra: serializer.fromJson<DateTime>(json['dataOra']),
      totale: serializer.fromJson<double>(json['totale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serataId': serializer.toJson<int>(serataId),
      'numero': serializer.toJson<int>(numero),
      'dataOra': serializer.toJson<DateTime>(dataOra),
      'totale': serializer.toJson<double>(totale),
    };
  }

  OrdineData copyWith({
    int? id,
    int? serataId,
    int? numero,
    DateTime? dataOra,
    double? totale,
  }) => OrdineData(
    id: id ?? this.id,
    serataId: serataId ?? this.serataId,
    numero: numero ?? this.numero,
    dataOra: dataOra ?? this.dataOra,
    totale: totale ?? this.totale,
  );
  OrdineData copyWithCompanion(OrdiniCompanion data) {
    return OrdineData(
      id: data.id.present ? data.id.value : this.id,
      serataId: data.serataId.present ? data.serataId.value : this.serataId,
      numero: data.numero.present ? data.numero.value : this.numero,
      dataOra: data.dataOra.present ? data.dataOra.value : this.dataOra,
      totale: data.totale.present ? data.totale.value : this.totale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdineData(')
          ..write('id: $id, ')
          ..write('serataId: $serataId, ')
          ..write('numero: $numero, ')
          ..write('dataOra: $dataOra, ')
          ..write('totale: $totale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serataId, numero, dataOra, totale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdineData &&
          other.id == this.id &&
          other.serataId == this.serataId &&
          other.numero == this.numero &&
          other.dataOra == this.dataOra &&
          other.totale == this.totale);
}

class OrdiniCompanion extends UpdateCompanion<OrdineData> {
  final Value<int> id;
  final Value<int> serataId;
  final Value<int> numero;
  final Value<DateTime> dataOra;
  final Value<double> totale;
  const OrdiniCompanion({
    this.id = const Value.absent(),
    this.serataId = const Value.absent(),
    this.numero = const Value.absent(),
    this.dataOra = const Value.absent(),
    this.totale = const Value.absent(),
  });
  OrdiniCompanion.insert({
    this.id = const Value.absent(),
    required int serataId,
    this.numero = const Value.absent(),
    required DateTime dataOra,
    required double totale,
  }) : serataId = Value(serataId),
       dataOra = Value(dataOra),
       totale = Value(totale);
  static Insertable<OrdineData> custom({
    Expression<int>? id,
    Expression<int>? serataId,
    Expression<int>? numero,
    Expression<DateTime>? dataOra,
    Expression<double>? totale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serataId != null) 'serata_id': serataId,
      if (numero != null) 'numero': numero,
      if (dataOra != null) 'data_ora': dataOra,
      if (totale != null) 'totale': totale,
    });
  }

  OrdiniCompanion copyWith({
    Value<int>? id,
    Value<int>? serataId,
    Value<int>? numero,
    Value<DateTime>? dataOra,
    Value<double>? totale,
  }) {
    return OrdiniCompanion(
      id: id ?? this.id,
      serataId: serataId ?? this.serataId,
      numero: numero ?? this.numero,
      dataOra: dataOra ?? this.dataOra,
      totale: totale ?? this.totale,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serataId.present) {
      map['serata_id'] = Variable<int>(serataId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (dataOra.present) {
      map['data_ora'] = Variable<DateTime>(dataOra.value);
    }
    if (totale.present) {
      map['totale'] = Variable<double>(totale.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdiniCompanion(')
          ..write('id: $id, ')
          ..write('serataId: $serataId, ')
          ..write('numero: $numero, ')
          ..write('dataOra: $dataOra, ')
          ..write('totale: $totale')
          ..write(')'))
        .toString();
  }
}

class $OrdiniItemsTable extends OrdiniItems
    with TableInfo<$OrdiniItemsTable, OrdiniItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdiniItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordineIdMeta = const VerificationMeta(
    'ordineId',
  );
  @override
  late final GeneratedColumn<int> ordineId = GeneratedColumn<int>(
    'ordine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prodottoIdMeta = const VerificationMeta(
    'prodottoId',
  );
  @override
  late final GeneratedColumn<int> prodottoId = GeneratedColumn<int>(
    'prodotto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prodottoNomeMeta = const VerificationMeta(
    'prodottoNome',
  );
  @override
  late final GeneratedColumn<String> prodottoNome = GeneratedColumn<String>(
    'prodotto_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prezzoUnitarioMeta = const VerificationMeta(
    'prezzoUnitario',
  );
  @override
  late final GeneratedColumn<double> prezzoUnitario = GeneratedColumn<double>(
    'prezzo_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantitaMeta = const VerificationMeta(
    'quantita',
  );
  @override
  late final GeneratedColumn<int> quantita = GeneratedColumn<int>(
    'quantita',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordineId,
    prodottoId,
    prodottoNome,
    prezzoUnitario,
    quantita,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordini_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdiniItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ordine_id')) {
      context.handle(
        _ordineIdMeta,
        ordineId.isAcceptableOrUnknown(data['ordine_id']!, _ordineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordineIdMeta);
    }
    if (data.containsKey('prodotto_id')) {
      context.handle(
        _prodottoIdMeta,
        prodottoId.isAcceptableOrUnknown(data['prodotto_id']!, _prodottoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_prodottoIdMeta);
    }
    if (data.containsKey('prodotto_nome')) {
      context.handle(
        _prodottoNomeMeta,
        prodottoNome.isAcceptableOrUnknown(
          data['prodotto_nome']!,
          _prodottoNomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prodottoNomeMeta);
    }
    if (data.containsKey('prezzo_unitario')) {
      context.handle(
        _prezzoUnitarioMeta,
        prezzoUnitario.isAcceptableOrUnknown(
          data['prezzo_unitario']!,
          _prezzoUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prezzoUnitarioMeta);
    }
    if (data.containsKey('quantita')) {
      context.handle(
        _quantitaMeta,
        quantita.isAcceptableOrUnknown(data['quantita']!, _quantitaMeta),
      );
    } else if (isInserting) {
      context.missing(_quantitaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdiniItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdiniItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordine_id'],
      )!,
      prodottoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prodotto_id'],
      )!,
      prodottoNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prodotto_nome'],
      )!,
      prezzoUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prezzo_unitario'],
      )!,
      quantita: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantita'],
      )!,
    );
  }

  @override
  $OrdiniItemsTable createAlias(String alias) {
    return $OrdiniItemsTable(attachedDatabase, alias);
  }
}

class OrdiniItem extends DataClass implements Insertable<OrdiniItem> {
  final int id;
  final int ordineId;
  final int prodottoId;
  final String prodottoNome;
  final double prezzoUnitario;
  final int quantita;
  const OrdiniItem({
    required this.id,
    required this.ordineId,
    required this.prodottoId,
    required this.prodottoNome,
    required this.prezzoUnitario,
    required this.quantita,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ordine_id'] = Variable<int>(ordineId);
    map['prodotto_id'] = Variable<int>(prodottoId);
    map['prodotto_nome'] = Variable<String>(prodottoNome);
    map['prezzo_unitario'] = Variable<double>(prezzoUnitario);
    map['quantita'] = Variable<int>(quantita);
    return map;
  }

  OrdiniItemsCompanion toCompanion(bool nullToAbsent) {
    return OrdiniItemsCompanion(
      id: Value(id),
      ordineId: Value(ordineId),
      prodottoId: Value(prodottoId),
      prodottoNome: Value(prodottoNome),
      prezzoUnitario: Value(prezzoUnitario),
      quantita: Value(quantita),
    );
  }

  factory OrdiniItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdiniItem(
      id: serializer.fromJson<int>(json['id']),
      ordineId: serializer.fromJson<int>(json['ordineId']),
      prodottoId: serializer.fromJson<int>(json['prodottoId']),
      prodottoNome: serializer.fromJson<String>(json['prodottoNome']),
      prezzoUnitario: serializer.fromJson<double>(json['prezzoUnitario']),
      quantita: serializer.fromJson<int>(json['quantita']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordineId': serializer.toJson<int>(ordineId),
      'prodottoId': serializer.toJson<int>(prodottoId),
      'prodottoNome': serializer.toJson<String>(prodottoNome),
      'prezzoUnitario': serializer.toJson<double>(prezzoUnitario),
      'quantita': serializer.toJson<int>(quantita),
    };
  }

  OrdiniItem copyWith({
    int? id,
    int? ordineId,
    int? prodottoId,
    String? prodottoNome,
    double? prezzoUnitario,
    int? quantita,
  }) => OrdiniItem(
    id: id ?? this.id,
    ordineId: ordineId ?? this.ordineId,
    prodottoId: prodottoId ?? this.prodottoId,
    prodottoNome: prodottoNome ?? this.prodottoNome,
    prezzoUnitario: prezzoUnitario ?? this.prezzoUnitario,
    quantita: quantita ?? this.quantita,
  );
  OrdiniItem copyWithCompanion(OrdiniItemsCompanion data) {
    return OrdiniItem(
      id: data.id.present ? data.id.value : this.id,
      ordineId: data.ordineId.present ? data.ordineId.value : this.ordineId,
      prodottoId: data.prodottoId.present
          ? data.prodottoId.value
          : this.prodottoId,
      prodottoNome: data.prodottoNome.present
          ? data.prodottoNome.value
          : this.prodottoNome,
      prezzoUnitario: data.prezzoUnitario.present
          ? data.prezzoUnitario.value
          : this.prezzoUnitario,
      quantita: data.quantita.present ? data.quantita.value : this.quantita,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdiniItem(')
          ..write('id: $id, ')
          ..write('ordineId: $ordineId, ')
          ..write('prodottoId: $prodottoId, ')
          ..write('prodottoNome: $prodottoNome, ')
          ..write('prezzoUnitario: $prezzoUnitario, ')
          ..write('quantita: $quantita')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ordineId,
    prodottoId,
    prodottoNome,
    prezzoUnitario,
    quantita,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdiniItem &&
          other.id == this.id &&
          other.ordineId == this.ordineId &&
          other.prodottoId == this.prodottoId &&
          other.prodottoNome == this.prodottoNome &&
          other.prezzoUnitario == this.prezzoUnitario &&
          other.quantita == this.quantita);
}

class OrdiniItemsCompanion extends UpdateCompanion<OrdiniItem> {
  final Value<int> id;
  final Value<int> ordineId;
  final Value<int> prodottoId;
  final Value<String> prodottoNome;
  final Value<double> prezzoUnitario;
  final Value<int> quantita;
  const OrdiniItemsCompanion({
    this.id = const Value.absent(),
    this.ordineId = const Value.absent(),
    this.prodottoId = const Value.absent(),
    this.prodottoNome = const Value.absent(),
    this.prezzoUnitario = const Value.absent(),
    this.quantita = const Value.absent(),
  });
  OrdiniItemsCompanion.insert({
    this.id = const Value.absent(),
    required int ordineId,
    required int prodottoId,
    required String prodottoNome,
    required double prezzoUnitario,
    required int quantita,
  }) : ordineId = Value(ordineId),
       prodottoId = Value(prodottoId),
       prodottoNome = Value(prodottoNome),
       prezzoUnitario = Value(prezzoUnitario),
       quantita = Value(quantita);
  static Insertable<OrdiniItem> custom({
    Expression<int>? id,
    Expression<int>? ordineId,
    Expression<int>? prodottoId,
    Expression<String>? prodottoNome,
    Expression<double>? prezzoUnitario,
    Expression<int>? quantita,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordineId != null) 'ordine_id': ordineId,
      if (prodottoId != null) 'prodotto_id': prodottoId,
      if (prodottoNome != null) 'prodotto_nome': prodottoNome,
      if (prezzoUnitario != null) 'prezzo_unitario': prezzoUnitario,
      if (quantita != null) 'quantita': quantita,
    });
  }

  OrdiniItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? ordineId,
    Value<int>? prodottoId,
    Value<String>? prodottoNome,
    Value<double>? prezzoUnitario,
    Value<int>? quantita,
  }) {
    return OrdiniItemsCompanion(
      id: id ?? this.id,
      ordineId: ordineId ?? this.ordineId,
      prodottoId: prodottoId ?? this.prodottoId,
      prodottoNome: prodottoNome ?? this.prodottoNome,
      prezzoUnitario: prezzoUnitario ?? this.prezzoUnitario,
      quantita: quantita ?? this.quantita,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordineId.present) {
      map['ordine_id'] = Variable<int>(ordineId.value);
    }
    if (prodottoId.present) {
      map['prodotto_id'] = Variable<int>(prodottoId.value);
    }
    if (prodottoNome.present) {
      map['prodotto_nome'] = Variable<String>(prodottoNome.value);
    }
    if (prezzoUnitario.present) {
      map['prezzo_unitario'] = Variable<double>(prezzoUnitario.value);
    }
    if (quantita.present) {
      map['quantita'] = Variable<int>(quantita.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdiniItemsCompanion(')
          ..write('id: $id, ')
          ..write('ordineId: $ordineId, ')
          ..write('prodottoId: $prodottoId, ')
          ..write('prodottoNome: $prodottoNome, ')
          ..write('prezzoUnitario: $prezzoUnitario, ')
          ..write('quantita: $quantita')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SerateTable serate = $SerateTable(this);
  late final $AlimentiTable alimenti = $AlimentiTable(this);
  late final $SerataAlimentiTable serataAlimenti = $SerataAlimentiTable(this);
  late final $OrdiniTable ordini = $OrdiniTable(this);
  late final $OrdiniItemsTable ordiniItems = $OrdiniItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serate,
    alimenti,
    serataAlimenti,
    ordini,
    ordiniItems,
  ];
}

typedef $$SerateTableCreateCompanionBuilder =
    SerateCompanion Function({
      Value<int> id,
      required String titolo,
      required DateTime data,
    });
typedef $$SerateTableUpdateCompanionBuilder =
    SerateCompanion Function({
      Value<int> id,
      Value<String> titolo,
      Value<DateTime> data,
    });

class $$SerateTableFilterComposer
    extends Composer<_$AppDatabase, $SerateTable> {
  $$SerateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titolo => $composableBuilder(
    column: $table.titolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SerateTableOrderingComposer
    extends Composer<_$AppDatabase, $SerateTable> {
  $$SerateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titolo => $composableBuilder(
    column: $table.titolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SerateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SerateTable> {
  $$SerateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titolo =>
      $composableBuilder(column: $table.titolo, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$SerateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SerateTable,
          SerataData,
          $$SerateTableFilterComposer,
          $$SerateTableOrderingComposer,
          $$SerateTableAnnotationComposer,
          $$SerateTableCreateCompanionBuilder,
          $$SerateTableUpdateCompanionBuilder,
          (SerataData, BaseReferences<_$AppDatabase, $SerateTable, SerataData>),
          SerataData,
          PrefetchHooks Function()
        > {
  $$SerateTableTableManager(_$AppDatabase db, $SerateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SerateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SerateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SerateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titolo = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
              }) => SerateCompanion(id: id, titolo: titolo, data: data),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titolo,
                required DateTime data,
              }) => SerateCompanion.insert(id: id, titolo: titolo, data: data),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SerateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SerateTable,
      SerataData,
      $$SerateTableFilterComposer,
      $$SerateTableOrderingComposer,
      $$SerateTableAnnotationComposer,
      $$SerateTableCreateCompanionBuilder,
      $$SerateTableUpdateCompanionBuilder,
      (SerataData, BaseReferences<_$AppDatabase, $SerateTable, SerataData>),
      SerataData,
      PrefetchHooks Function()
    >;
typedef $$AlimentiTableCreateCompanionBuilder =
    AlimentiCompanion Function({
      Value<int> id,
      required String nome,
      required String categoria,
      required double prezzoDefault,
    });
typedef $$AlimentiTableUpdateCompanionBuilder =
    AlimentiCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> categoria,
      Value<double> prezzoDefault,
    });

class $$AlimentiTableFilterComposer
    extends Composer<_$AppDatabase, $AlimentiTable> {
  $$AlimentiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get prezzoDefault => $composableBuilder(
    column: $table.prezzoDefault,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlimentiTableOrderingComposer
    extends Composer<_$AppDatabase, $AlimentiTable> {
  $$AlimentiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get prezzoDefault => $composableBuilder(
    column: $table.prezzoDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlimentiTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlimentiTable> {
  $$AlimentiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<double> get prezzoDefault => $composableBuilder(
    column: $table.prezzoDefault,
    builder: (column) => column,
  );
}

class $$AlimentiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlimentiTable,
          AlimentoData,
          $$AlimentiTableFilterComposer,
          $$AlimentiTableOrderingComposer,
          $$AlimentiTableAnnotationComposer,
          $$AlimentiTableCreateCompanionBuilder,
          $$AlimentiTableUpdateCompanionBuilder,
          (
            AlimentoData,
            BaseReferences<_$AppDatabase, $AlimentiTable, AlimentoData>,
          ),
          AlimentoData,
          PrefetchHooks Function()
        > {
  $$AlimentiTableTableManager(_$AppDatabase db, $AlimentiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlimentiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlimentiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlimentiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<double> prezzoDefault = const Value.absent(),
              }) => AlimentiCompanion(
                id: id,
                nome: nome,
                categoria: categoria,
                prezzoDefault: prezzoDefault,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String categoria,
                required double prezzoDefault,
              }) => AlimentiCompanion.insert(
                id: id,
                nome: nome,
                categoria: categoria,
                prezzoDefault: prezzoDefault,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlimentiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlimentiTable,
      AlimentoData,
      $$AlimentiTableFilterComposer,
      $$AlimentiTableOrderingComposer,
      $$AlimentiTableAnnotationComposer,
      $$AlimentiTableCreateCompanionBuilder,
      $$AlimentiTableUpdateCompanionBuilder,
      (
        AlimentoData,
        BaseReferences<_$AppDatabase, $AlimentiTable, AlimentoData>,
      ),
      AlimentoData,
      PrefetchHooks Function()
    >;
typedef $$SerataAlimentiTableCreateCompanionBuilder =
    SerataAlimentiCompanion Function({
      Value<int> id,
      required int serataId,
      required int alimentoId,
      required double prezzo,
      Value<int> quantita,
    });
typedef $$SerataAlimentiTableUpdateCompanionBuilder =
    SerataAlimentiCompanion Function({
      Value<int> id,
      Value<int> serataId,
      Value<int> alimentoId,
      Value<double> prezzo,
      Value<int> quantita,
    });

class $$SerataAlimentiTableFilterComposer
    extends Composer<_$AppDatabase, $SerataAlimentiTable> {
  $$SerataAlimentiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serataId => $composableBuilder(
    column: $table.serataId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alimentoId => $composableBuilder(
    column: $table.alimentoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get prezzo => $composableBuilder(
    column: $table.prezzo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SerataAlimentiTableOrderingComposer
    extends Composer<_$AppDatabase, $SerataAlimentiTable> {
  $$SerataAlimentiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serataId => $composableBuilder(
    column: $table.serataId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alimentoId => $composableBuilder(
    column: $table.alimentoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get prezzo => $composableBuilder(
    column: $table.prezzo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SerataAlimentiTableAnnotationComposer
    extends Composer<_$AppDatabase, $SerataAlimentiTable> {
  $$SerataAlimentiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serataId =>
      $composableBuilder(column: $table.serataId, builder: (column) => column);

  GeneratedColumn<int> get alimentoId => $composableBuilder(
    column: $table.alimentoId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get prezzo =>
      $composableBuilder(column: $table.prezzo, builder: (column) => column);

  GeneratedColumn<int> get quantita =>
      $composableBuilder(column: $table.quantita, builder: (column) => column);
}

class $$SerataAlimentiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SerataAlimentiTable,
          SerataAlimentoData,
          $$SerataAlimentiTableFilterComposer,
          $$SerataAlimentiTableOrderingComposer,
          $$SerataAlimentiTableAnnotationComposer,
          $$SerataAlimentiTableCreateCompanionBuilder,
          $$SerataAlimentiTableUpdateCompanionBuilder,
          (
            SerataAlimentoData,
            BaseReferences<
              _$AppDatabase,
              $SerataAlimentiTable,
              SerataAlimentoData
            >,
          ),
          SerataAlimentoData,
          PrefetchHooks Function()
        > {
  $$SerataAlimentiTableTableManager(
    _$AppDatabase db,
    $SerataAlimentiTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SerataAlimentiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SerataAlimentiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SerataAlimentiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> serataId = const Value.absent(),
                Value<int> alimentoId = const Value.absent(),
                Value<double> prezzo = const Value.absent(),
                Value<int> quantita = const Value.absent(),
              }) => SerataAlimentiCompanion(
                id: id,
                serataId: serataId,
                alimentoId: alimentoId,
                prezzo: prezzo,
                quantita: quantita,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serataId,
                required int alimentoId,
                required double prezzo,
                Value<int> quantita = const Value.absent(),
              }) => SerataAlimentiCompanion.insert(
                id: id,
                serataId: serataId,
                alimentoId: alimentoId,
                prezzo: prezzo,
                quantita: quantita,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SerataAlimentiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SerataAlimentiTable,
      SerataAlimentoData,
      $$SerataAlimentiTableFilterComposer,
      $$SerataAlimentiTableOrderingComposer,
      $$SerataAlimentiTableAnnotationComposer,
      $$SerataAlimentiTableCreateCompanionBuilder,
      $$SerataAlimentiTableUpdateCompanionBuilder,
      (
        SerataAlimentoData,
        BaseReferences<_$AppDatabase, $SerataAlimentiTable, SerataAlimentoData>,
      ),
      SerataAlimentoData,
      PrefetchHooks Function()
    >;
typedef $$OrdiniTableCreateCompanionBuilder =
    OrdiniCompanion Function({
      Value<int> id,
      required int serataId,
      Value<int> numero,
      required DateTime dataOra,
      required double totale,
    });
typedef $$OrdiniTableUpdateCompanionBuilder =
    OrdiniCompanion Function({
      Value<int> id,
      Value<int> serataId,
      Value<int> numero,
      Value<DateTime> dataOra,
      Value<double> totale,
    });

class $$OrdiniTableFilterComposer
    extends Composer<_$AppDatabase, $OrdiniTable> {
  $$OrdiniTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serataId => $composableBuilder(
    column: $table.serataId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataOra => $composableBuilder(
    column: $table.dataOra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totale => $composableBuilder(
    column: $table.totale,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdiniTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdiniTable> {
  $$OrdiniTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serataId => $composableBuilder(
    column: $table.serataId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataOra => $composableBuilder(
    column: $table.dataOra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totale => $composableBuilder(
    column: $table.totale,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdiniTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdiniTable> {
  $$OrdiniTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serataId =>
      $composableBuilder(column: $table.serataId, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<DateTime> get dataOra =>
      $composableBuilder(column: $table.dataOra, builder: (column) => column);

  GeneratedColumn<double> get totale =>
      $composableBuilder(column: $table.totale, builder: (column) => column);
}

class $$OrdiniTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdiniTable,
          OrdineData,
          $$OrdiniTableFilterComposer,
          $$OrdiniTableOrderingComposer,
          $$OrdiniTableAnnotationComposer,
          $$OrdiniTableCreateCompanionBuilder,
          $$OrdiniTableUpdateCompanionBuilder,
          (OrdineData, BaseReferences<_$AppDatabase, $OrdiniTable, OrdineData>),
          OrdineData,
          PrefetchHooks Function()
        > {
  $$OrdiniTableTableManager(_$AppDatabase db, $OrdiniTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdiniTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdiniTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdiniTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> serataId = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<DateTime> dataOra = const Value.absent(),
                Value<double> totale = const Value.absent(),
              }) => OrdiniCompanion(
                id: id,
                serataId: serataId,
                numero: numero,
                dataOra: dataOra,
                totale: totale,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serataId,
                Value<int> numero = const Value.absent(),
                required DateTime dataOra,
                required double totale,
              }) => OrdiniCompanion.insert(
                id: id,
                serataId: serataId,
                numero: numero,
                dataOra: dataOra,
                totale: totale,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdiniTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdiniTable,
      OrdineData,
      $$OrdiniTableFilterComposer,
      $$OrdiniTableOrderingComposer,
      $$OrdiniTableAnnotationComposer,
      $$OrdiniTableCreateCompanionBuilder,
      $$OrdiniTableUpdateCompanionBuilder,
      (OrdineData, BaseReferences<_$AppDatabase, $OrdiniTable, OrdineData>),
      OrdineData,
      PrefetchHooks Function()
    >;
typedef $$OrdiniItemsTableCreateCompanionBuilder =
    OrdiniItemsCompanion Function({
      Value<int> id,
      required int ordineId,
      required int prodottoId,
      required String prodottoNome,
      required double prezzoUnitario,
      required int quantita,
    });
typedef $$OrdiniItemsTableUpdateCompanionBuilder =
    OrdiniItemsCompanion Function({
      Value<int> id,
      Value<int> ordineId,
      Value<int> prodottoId,
      Value<String> prodottoNome,
      Value<double> prezzoUnitario,
      Value<int> quantita,
    });

class $$OrdiniItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrdiniItemsTable> {
  $$OrdiniItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordineId => $composableBuilder(
    column: $table.ordineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prodottoId => $composableBuilder(
    column: $table.prodottoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prodottoNome => $composableBuilder(
    column: $table.prodottoNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get prezzoUnitario => $composableBuilder(
    column: $table.prezzoUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdiniItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdiniItemsTable> {
  $$OrdiniItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordineId => $composableBuilder(
    column: $table.ordineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prodottoId => $composableBuilder(
    column: $table.prodottoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prodottoNome => $composableBuilder(
    column: $table.prodottoNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get prezzoUnitario => $composableBuilder(
    column: $table.prezzoUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdiniItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdiniItemsTable> {
  $$OrdiniItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ordineId =>
      $composableBuilder(column: $table.ordineId, builder: (column) => column);

  GeneratedColumn<int> get prodottoId => $composableBuilder(
    column: $table.prodottoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prodottoNome => $composableBuilder(
    column: $table.prodottoNome,
    builder: (column) => column,
  );

  GeneratedColumn<double> get prezzoUnitario => $composableBuilder(
    column: $table.prezzoUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantita =>
      $composableBuilder(column: $table.quantita, builder: (column) => column);
}

class $$OrdiniItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdiniItemsTable,
          OrdiniItem,
          $$OrdiniItemsTableFilterComposer,
          $$OrdiniItemsTableOrderingComposer,
          $$OrdiniItemsTableAnnotationComposer,
          $$OrdiniItemsTableCreateCompanionBuilder,
          $$OrdiniItemsTableUpdateCompanionBuilder,
          (
            OrdiniItem,
            BaseReferences<_$AppDatabase, $OrdiniItemsTable, OrdiniItem>,
          ),
          OrdiniItem,
          PrefetchHooks Function()
        > {
  $$OrdiniItemsTableTableManager(_$AppDatabase db, $OrdiniItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdiniItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdiniItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdiniItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordineId = const Value.absent(),
                Value<int> prodottoId = const Value.absent(),
                Value<String> prodottoNome = const Value.absent(),
                Value<double> prezzoUnitario = const Value.absent(),
                Value<int> quantita = const Value.absent(),
              }) => OrdiniItemsCompanion(
                id: id,
                ordineId: ordineId,
                prodottoId: prodottoId,
                prodottoNome: prodottoNome,
                prezzoUnitario: prezzoUnitario,
                quantita: quantita,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordineId,
                required int prodottoId,
                required String prodottoNome,
                required double prezzoUnitario,
                required int quantita,
              }) => OrdiniItemsCompanion.insert(
                id: id,
                ordineId: ordineId,
                prodottoId: prodottoId,
                prodottoNome: prodottoNome,
                prezzoUnitario: prezzoUnitario,
                quantita: quantita,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdiniItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdiniItemsTable,
      OrdiniItem,
      $$OrdiniItemsTableFilterComposer,
      $$OrdiniItemsTableOrderingComposer,
      $$OrdiniItemsTableAnnotationComposer,
      $$OrdiniItemsTableCreateCompanionBuilder,
      $$OrdiniItemsTableUpdateCompanionBuilder,
      (
        OrdiniItem,
        BaseReferences<_$AppDatabase, $OrdiniItemsTable, OrdiniItem>,
      ),
      OrdiniItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SerateTableTableManager get serate =>
      $$SerateTableTableManager(_db, _db.serate);
  $$AlimentiTableTableManager get alimenti =>
      $$AlimentiTableTableManager(_db, _db.alimenti);
  $$SerataAlimentiTableTableManager get serataAlimenti =>
      $$SerataAlimentiTableTableManager(_db, _db.serataAlimenti);
  $$OrdiniTableTableManager get ordini =>
      $$OrdiniTableTableManager(_db, _db.ordini);
  $$OrdiniItemsTableTableManager get ordiniItems =>
      $$OrdiniItemsTableTableManager(_db, _db.ordiniItems);
}
