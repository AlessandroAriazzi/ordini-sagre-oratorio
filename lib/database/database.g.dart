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
  static const VerificationMeta _menuIdMeta = const VerificationMeta('menuId');
  @override
  late final GeneratedColumn<int> menuId = GeneratedColumn<int>(
    'menu_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, titolo, data, menuId];
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
    if (data.containsKey('menu_id')) {
      context.handle(
        _menuIdMeta,
        menuId.isAcceptableOrUnknown(data['menu_id']!, _menuIdMeta),
      );
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
      menuId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}menu_id'],
      ),
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
  final int? menuId;
  const SerataData({
    required this.id,
    required this.titolo,
    required this.data,
    this.menuId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titolo'] = Variable<String>(titolo);
    map['data'] = Variable<DateTime>(data);
    if (!nullToAbsent || menuId != null) {
      map['menu_id'] = Variable<int>(menuId);
    }
    return map;
  }

  SerateCompanion toCompanion(bool nullToAbsent) {
    return SerateCompanion(
      id: Value(id),
      titolo: Value(titolo),
      data: Value(data),
      menuId: menuId == null && nullToAbsent
          ? const Value.absent()
          : Value(menuId),
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
      menuId: serializer.fromJson<int?>(json['menuId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titolo': serializer.toJson<String>(titolo),
      'data': serializer.toJson<DateTime>(data),
      'menuId': serializer.toJson<int?>(menuId),
    };
  }

  SerataData copyWith({
    int? id,
    String? titolo,
    DateTime? data,
    Value<int?> menuId = const Value.absent(),
  }) => SerataData(
    id: id ?? this.id,
    titolo: titolo ?? this.titolo,
    data: data ?? this.data,
    menuId: menuId.present ? menuId.value : this.menuId,
  );
  SerataData copyWithCompanion(SerateCompanion data) {
    return SerataData(
      id: data.id.present ? data.id.value : this.id,
      titolo: data.titolo.present ? data.titolo.value : this.titolo,
      data: data.data.present ? data.data.value : this.data,
      menuId: data.menuId.present ? data.menuId.value : this.menuId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SerataData(')
          ..write('id: $id, ')
          ..write('titolo: $titolo, ')
          ..write('data: $data, ')
          ..write('menuId: $menuId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titolo, data, menuId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SerataData &&
          other.id == this.id &&
          other.titolo == this.titolo &&
          other.data == this.data &&
          other.menuId == this.menuId);
}

class SerateCompanion extends UpdateCompanion<SerataData> {
  final Value<int> id;
  final Value<String> titolo;
  final Value<DateTime> data;
  final Value<int?> menuId;
  const SerateCompanion({
    this.id = const Value.absent(),
    this.titolo = const Value.absent(),
    this.data = const Value.absent(),
    this.menuId = const Value.absent(),
  });
  SerateCompanion.insert({
    this.id = const Value.absent(),
    required String titolo,
    required DateTime data,
    this.menuId = const Value.absent(),
  }) : titolo = Value(titolo),
       data = Value(data);
  static Insertable<SerataData> custom({
    Expression<int>? id,
    Expression<String>? titolo,
    Expression<DateTime>? data,
    Expression<int>? menuId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titolo != null) 'titolo': titolo,
      if (data != null) 'data': data,
      if (menuId != null) 'menu_id': menuId,
    });
  }

  SerateCompanion copyWith({
    Value<int>? id,
    Value<String>? titolo,
    Value<DateTime>? data,
    Value<int?>? menuId,
  }) {
    return SerateCompanion(
      id: id ?? this.id,
      titolo: titolo ?? this.titolo,
      data: data ?? this.data,
      menuId: menuId ?? this.menuId,
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
    if (menuId.present) {
      map['menu_id'] = Variable<int>(menuId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SerateCompanion(')
          ..write('id: $id, ')
          ..write('titolo: $titolo, ')
          ..write('data: $data, ')
          ..write('menuId: $menuId')
          ..write(')'))
        .toString();
  }
}

class $MenusTable extends Menus with TableInfo<$MenusTable, MenuData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenusTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, nome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menus';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuData> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
    );
  }

  @override
  $MenusTable createAlias(String alias) {
    return $MenusTable(attachedDatabase, alias);
  }
}

class MenuData extends DataClass implements Insertable<MenuData> {
  final int id;
  final String nome;
  const MenuData({required this.id, required this.nome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    return map;
  }

  MenusCompanion toCompanion(bool nullToAbsent) {
    return MenusCompanion(id: Value(id), nome: Value(nome));
  }

  factory MenuData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
    };
  }

  MenuData copyWith({int? id, String? nome}) =>
      MenuData(id: id ?? this.id, nome: nome ?? this.nome);
  MenuData copyWithCompanion(MenusCompanion data) {
    return MenuData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuData(')
          ..write('id: $id, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuData && other.id == this.id && other.nome == this.nome);
}

class MenusCompanion extends UpdateCompanion<MenuData> {
  final Value<int> id;
  final Value<String> nome;
  const MenusCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
  });
  MenusCompanion.insert({this.id = const Value.absent(), required String nome})
    : nome = Value(nome);
  static Insertable<MenuData> custom({
    Expression<int>? id,
    Expression<String>? nome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
    });
  }

  MenusCompanion copyWith({Value<int>? id, Value<String>? nome}) {
    return MenusCompanion(id: id ?? this.id, nome: nome ?? this.nome);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenusCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }
}

class $ProdottiTable extends Prodotti
    with TableInfo<$ProdottiTable, ProdottoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdottiTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _prezzoMeta = const VerificationMeta('prezzo');
  @override
  late final GeneratedColumn<double> prezzo = GeneratedColumn<double>(
    'prezzo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _menuIdMeta = const VerificationMeta('menuId');
  @override
  late final GeneratedColumn<int> menuId = GeneratedColumn<int>(
    'menu_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    nome,
    prezzo,
    menuId,
    categoria,
    quantita,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prodotti';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProdottoData> instance, {
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
    if (data.containsKey('prezzo')) {
      context.handle(
        _prezzoMeta,
        prezzo.isAcceptableOrUnknown(data['prezzo']!, _prezzoMeta),
      );
    } else if (isInserting) {
      context.missing(_prezzoMeta);
    }
    if (data.containsKey('menu_id')) {
      context.handle(
        _menuIdMeta,
        menuId.isAcceptableOrUnknown(data['menu_id']!, _menuIdMeta),
      );
    } else if (isInserting) {
      context.missing(_menuIdMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
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
  ProdottoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProdottoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      prezzo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prezzo'],
      )!,
      menuId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}menu_id'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      quantita: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantita'],
      )!,
    );
  }

  @override
  $ProdottiTable createAlias(String alias) {
    return $ProdottiTable(attachedDatabase, alias);
  }
}

class ProdottoData extends DataClass implements Insertable<ProdottoData> {
  final int id;
  final String nome;
  final double prezzo;
  final int menuId;
  final String categoria;
  final int quantita;
  const ProdottoData({
    required this.id,
    required this.nome,
    required this.prezzo,
    required this.menuId,
    required this.categoria,
    required this.quantita,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['prezzo'] = Variable<double>(prezzo);
    map['menu_id'] = Variable<int>(menuId);
    map['categoria'] = Variable<String>(categoria);
    map['quantita'] = Variable<int>(quantita);
    return map;
  }

  ProdottiCompanion toCompanion(bool nullToAbsent) {
    return ProdottiCompanion(
      id: Value(id),
      nome: Value(nome),
      prezzo: Value(prezzo),
      menuId: Value(menuId),
      categoria: Value(categoria),
      quantita: Value(quantita),
    );
  }

  factory ProdottoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProdottoData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      prezzo: serializer.fromJson<double>(json['prezzo']),
      menuId: serializer.fromJson<int>(json['menuId']),
      categoria: serializer.fromJson<String>(json['categoria']),
      quantita: serializer.fromJson<int>(json['quantita']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'prezzo': serializer.toJson<double>(prezzo),
      'menuId': serializer.toJson<int>(menuId),
      'categoria': serializer.toJson<String>(categoria),
      'quantita': serializer.toJson<int>(quantita),
    };
  }

  ProdottoData copyWith({
    int? id,
    String? nome,
    double? prezzo,
    int? menuId,
    String? categoria,
    int? quantita,
  }) => ProdottoData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    prezzo: prezzo ?? this.prezzo,
    menuId: menuId ?? this.menuId,
    categoria: categoria ?? this.categoria,
    quantita: quantita ?? this.quantita,
  );
  ProdottoData copyWithCompanion(ProdottiCompanion data) {
    return ProdottoData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      prezzo: data.prezzo.present ? data.prezzo.value : this.prezzo,
      menuId: data.menuId.present ? data.menuId.value : this.menuId,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      quantita: data.quantita.present ? data.quantita.value : this.quantita,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdottoData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('prezzo: $prezzo, ')
          ..write('menuId: $menuId, ')
          ..write('categoria: $categoria, ')
          ..write('quantita: $quantita')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, prezzo, menuId, categoria, quantita);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdottoData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.prezzo == this.prezzo &&
          other.menuId == this.menuId &&
          other.categoria == this.categoria &&
          other.quantita == this.quantita);
}

class ProdottiCompanion extends UpdateCompanion<ProdottoData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<double> prezzo;
  final Value<int> menuId;
  final Value<String> categoria;
  final Value<int> quantita;
  const ProdottiCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.prezzo = const Value.absent(),
    this.menuId = const Value.absent(),
    this.categoria = const Value.absent(),
    this.quantita = const Value.absent(),
  });
  ProdottiCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required double prezzo,
    required int menuId,
    required String categoria,
    this.quantita = const Value.absent(),
  }) : nome = Value(nome),
       prezzo = Value(prezzo),
       menuId = Value(menuId),
       categoria = Value(categoria);
  static Insertable<ProdottoData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<double>? prezzo,
    Expression<int>? menuId,
    Expression<String>? categoria,
    Expression<int>? quantita,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (prezzo != null) 'prezzo': prezzo,
      if (menuId != null) 'menu_id': menuId,
      if (categoria != null) 'categoria': categoria,
      if (quantita != null) 'quantita': quantita,
    });
  }

  ProdottiCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<double>? prezzo,
    Value<int>? menuId,
    Value<String>? categoria,
    Value<int>? quantita,
  }) {
    return ProdottiCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      prezzo: prezzo ?? this.prezzo,
      menuId: menuId ?? this.menuId,
      categoria: categoria ?? this.categoria,
      quantita: quantita ?? this.quantita,
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
    if (prezzo.present) {
      map['prezzo'] = Variable<double>(prezzo.value);
    }
    if (menuId.present) {
      map['menu_id'] = Variable<int>(menuId.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (quantita.present) {
      map['quantita'] = Variable<int>(quantita.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdottiCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('prezzo: $prezzo, ')
          ..write('menuId: $menuId, ')
          ..write('categoria: $categoria, ')
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
  List<GeneratedColumn> get $columns => [id, serataId, dataOra, totale];
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
  final DateTime dataOra;
  final double totale;
  const OrdineData({
    required this.id,
    required this.serataId,
    required this.dataOra,
    required this.totale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serata_id'] = Variable<int>(serataId);
    map['data_ora'] = Variable<DateTime>(dataOra);
    map['totale'] = Variable<double>(totale);
    return map;
  }

  OrdiniCompanion toCompanion(bool nullToAbsent) {
    return OrdiniCompanion(
      id: Value(id),
      serataId: Value(serataId),
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
      'dataOra': serializer.toJson<DateTime>(dataOra),
      'totale': serializer.toJson<double>(totale),
    };
  }

  OrdineData copyWith({
    int? id,
    int? serataId,
    DateTime? dataOra,
    double? totale,
  }) => OrdineData(
    id: id ?? this.id,
    serataId: serataId ?? this.serataId,
    dataOra: dataOra ?? this.dataOra,
    totale: totale ?? this.totale,
  );
  OrdineData copyWithCompanion(OrdiniCompanion data) {
    return OrdineData(
      id: data.id.present ? data.id.value : this.id,
      serataId: data.serataId.present ? data.serataId.value : this.serataId,
      dataOra: data.dataOra.present ? data.dataOra.value : this.dataOra,
      totale: data.totale.present ? data.totale.value : this.totale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdineData(')
          ..write('id: $id, ')
          ..write('serataId: $serataId, ')
          ..write('dataOra: $dataOra, ')
          ..write('totale: $totale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serataId, dataOra, totale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdineData &&
          other.id == this.id &&
          other.serataId == this.serataId &&
          other.dataOra == this.dataOra &&
          other.totale == this.totale);
}

class OrdiniCompanion extends UpdateCompanion<OrdineData> {
  final Value<int> id;
  final Value<int> serataId;
  final Value<DateTime> dataOra;
  final Value<double> totale;
  const OrdiniCompanion({
    this.id = const Value.absent(),
    this.serataId = const Value.absent(),
    this.dataOra = const Value.absent(),
    this.totale = const Value.absent(),
  });
  OrdiniCompanion.insert({
    this.id = const Value.absent(),
    required int serataId,
    required DateTime dataOra,
    required double totale,
  }) : serataId = Value(serataId),
       dataOra = Value(dataOra),
       totale = Value(totale);
  static Insertable<OrdineData> custom({
    Expression<int>? id,
    Expression<int>? serataId,
    Expression<DateTime>? dataOra,
    Expression<double>? totale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serataId != null) 'serata_id': serataId,
      if (dataOra != null) 'data_ora': dataOra,
      if (totale != null) 'totale': totale,
    });
  }

  OrdiniCompanion copyWith({
    Value<int>? id,
    Value<int>? serataId,
    Value<DateTime>? dataOra,
    Value<double>? totale,
  }) {
    return OrdiniCompanion(
      id: id ?? this.id,
      serataId: serataId ?? this.serataId,
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
  late final $MenusTable menus = $MenusTable(this);
  late final $ProdottiTable prodotti = $ProdottiTable(this);
  late final $OrdiniTable ordini = $OrdiniTable(this);
  late final $OrdiniItemsTable ordiniItems = $OrdiniItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serate,
    menus,
    prodotti,
    ordini,
    ordiniItems,
  ];
}

typedef $$SerateTableCreateCompanionBuilder =
    SerateCompanion Function({
      Value<int> id,
      required String titolo,
      required DateTime data,
      Value<int?> menuId,
    });
typedef $$SerateTableUpdateCompanionBuilder =
    SerateCompanion Function({
      Value<int> id,
      Value<String> titolo,
      Value<DateTime> data,
      Value<int?> menuId,
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

  ColumnFilters<int> get menuId => $composableBuilder(
    column: $table.menuId,
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

  ColumnOrderings<int> get menuId => $composableBuilder(
    column: $table.menuId,
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

  GeneratedColumn<int> get menuId =>
      $composableBuilder(column: $table.menuId, builder: (column) => column);
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
                Value<int?> menuId = const Value.absent(),
              }) => SerateCompanion(
                id: id,
                titolo: titolo,
                data: data,
                menuId: menuId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titolo,
                required DateTime data,
                Value<int?> menuId = const Value.absent(),
              }) => SerateCompanion.insert(
                id: id,
                titolo: titolo,
                data: data,
                menuId: menuId,
              ),
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
typedef $$MenusTableCreateCompanionBuilder =
    MenusCompanion Function({Value<int> id, required String nome});
typedef $$MenusTableUpdateCompanionBuilder =
    MenusCompanion Function({Value<int> id, Value<String> nome});

class $$MenusTableFilterComposer extends Composer<_$AppDatabase, $MenusTable> {
  $$MenusTableFilterComposer({
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
}

class $$MenusTableOrderingComposer
    extends Composer<_$AppDatabase, $MenusTable> {
  $$MenusTableOrderingComposer({
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
}

class $$MenusTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenusTable> {
  $$MenusTableAnnotationComposer({
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
}

class $$MenusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MenusTable,
          MenuData,
          $$MenusTableFilterComposer,
          $$MenusTableOrderingComposer,
          $$MenusTableAnnotationComposer,
          $$MenusTableCreateCompanionBuilder,
          $$MenusTableUpdateCompanionBuilder,
          (MenuData, BaseReferences<_$AppDatabase, $MenusTable, MenuData>),
          MenuData,
          PrefetchHooks Function()
        > {
  $$MenusTableTableManager(_$AppDatabase db, $MenusTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
              }) => MenusCompanion(id: id, nome: nome),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String nome}) =>
                  MenusCompanion.insert(id: id, nome: nome),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MenusTable,
      MenuData,
      $$MenusTableFilterComposer,
      $$MenusTableOrderingComposer,
      $$MenusTableAnnotationComposer,
      $$MenusTableCreateCompanionBuilder,
      $$MenusTableUpdateCompanionBuilder,
      (MenuData, BaseReferences<_$AppDatabase, $MenusTable, MenuData>),
      MenuData,
      PrefetchHooks Function()
    >;
typedef $$ProdottiTableCreateCompanionBuilder =
    ProdottiCompanion Function({
      Value<int> id,
      required String nome,
      required double prezzo,
      required int menuId,
      required String categoria,
      Value<int> quantita,
    });
typedef $$ProdottiTableUpdateCompanionBuilder =
    ProdottiCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<double> prezzo,
      Value<int> menuId,
      Value<String> categoria,
      Value<int> quantita,
    });

class $$ProdottiTableFilterComposer
    extends Composer<_$AppDatabase, $ProdottiTable> {
  $$ProdottiTableFilterComposer({
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

  ColumnFilters<double> get prezzo => $composableBuilder(
    column: $table.prezzo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get menuId => $composableBuilder(
    column: $table.menuId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProdottiTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdottiTable> {
  $$ProdottiTableOrderingComposer({
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

  ColumnOrderings<double> get prezzo => $composableBuilder(
    column: $table.prezzo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get menuId => $composableBuilder(
    column: $table.menuId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantita => $composableBuilder(
    column: $table.quantita,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdottiTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdottiTable> {
  $$ProdottiTableAnnotationComposer({
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

  GeneratedColumn<double> get prezzo =>
      $composableBuilder(column: $table.prezzo, builder: (column) => column);

  GeneratedColumn<int> get menuId =>
      $composableBuilder(column: $table.menuId, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get quantita =>
      $composableBuilder(column: $table.quantita, builder: (column) => column);
}

class $$ProdottiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdottiTable,
          ProdottoData,
          $$ProdottiTableFilterComposer,
          $$ProdottiTableOrderingComposer,
          $$ProdottiTableAnnotationComposer,
          $$ProdottiTableCreateCompanionBuilder,
          $$ProdottiTableUpdateCompanionBuilder,
          (
            ProdottoData,
            BaseReferences<_$AppDatabase, $ProdottiTable, ProdottoData>,
          ),
          ProdottoData,
          PrefetchHooks Function()
        > {
  $$ProdottiTableTableManager(_$AppDatabase db, $ProdottiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdottiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdottiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdottiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<double> prezzo = const Value.absent(),
                Value<int> menuId = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<int> quantita = const Value.absent(),
              }) => ProdottiCompanion(
                id: id,
                nome: nome,
                prezzo: prezzo,
                menuId: menuId,
                categoria: categoria,
                quantita: quantita,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required double prezzo,
                required int menuId,
                required String categoria,
                Value<int> quantita = const Value.absent(),
              }) => ProdottiCompanion.insert(
                id: id,
                nome: nome,
                prezzo: prezzo,
                menuId: menuId,
                categoria: categoria,
                quantita: quantita,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProdottiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdottiTable,
      ProdottoData,
      $$ProdottiTableFilterComposer,
      $$ProdottiTableOrderingComposer,
      $$ProdottiTableAnnotationComposer,
      $$ProdottiTableCreateCompanionBuilder,
      $$ProdottiTableUpdateCompanionBuilder,
      (
        ProdottoData,
        BaseReferences<_$AppDatabase, $ProdottiTable, ProdottoData>,
      ),
      ProdottoData,
      PrefetchHooks Function()
    >;
typedef $$OrdiniTableCreateCompanionBuilder =
    OrdiniCompanion Function({
      Value<int> id,
      required int serataId,
      required DateTime dataOra,
      required double totale,
    });
typedef $$OrdiniTableUpdateCompanionBuilder =
    OrdiniCompanion Function({
      Value<int> id,
      Value<int> serataId,
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
                Value<DateTime> dataOra = const Value.absent(),
                Value<double> totale = const Value.absent(),
              }) => OrdiniCompanion(
                id: id,
                serataId: serataId,
                dataOra: dataOra,
                totale: totale,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serataId,
                required DateTime dataOra,
                required double totale,
              }) => OrdiniCompanion.insert(
                id: id,
                serataId: serataId,
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
  $$MenusTableTableManager get menus =>
      $$MenusTableTableManager(_db, _db.menus);
  $$ProdottiTableTableManager get prodotti =>
      $$ProdottiTableTableManager(_db, _db.prodotti);
  $$OrdiniTableTableManager get ordini =>
      $$OrdiniTableTableManager(_db, _db.ordini);
  $$OrdiniItemsTableTableManager get ordiniItems =>
      $$OrdiniItemsTableTableManager(_db, _db.ordiniItems);
}
