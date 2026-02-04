// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateToBaseMeta =
      const VerificationMeta('rateToBase');
  @override
  late final GeneratedColumn<double> rateToBase = GeneratedColumn<double>(
      'rate_to_base', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [code, name, symbol, rateToBase, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('rate_to_base')) {
      context.handle(
          _rateToBaseMeta,
          rateToBase.isAcceptableOrUnknown(
              data['rate_to_base']!, _rateToBaseMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      rateToBase: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate_to_base'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final String code;
  final String name;
  final String symbol;
  final double rateToBase;
  final DateTime lastUpdated;
  const Currency(
      {required this.code,
      required this.name,
      required this.symbol,
      required this.rateToBase,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    map['rate_to_base'] = Variable<double>(rateToBase);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      code: Value(code),
      name: Value(name),
      symbol: Value(symbol),
      rateToBase: Value(rateToBase),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      rateToBase: serializer.fromJson<double>(json['rateToBase']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'rateToBase': serializer.toJson<double>(rateToBase),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  Currency copyWith(
          {String? code,
          String? name,
          String? symbol,
          double? rateToBase,
          DateTime? lastUpdated}) =>
      Currency(
        code: code ?? this.code,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        rateToBase: rateToBase ?? this.rateToBase,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      rateToBase:
          data.rateToBase.present ? data.rateToBase.value : this.rateToBase,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('rateToBase: $rateToBase, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, name, symbol, rateToBase, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.code == this.code &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.rateToBase == this.rateToBase &&
          other.lastUpdated == this.lastUpdated);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<String> code;
  final Value<String> name;
  final Value<String> symbol;
  final Value<double> rateToBase;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.rateToBase = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    required String code,
    required String name,
    required String symbol,
    this.rateToBase = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        symbol = Value(symbol);
  static Insertable<Currency> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<double>? rateToBase,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (rateToBase != null) 'rate_to_base': rateToBase,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<String>? code,
      Value<String>? name,
      Value<String>? symbol,
      Value<double>? rateToBase,
      Value<DateTime>? lastUpdated,
      Value<int>? rowid}) {
    return CurrenciesCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      rateToBase: rateToBase ?? this.rateToBase,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (rateToBase.present) {
      map['rate_to_base'] = Variable<double>(rateToBase.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('rateToBase: $rateToBase, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _institutionMeta =
      const VerificationMeta('institution');
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
      'institution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, currencyCode, institution, balance, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
          _institutionMeta,
          institution.isAcceptableOrUnknown(
              data['institution']!, _institutionMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      institution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institution']),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final String type;
  final String currencyCode;
  final String? institution;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  const Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.currencyCode,
      this.institution,
      required this.balance,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    map['balance'] = Variable<double>(balance);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currencyCode: Value(currencyCode),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      balance: Value(balance),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      institution: serializer.fromJson<String?>(json['institution']),
      balance: serializer.fromJson<double>(json['balance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'institution': serializer.toJson<String?>(institution),
      'balance': serializer.toJson<double>(balance),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith(
          {String? id,
          String? name,
          String? type,
          String? currencyCode,
          Value<String?> institution = const Value.absent(),
          double? balance,
          bool? isActive,
          DateTime? createdAt}) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        currencyCode: currencyCode ?? this.currencyCode,
        institution: institution.present ? institution.value : this.institution,
        balance: balance ?? this.balance,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      balance: data.balance.present ? data.balance.value : this.balance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('institution: $institution, ')
          ..write('balance: $balance, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, type, currencyCode, institution, balance, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencyCode == this.currencyCode &&
          other.institution == this.institution &&
          other.balance == this.balance &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currencyCode;
  final Value<String?> institution;
  final Value<double> balance;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.institution = const Value.absent(),
    this.balance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String currencyCode,
    this.institution = const Value.absent(),
    this.balance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        currencyCode = Value(currencyCode);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currencyCode,
    Expression<String>? institution,
    Expression<double>? balance,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (institution != null) 'institution': institution,
      if (balance != null) 'balance': balance,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? currencyCode,
      Value<String?>? institution,
      Value<double>? balance,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      institution: institution ?? this.institution,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('institution: $institution, ')
          ..write('balance: $balance, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _budgetTypeMeta =
      const VerificationMeta('budgetType');
  @override
  late final GeneratedColumn<String> budgetType = GeneratedColumn<String>(
      'budget_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF007AFF));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, parentId, budgetType, icon, colorValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('budget_type')) {
      context.handle(
          _budgetTypeMeta,
          budgetType.isAcceptableOrUnknown(
              data['budget_type']!, _budgetTypeMeta));
    } else if (isInserting) {
      context.missing(_budgetTypeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      budgetType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}budget_type'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? parentId;
  final String budgetType;
  final String? icon;
  final int colorValue;
  const Category(
      {required this.id,
      required this.name,
      this.parentId,
      required this.budgetType,
      this.icon,
      required this.colorValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['budget_type'] = Variable<String>(budgetType);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      budgetType: Value(budgetType),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      colorValue: Value(colorValue),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      budgetType: serializer.fromJson<String>(json['budgetType']),
      icon: serializer.fromJson<String?>(json['icon']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'budgetType': serializer.toJson<String>(budgetType),
      'icon': serializer.toJson<String?>(icon),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  Category copyWith(
          {String? id,
          String? name,
          Value<String?> parentId = const Value.absent(),
          String? budgetType,
          Value<String?> icon = const Value.absent(),
          int? colorValue}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
        budgetType: budgetType ?? this.budgetType,
        icon: icon.present ? icon.value : this.icon,
        colorValue: colorValue ?? this.colorValue,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      budgetType:
          data.budgetType.present ? data.budgetType.value : this.budgetType,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('budgetType: $budgetType, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parentId, budgetType, icon, colorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.budgetType == this.budgetType &&
          other.icon == this.icon &&
          other.colorValue == this.colorValue);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String> budgetType;
  final Value<String?> icon;
  final Value<int> colorValue;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.budgetType = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    required String budgetType,
    this.icon = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        budgetType = Value(budgetType);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? budgetType,
    Expression<String>? icon,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (budgetType != null) 'budget_type': budgetType,
      if (icon != null) 'icon': icon,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? parentId,
      Value<String>? budgetType,
      Value<String?>? icon,
      Value<int>? colorValue,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      budgetType: budgetType ?? this.budgetType,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (budgetType.present) {
      map['budget_type'] = Variable<String>(budgetType.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('budgetType: $budgetType, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _amountSourceMeta =
      const VerificationMeta('amountSource');
  @override
  late final GeneratedColumn<double> amountSource = GeneratedColumn<double>(
      'amount_source', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _amountBaseMeta =
      const VerificationMeta('amountBase');
  @override
  late final GeneratedColumn<double> amountBase = GeneratedColumn<double>(
      'amount_base', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _merchantMeta =
      const VerificationMeta('merchant');
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
      'merchant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceStatementIdMeta =
      const VerificationMeta('sourceStatementId');
  @override
  late final GeneratedColumn<String> sourceStatementId =
      GeneratedColumn<String>('source_statement_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        categoryId,
        amountSource,
        currencyCode,
        amountBase,
        description,
        merchant,
        type,
        transactionDate,
        sourceStatementId,
        isRecurring,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('amount_source')) {
      context.handle(
          _amountSourceMeta,
          amountSource.isAcceptableOrUnknown(
              data['amount_source']!, _amountSourceMeta));
    } else if (isInserting) {
      context.missing(_amountSourceMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('amount_base')) {
      context.handle(
          _amountBaseMeta,
          amountBase.isAcceptableOrUnknown(
              data['amount_base']!, _amountBaseMeta));
    } else if (isInserting) {
      context.missing(_amountBaseMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(_merchantMeta,
          merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('source_statement_id')) {
      context.handle(
          _sourceStatementIdMeta,
          sourceStatementId.isAcceptableOrUnknown(
              data['source_statement_id']!, _sourceStatementIdMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      amountSource: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_source'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      amountBase: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_base'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      merchant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      sourceStatementId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_statement_id']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String accountId;
  final String? categoryId;
  final double amountSource;
  final String currencyCode;
  final double amountBase;
  final String description;
  final String? merchant;
  final String type;
  final DateTime transactionDate;
  final String? sourceStatementId;
  final bool isRecurring;
  final DateTime createdAt;
  const Transaction(
      {required this.id,
      required this.accountId,
      this.categoryId,
      required this.amountSource,
      required this.currencyCode,
      required this.amountBase,
      required this.description,
      this.merchant,
      required this.type,
      required this.transactionDate,
      this.sourceStatementId,
      required this.isRecurring,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['amount_source'] = Variable<double>(amountSource);
    map['currency_code'] = Variable<String>(currencyCode);
    map['amount_base'] = Variable<double>(amountBase);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    map['type'] = Variable<String>(type);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || sourceStatementId != null) {
      map['source_statement_id'] = Variable<String>(sourceStatementId);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountSource: Value(amountSource),
      currencyCode: Value(currencyCode),
      amountBase: Value(amountBase),
      description: Value(description),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      type: Value(type),
      transactionDate: Value(transactionDate),
      sourceStatementId: sourceStatementId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceStatementId),
      isRecurring: Value(isRecurring),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      amountSource: serializer.fromJson<double>(json['amountSource']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      amountBase: serializer.fromJson<double>(json['amountBase']),
      description: serializer.fromJson<String>(json['description']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      type: serializer.fromJson<String>(json['type']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      sourceStatementId:
          serializer.fromJson<String?>(json['sourceStatementId']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'amountSource': serializer.toJson<double>(amountSource),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'amountBase': serializer.toJson<double>(amountBase),
      'description': serializer.toJson<String>(description),
      'merchant': serializer.toJson<String?>(merchant),
      'type': serializer.toJson<String>(type),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'sourceStatementId': serializer.toJson<String?>(sourceStatementId),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith(
          {String? id,
          String? accountId,
          Value<String?> categoryId = const Value.absent(),
          double? amountSource,
          String? currencyCode,
          double? amountBase,
          String? description,
          Value<String?> merchant = const Value.absent(),
          String? type,
          DateTime? transactionDate,
          Value<String?> sourceStatementId = const Value.absent(),
          bool? isRecurring,
          DateTime? createdAt}) =>
      Transaction(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        amountSource: amountSource ?? this.amountSource,
        currencyCode: currencyCode ?? this.currencyCode,
        amountBase: amountBase ?? this.amountBase,
        description: description ?? this.description,
        merchant: merchant.present ? merchant.value : this.merchant,
        type: type ?? this.type,
        transactionDate: transactionDate ?? this.transactionDate,
        sourceStatementId: sourceStatementId.present
            ? sourceStatementId.value
            : this.sourceStatementId,
        isRecurring: isRecurring ?? this.isRecurring,
        createdAt: createdAt ?? this.createdAt,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      amountSource: data.amountSource.present
          ? data.amountSource.value
          : this.amountSource,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      amountBase:
          data.amountBase.present ? data.amountBase.value : this.amountBase,
      description:
          data.description.present ? data.description.value : this.description,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      type: data.type.present ? data.type.value : this.type,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      sourceStatementId: data.sourceStatementId.present
          ? data.sourceStatementId.value
          : this.sourceStatementId,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountSource: $amountSource, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('amountBase: $amountBase, ')
          ..write('description: $description, ')
          ..write('merchant: $merchant, ')
          ..write('type: $type, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('sourceStatementId: $sourceStatementId, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      categoryId,
      amountSource,
      currencyCode,
      amountBase,
      description,
      merchant,
      type,
      transactionDate,
      sourceStatementId,
      isRecurring,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.amountSource == this.amountSource &&
          other.currencyCode == this.currencyCode &&
          other.amountBase == this.amountBase &&
          other.description == this.description &&
          other.merchant == this.merchant &&
          other.type == this.type &&
          other.transactionDate == this.transactionDate &&
          other.sourceStatementId == this.sourceStatementId &&
          other.isRecurring == this.isRecurring &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String?> categoryId;
  final Value<double> amountSource;
  final Value<String> currencyCode;
  final Value<double> amountBase;
  final Value<String> description;
  final Value<String?> merchant;
  final Value<String> type;
  final Value<DateTime> transactionDate;
  final Value<String?> sourceStatementId;
  final Value<bool> isRecurring;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountSource = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.amountBase = const Value.absent(),
    this.description = const Value.absent(),
    this.merchant = const Value.absent(),
    this.type = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.sourceStatementId = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String accountId,
    this.categoryId = const Value.absent(),
    required double amountSource,
    required String currencyCode,
    required double amountBase,
    required String description,
    this.merchant = const Value.absent(),
    required String type,
    required DateTime transactionDate,
    this.sourceStatementId = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        amountSource = Value(amountSource),
        currencyCode = Value(currencyCode),
        amountBase = Value(amountBase),
        description = Value(description),
        type = Value(type),
        transactionDate = Value(transactionDate);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<double>? amountSource,
    Expression<String>? currencyCode,
    Expression<double>? amountBase,
    Expression<String>? description,
    Expression<String>? merchant,
    Expression<String>? type,
    Expression<DateTime>? transactionDate,
    Expression<String>? sourceStatementId,
    Expression<bool>? isRecurring,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (amountSource != null) 'amount_source': amountSource,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (amountBase != null) 'amount_base': amountBase,
      if (description != null) 'description': description,
      if (merchant != null) 'merchant': merchant,
      if (type != null) 'type': type,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (sourceStatementId != null) 'source_statement_id': sourceStatementId,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String?>? categoryId,
      Value<double>? amountSource,
      Value<String>? currencyCode,
      Value<double>? amountBase,
      Value<String>? description,
      Value<String?>? merchant,
      Value<String>? type,
      Value<DateTime>? transactionDate,
      Value<String?>? sourceStatementId,
      Value<bool>? isRecurring,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amountSource: amountSource ?? this.amountSource,
      currencyCode: currencyCode ?? this.currencyCode,
      amountBase: amountBase ?? this.amountBase,
      description: description ?? this.description,
      merchant: merchant ?? this.merchant,
      type: type ?? this.type,
      transactionDate: transactionDate ?? this.transactionDate,
      sourceStatementId: sourceStatementId ?? this.sourceStatementId,
      isRecurring: isRecurring ?? this.isRecurring,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountSource.present) {
      map['amount_source'] = Variable<double>(amountSource.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (amountBase.present) {
      map['amount_base'] = Variable<double>(amountBase.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (sourceStatementId.present) {
      map['source_statement_id'] = Variable<String>(sourceStatementId.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountSource: $amountSource, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('amountBase: $amountBase, ')
          ..write('description: $description, ')
          ..write('merchant: $merchant, ')
          ..write('type: $type, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('sourceStatementId: $sourceStatementId, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _purchaseValueMeta =
      const VerificationMeta('purchaseValue');
  @override
  late final GeneratedColumn<double> purchaseValue = GeneratedColumn<double>(
      'purchase_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentValueMeta =
      const VerificationMeta('currentValue');
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
      'current_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _geographyMeta =
      const VerificationMeta('geography');
  @override
  late final GeneratedColumn<String> geography = GeneratedColumn<String>(
      'geography', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isLiquidMeta =
      const VerificationMeta('isLiquid');
  @override
  late final GeneratedColumn<bool> isLiquid = GeneratedColumn<bool>(
      'is_liquid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_liquid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lockInMonthsMeta =
      const VerificationMeta('lockInMonths');
  @override
  late final GeneratedColumn<int> lockInMonths = GeneratedColumn<int>(
      'lock_in_months', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        currencyCode,
        purchaseValue,
        currentValue,
        purchaseDate,
        geography,
        isLiquid,
        lockInMonths,
        metadata,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(Insertable<Asset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('purchase_value')) {
      context.handle(
          _purchaseValueMeta,
          purchaseValue.isAcceptableOrUnknown(
              data['purchase_value']!, _purchaseValueMeta));
    } else if (isInserting) {
      context.missing(_purchaseValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
          _currentValueMeta,
          currentValue.isAcceptableOrUnknown(
              data['current_value']!, _currentValueMeta));
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('geography')) {
      context.handle(_geographyMeta,
          geography.isAcceptableOrUnknown(data['geography']!, _geographyMeta));
    } else if (isInserting) {
      context.missing(_geographyMeta);
    }
    if (data.containsKey('is_liquid')) {
      context.handle(_isLiquidMeta,
          isLiquid.isAcceptableOrUnknown(data['is_liquid']!, _isLiquidMeta));
    }
    if (data.containsKey('lock_in_months')) {
      context.handle(
          _lockInMonthsMeta,
          lockInMonths.isAcceptableOrUnknown(
              data['lock_in_months']!, _lockInMonthsMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      purchaseValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_value'])!,
      currentValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_value'])!,
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      geography: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geography'])!,
      isLiquid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_liquid'])!,
      lockInMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lock_in_months'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final String name;
  final String type;
  final String currencyCode;
  final double purchaseValue;
  final double currentValue;
  final DateTime purchaseDate;
  final String geography;
  final bool isLiquid;
  final int lockInMonths;
  final String? metadata;
  final DateTime createdAt;
  const Asset(
      {required this.id,
      required this.name,
      required this.type,
      required this.currencyCode,
      required this.purchaseValue,
      required this.currentValue,
      required this.purchaseDate,
      required this.geography,
      required this.isLiquid,
      required this.lockInMonths,
      this.metadata,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency_code'] = Variable<String>(currencyCode);
    map['purchase_value'] = Variable<double>(purchaseValue);
    map['current_value'] = Variable<double>(currentValue);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['geography'] = Variable<String>(geography);
    map['is_liquid'] = Variable<bool>(isLiquid);
    map['lock_in_months'] = Variable<int>(lockInMonths);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currencyCode: Value(currencyCode),
      purchaseValue: Value(purchaseValue),
      currentValue: Value(currentValue),
      purchaseDate: Value(purchaseDate),
      geography: Value(geography),
      isLiquid: Value(isLiquid),
      lockInMonths: Value(lockInMonths),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory Asset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      purchaseValue: serializer.fromJson<double>(json['purchaseValue']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      geography: serializer.fromJson<String>(json['geography']),
      isLiquid: serializer.fromJson<bool>(json['isLiquid']),
      lockInMonths: serializer.fromJson<int>(json['lockInMonths']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'purchaseValue': serializer.toJson<double>(purchaseValue),
      'currentValue': serializer.toJson<double>(currentValue),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'geography': serializer.toJson<String>(geography),
      'isLiquid': serializer.toJson<bool>(isLiquid),
      'lockInMonths': serializer.toJson<int>(lockInMonths),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Asset copyWith(
          {String? id,
          String? name,
          String? type,
          String? currencyCode,
          double? purchaseValue,
          double? currentValue,
          DateTime? purchaseDate,
          String? geography,
          bool? isLiquid,
          int? lockInMonths,
          Value<String?> metadata = const Value.absent(),
          DateTime? createdAt}) =>
      Asset(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        currencyCode: currencyCode ?? this.currencyCode,
        purchaseValue: purchaseValue ?? this.purchaseValue,
        currentValue: currentValue ?? this.currentValue,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        geography: geography ?? this.geography,
        isLiquid: isLiquid ?? this.isLiquid,
        lockInMonths: lockInMonths ?? this.lockInMonths,
        metadata: metadata.present ? metadata.value : this.metadata,
        createdAt: createdAt ?? this.createdAt,
      );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      purchaseValue: data.purchaseValue.present
          ? data.purchaseValue.value
          : this.purchaseValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      geography: data.geography.present ? data.geography.value : this.geography,
      isLiquid: data.isLiquid.present ? data.isLiquid.value : this.isLiquid,
      lockInMonths: data.lockInMonths.present
          ? data.lockInMonths.value
          : this.lockInMonths,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('purchaseValue: $purchaseValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('geography: $geography, ')
          ..write('isLiquid: $isLiquid, ')
          ..write('lockInMonths: $lockInMonths, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      currencyCode,
      purchaseValue,
      currentValue,
      purchaseDate,
      geography,
      isLiquid,
      lockInMonths,
      metadata,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencyCode == this.currencyCode &&
          other.purchaseValue == this.purchaseValue &&
          other.currentValue == this.currentValue &&
          other.purchaseDate == this.purchaseDate &&
          other.geography == this.geography &&
          other.isLiquid == this.isLiquid &&
          other.lockInMonths == this.lockInMonths &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currencyCode;
  final Value<double> purchaseValue;
  final Value<double> currentValue;
  final Value<DateTime> purchaseDate;
  final Value<String> geography;
  final Value<bool> isLiquid;
  final Value<int> lockInMonths;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.purchaseValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.geography = const Value.absent(),
    this.isLiquid = const Value.absent(),
    this.lockInMonths = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String currencyCode,
    required double purchaseValue,
    required double currentValue,
    required DateTime purchaseDate,
    required String geography,
    this.isLiquid = const Value.absent(),
    this.lockInMonths = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        currencyCode = Value(currencyCode),
        purchaseValue = Value(purchaseValue),
        currentValue = Value(currentValue),
        purchaseDate = Value(purchaseDate),
        geography = Value(geography);
  static Insertable<Asset> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currencyCode,
    Expression<double>? purchaseValue,
    Expression<double>? currentValue,
    Expression<DateTime>? purchaseDate,
    Expression<String>? geography,
    Expression<bool>? isLiquid,
    Expression<int>? lockInMonths,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (purchaseValue != null) 'purchase_value': purchaseValue,
      if (currentValue != null) 'current_value': currentValue,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (geography != null) 'geography': geography,
      if (isLiquid != null) 'is_liquid': isLiquid,
      if (lockInMonths != null) 'lock_in_months': lockInMonths,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? currencyCode,
      Value<double>? purchaseValue,
      Value<double>? currentValue,
      Value<DateTime>? purchaseDate,
      Value<String>? geography,
      Value<bool>? isLiquid,
      Value<int>? lockInMonths,
      Value<String?>? metadata,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      purchaseValue: purchaseValue ?? this.purchaseValue,
      currentValue: currentValue ?? this.currentValue,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      geography: geography ?? this.geography,
      isLiquid: isLiquid ?? this.isLiquid,
      lockInMonths: lockInMonths ?? this.lockInMonths,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (purchaseValue.present) {
      map['purchase_value'] = Variable<double>(purchaseValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (geography.present) {
      map['geography'] = Variable<String>(geography.value);
    }
    if (isLiquid.present) {
      map['is_liquid'] = Variable<bool>(isLiquid.value);
    }
    if (lockInMonths.present) {
      map['lock_in_months'] = Variable<int>(lockInMonths.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('purchaseValue: $purchaseValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('geography: $geography, ')
          ..write('isLiquid: $isLiquid, ')
          ..write('lockInMonths: $lockInMonths, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        currencyCode,
        targetAmount,
        targetDate,
        priority,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_amount'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String name;
  final String currencyCode;
  final double targetAmount;
  final DateTime targetDate;
  final String priority;
  final String status;
  final DateTime createdAt;
  const Goal(
      {required this.id,
      required this.name,
      required this.currencyCode,
      required this.targetAmount,
      required this.targetDate,
      required this.priority,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['currency_code'] = Variable<String>(currencyCode);
    map['target_amount'] = Variable<double>(targetAmount);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      name: Value(name),
      currencyCode: Value(currencyCode),
      targetAmount: Value(targetAmount),
      targetDate: Value(targetDate),
      priority: Value(priority),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Goal copyWith(
          {String? id,
          String? name,
          String? currencyCode,
          double? targetAmount,
          DateTime? targetDate,
          String? priority,
          String? status,
          DateTime? createdAt}) =>
      Goal(
        id: id ?? this.id,
        name: name ?? this.name,
        currencyCode: currencyCode ?? this.currencyCode,
        targetAmount: targetAmount ?? this.targetAmount,
        targetDate: targetDate ?? this.targetDate,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, currencyCode, targetAmount,
      targetDate, priority, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.name == this.name &&
          other.currencyCode == this.currencyCode &&
          other.targetAmount == this.targetAmount &&
          other.targetDate == this.targetDate &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> currencyCode;
  final Value<double> targetAmount;
  final Value<DateTime> targetDate;
  final Value<String> priority;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String name,
    required String currencyCode,
    required double targetAmount,
    required DateTime targetDate,
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        currencyCode = Value(currencyCode),
        targetAmount = Value(targetAmount),
        targetDate = Value(targetDate);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? currencyCode,
    Expression<double>? targetAmount,
    Expression<DateTime>? targetDate,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? currencyCode,
      Value<double>? targetAmount,
      Value<DateTime>? targetDate,
      Value<String>? priority,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return GoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalAssetMappingsTable extends GoalAssetMappings
    with TableInfo<$GoalAssetMappingsTable, GoalAssetMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalAssetMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES goals (id)'));
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _allocationPercentMeta =
      const VerificationMeta('allocationPercent');
  @override
  late final GeneratedColumn<double> allocationPercent =
      GeneratedColumn<double>('allocation_percent', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [goalId, assetId, allocationPercent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_asset_mappings';
  @override
  VerificationContext validateIntegrity(Insertable<GoalAssetMapping> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('allocation_percent')) {
      context.handle(
          _allocationPercentMeta,
          allocationPercent.isAcceptableOrUnknown(
              data['allocation_percent']!, _allocationPercentMeta));
    } else if (isInserting) {
      context.missing(_allocationPercentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goalId, assetId};
  @override
  GoalAssetMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalAssetMapping(
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      allocationPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}allocation_percent'])!,
    );
  }

  @override
  $GoalAssetMappingsTable createAlias(String alias) {
    return $GoalAssetMappingsTable(attachedDatabase, alias);
  }
}

class GoalAssetMapping extends DataClass
    implements Insertable<GoalAssetMapping> {
  final String goalId;
  final String assetId;
  final double allocationPercent;
  const GoalAssetMapping(
      {required this.goalId,
      required this.assetId,
      required this.allocationPercent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goal_id'] = Variable<String>(goalId);
    map['asset_id'] = Variable<String>(assetId);
    map['allocation_percent'] = Variable<double>(allocationPercent);
    return map;
  }

  GoalAssetMappingsCompanion toCompanion(bool nullToAbsent) {
    return GoalAssetMappingsCompanion(
      goalId: Value(goalId),
      assetId: Value(assetId),
      allocationPercent: Value(allocationPercent),
    );
  }

  factory GoalAssetMapping.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalAssetMapping(
      goalId: serializer.fromJson<String>(json['goalId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      allocationPercent: serializer.fromJson<double>(json['allocationPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goalId': serializer.toJson<String>(goalId),
      'assetId': serializer.toJson<String>(assetId),
      'allocationPercent': serializer.toJson<double>(allocationPercent),
    };
  }

  GoalAssetMapping copyWith(
          {String? goalId, String? assetId, double? allocationPercent}) =>
      GoalAssetMapping(
        goalId: goalId ?? this.goalId,
        assetId: assetId ?? this.assetId,
        allocationPercent: allocationPercent ?? this.allocationPercent,
      );
  GoalAssetMapping copyWithCompanion(GoalAssetMappingsCompanion data) {
    return GoalAssetMapping(
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      allocationPercent: data.allocationPercent.present
          ? data.allocationPercent.value
          : this.allocationPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalAssetMapping(')
          ..write('goalId: $goalId, ')
          ..write('assetId: $assetId, ')
          ..write('allocationPercent: $allocationPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goalId, assetId, allocationPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalAssetMapping &&
          other.goalId == this.goalId &&
          other.assetId == this.assetId &&
          other.allocationPercent == this.allocationPercent);
}

class GoalAssetMappingsCompanion extends UpdateCompanion<GoalAssetMapping> {
  final Value<String> goalId;
  final Value<String> assetId;
  final Value<double> allocationPercent;
  final Value<int> rowid;
  const GoalAssetMappingsCompanion({
    this.goalId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.allocationPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalAssetMappingsCompanion.insert({
    required String goalId,
    required String assetId,
    required double allocationPercent,
    this.rowid = const Value.absent(),
  })  : goalId = Value(goalId),
        assetId = Value(assetId),
        allocationPercent = Value(allocationPercent);
  static Insertable<GoalAssetMapping> custom({
    Expression<String>? goalId,
    Expression<String>? assetId,
    Expression<double>? allocationPercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goalId != null) 'goal_id': goalId,
      if (assetId != null) 'asset_id': assetId,
      if (allocationPercent != null) 'allocation_percent': allocationPercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalAssetMappingsCompanion copyWith(
      {Value<String>? goalId,
      Value<String>? assetId,
      Value<double>? allocationPercent,
      Value<int>? rowid}) {
    return GoalAssetMappingsCompanion(
      goalId: goalId ?? this.goalId,
      assetId: assetId ?? this.assetId,
      allocationPercent: allocationPercent ?? this.allocationPercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (allocationPercent.present) {
      map['allocation_percent'] = Variable<double>(allocationPercent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalAssetMappingsCompanion(')
          ..write('goalId: $goalId, ')
          ..write('assetId: $assetId, ')
          ..write('allocationPercent: $allocationPercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _limitAmountMeta =
      const VerificationMeta('limitAmount');
  @override
  late final GeneratedColumn<double> limitAmount = GeneratedColumn<double>(
      'limit_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, year, month, limitAmount, currencyCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
          _limitAmountMeta,
          limitAmount.isAcceptableOrUnknown(
              data['limit_amount']!, _limitAmountMeta));
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      limitAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}limit_amount'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String categoryId;
  final int year;
  final int month;
  final double limitAmount;
  final String currencyCode;
  const Budget(
      {required this.id,
      required this.categoryId,
      required this.year,
      required this.month,
      required this.limitAmount,
      required this.currencyCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['limit_amount'] = Variable<double>(limitAmount);
    map['currency_code'] = Variable<String>(currencyCode);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      year: Value(year),
      month: Value(month),
      limitAmount: Value(limitAmount),
      currencyCode: Value(currencyCode),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      limitAmount: serializer.fromJson<double>(json['limitAmount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'limitAmount': serializer.toJson<double>(limitAmount),
      'currencyCode': serializer.toJson<String>(currencyCode),
    };
  }

  Budget copyWith(
          {String? id,
          String? categoryId,
          int? year,
          int? month,
          double? limitAmount,
          String? currencyCode}) =>
      Budget(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        year: year ?? this.year,
        month: month ?? this.month,
        limitAmount: limitAmount ?? this.limitAmount,
        currencyCode: currencyCode ?? this.currencyCode,
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      limitAmount:
          data.limitAmount.present ? data.limitAmount.value : this.limitAmount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('currencyCode: $currencyCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, year, month, limitAmount, currencyCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.year == this.year &&
          other.month == this.month &&
          other.limitAmount == this.limitAmount &&
          other.currencyCode == this.currencyCode);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<int> year;
  final Value<int> month;
  final Value<double> limitAmount;
  final Value<String> currencyCode;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String categoryId,
    required int year,
    required int month,
    required double limitAmount,
    required String currencyCode,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        categoryId = Value(categoryId),
        year = Value(year),
        month = Value(month),
        limitAmount = Value(limitAmount),
        currencyCode = Value(currencyCode);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<double>? limitAmount,
    Expression<String>? currencyCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? categoryId,
      Value<int>? year,
      Value<int>? month,
      Value<double>? limitAmount,
      Value<String>? currencyCode,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      year: year ?? this.year,
      month: month ?? this.month,
      limitAmount: limitAmount ?? this.limitAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<double>(limitAmount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StatementSourcesTable extends StatementSources
    with TableInfo<$StatementSourcesTable, StatementSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatementSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderEmailMeta =
      const VerificationMeta('senderEmail');
  @override
  late final GeneratedColumn<String> senderEmail = GeneratedColumn<String>(
      'sender_email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountTypeMeta =
      const VerificationMeta('accountType');
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
      'account_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pdfPasswordMeta =
      const VerificationMeta('pdfPassword');
  @override
  late final GeneratedColumn<String> pdfPassword = GeneratedColumn<String>(
      'pdf_password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        senderEmail,
        bankName,
        accountType,
        pdfPassword,
        isActive,
        lastSyncAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'statement_sources';
  @override
  VerificationContext validateIntegrity(Insertable<StatementSource> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sender_email')) {
      context.handle(
          _senderEmailMeta,
          senderEmail.isAcceptableOrUnknown(
              data['sender_email']!, _senderEmailMeta));
    } else if (isInserting) {
      context.missing(_senderEmailMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
          _accountTypeMeta,
          accountType.isAcceptableOrUnknown(
              data['account_type']!, _accountTypeMeta));
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('pdf_password')) {
      context.handle(
          _pdfPasswordMeta,
          pdfPassword.isAcceptableOrUnknown(
              data['pdf_password']!, _pdfPasswordMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatementSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatementSource(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      senderEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_email'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name'])!,
      accountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_type'])!,
      pdfPassword: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pdf_password']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
    );
  }

  @override
  $StatementSourcesTable createAlias(String alias) {
    return $StatementSourcesTable(attachedDatabase, alias);
  }
}

class StatementSource extends DataClass implements Insertable<StatementSource> {
  final String id;
  final String senderEmail;
  final String bankName;
  final String accountType;
  final String? pdfPassword;
  final bool isActive;
  final DateTime? lastSyncAt;
  const StatementSource(
      {required this.id,
      required this.senderEmail,
      required this.bankName,
      required this.accountType,
      this.pdfPassword,
      required this.isActive,
      this.lastSyncAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sender_email'] = Variable<String>(senderEmail);
    map['bank_name'] = Variable<String>(bankName);
    map['account_type'] = Variable<String>(accountType);
    if (!nullToAbsent || pdfPassword != null) {
      map['pdf_password'] = Variable<String>(pdfPassword);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  StatementSourcesCompanion toCompanion(bool nullToAbsent) {
    return StatementSourcesCompanion(
      id: Value(id),
      senderEmail: Value(senderEmail),
      bankName: Value(bankName),
      accountType: Value(accountType),
      pdfPassword: pdfPassword == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfPassword),
      isActive: Value(isActive),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory StatementSource.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatementSource(
      id: serializer.fromJson<String>(json['id']),
      senderEmail: serializer.fromJson<String>(json['senderEmail']),
      bankName: serializer.fromJson<String>(json['bankName']),
      accountType: serializer.fromJson<String>(json['accountType']),
      pdfPassword: serializer.fromJson<String?>(json['pdfPassword']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'senderEmail': serializer.toJson<String>(senderEmail),
      'bankName': serializer.toJson<String>(bankName),
      'accountType': serializer.toJson<String>(accountType),
      'pdfPassword': serializer.toJson<String?>(pdfPassword),
      'isActive': serializer.toJson<bool>(isActive),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  StatementSource copyWith(
          {String? id,
          String? senderEmail,
          String? bankName,
          String? accountType,
          Value<String?> pdfPassword = const Value.absent(),
          bool? isActive,
          Value<DateTime?> lastSyncAt = const Value.absent()}) =>
      StatementSource(
        id: id ?? this.id,
        senderEmail: senderEmail ?? this.senderEmail,
        bankName: bankName ?? this.bankName,
        accountType: accountType ?? this.accountType,
        pdfPassword: pdfPassword.present ? pdfPassword.value : this.pdfPassword,
        isActive: isActive ?? this.isActive,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
      );
  StatementSource copyWithCompanion(StatementSourcesCompanion data) {
    return StatementSource(
      id: data.id.present ? data.id.value : this.id,
      senderEmail:
          data.senderEmail.present ? data.senderEmail.value : this.senderEmail,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      accountType:
          data.accountType.present ? data.accountType.value : this.accountType,
      pdfPassword:
          data.pdfPassword.present ? data.pdfPassword.value : this.pdfPassword,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatementSource(')
          ..write('id: $id, ')
          ..write('senderEmail: $senderEmail, ')
          ..write('bankName: $bankName, ')
          ..write('accountType: $accountType, ')
          ..write('pdfPassword: $pdfPassword, ')
          ..write('isActive: $isActive, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, senderEmail, bankName, accountType,
      pdfPassword, isActive, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatementSource &&
          other.id == this.id &&
          other.senderEmail == this.senderEmail &&
          other.bankName == this.bankName &&
          other.accountType == this.accountType &&
          other.pdfPassword == this.pdfPassword &&
          other.isActive == this.isActive &&
          other.lastSyncAt == this.lastSyncAt);
}

class StatementSourcesCompanion extends UpdateCompanion<StatementSource> {
  final Value<String> id;
  final Value<String> senderEmail;
  final Value<String> bankName;
  final Value<String> accountType;
  final Value<String?> pdfPassword;
  final Value<bool> isActive;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const StatementSourcesCompanion({
    this.id = const Value.absent(),
    this.senderEmail = const Value.absent(),
    this.bankName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.pdfPassword = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StatementSourcesCompanion.insert({
    required String id,
    required String senderEmail,
    required String bankName,
    required String accountType,
    this.pdfPassword = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        senderEmail = Value(senderEmail),
        bankName = Value(bankName),
        accountType = Value(accountType);
  static Insertable<StatementSource> custom({
    Expression<String>? id,
    Expression<String>? senderEmail,
    Expression<String>? bankName,
    Expression<String>? accountType,
    Expression<String>? pdfPassword,
    Expression<bool>? isActive,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderEmail != null) 'sender_email': senderEmail,
      if (bankName != null) 'bank_name': bankName,
      if (accountType != null) 'account_type': accountType,
      if (pdfPassword != null) 'pdf_password': pdfPassword,
      if (isActive != null) 'is_active': isActive,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StatementSourcesCompanion copyWith(
      {Value<String>? id,
      Value<String>? senderEmail,
      Value<String>? bankName,
      Value<String>? accountType,
      Value<String?>? pdfPassword,
      Value<bool>? isActive,
      Value<DateTime?>? lastSyncAt,
      Value<int>? rowid}) {
    return StatementSourcesCompanion(
      id: id ?? this.id,
      senderEmail: senderEmail ?? this.senderEmail,
      bankName: bankName ?? this.bankName,
      accountType: accountType ?? this.accountType,
      pdfPassword: pdfPassword ?? this.pdfPassword,
      isActive: isActive ?? this.isActive,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (senderEmail.present) {
      map['sender_email'] = Variable<String>(senderEmail.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (pdfPassword.present) {
      map['pdf_password'] = Variable<String>(pdfPassword.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatementSourcesCompanion(')
          ..write('id: $id, ')
          ..write('senderEmail: $senderEmail, ')
          ..write('bankName: $bankName, ')
          ..write('accountType: $accountType, ')
          ..write('pdfPassword: $pdfPassword, ')
          ..write('isActive: $isActive, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StatementQueueTable extends StatementQueue
    with TableInfo<$StatementQueueTable, StatementQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatementQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailIdMeta =
      const VerificationMeta('emailId');
  @override
  late final GeneratedColumn<String> emailId = GeneratedColumn<String>(
      'email_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES statement_sources (id)'));
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(50));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailDateMeta =
      const VerificationMeta('emailDate');
  @override
  late final GeneratedColumn<DateTime> emailDate = GeneratedColumn<DateTime>(
      'email_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _queuedAtMeta =
      const VerificationMeta('queuedAt');
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
      'queued_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _processedAtMeta =
      const VerificationMeta('processedAt');
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
      'processed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        emailId,
        sourceId,
        subject,
        status,
        priority,
        retryCount,
        errorMessage,
        emailDate,
        queuedAt,
        processedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'statement_queue';
  @override
  VerificationContext validateIntegrity(Insertable<StatementQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email_id')) {
      context.handle(_emailIdMeta,
          emailId.isAcceptableOrUnknown(data['email_id']!, _emailIdMeta));
    } else if (isInserting) {
      context.missing(_emailIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('email_date')) {
      context.handle(_emailDateMeta,
          emailDate.isAcceptableOrUnknown(data['email_date']!, _emailDateMeta));
    } else if (isInserting) {
      context.missing(_emailDateMeta);
    }
    if (data.containsKey('queued_at')) {
      context.handle(_queuedAtMeta,
          queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta));
    }
    if (data.containsKey('processed_at')) {
      context.handle(
          _processedAtMeta,
          processedAt.isAcceptableOrUnknown(
              data['processed_at']!, _processedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatementQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatementQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      emailId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id']),
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      emailDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}email_date'])!,
      queuedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}queued_at'])!,
      processedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}processed_at']),
    );
  }

  @override
  $StatementQueueTable createAlias(String alias) {
    return $StatementQueueTable(attachedDatabase, alias);
  }
}

class StatementQueueData extends DataClass
    implements Insertable<StatementQueueData> {
  final String id;
  final String emailId;
  final String? sourceId;
  final String subject;
  final String status;
  final int priority;
  final int retryCount;
  final String? errorMessage;
  final DateTime emailDate;
  final DateTime queuedAt;
  final DateTime? processedAt;
  const StatementQueueData(
      {required this.id,
      required this.emailId,
      this.sourceId,
      required this.subject,
      required this.status,
      required this.priority,
      required this.retryCount,
      this.errorMessage,
      required this.emailDate,
      required this.queuedAt,
      this.processedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email_id'] = Variable<String>(emailId);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['subject'] = Variable<String>(subject);
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<int>(priority);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['email_date'] = Variable<DateTime>(emailDate);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    return map;
  }

  StatementQueueCompanion toCompanion(bool nullToAbsent) {
    return StatementQueueCompanion(
      id: Value(id),
      emailId: Value(emailId),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      subject: Value(subject),
      status: Value(status),
      priority: Value(priority),
      retryCount: Value(retryCount),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      emailDate: Value(emailDate),
      queuedAt: Value(queuedAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
    );
  }

  factory StatementQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatementQueueData(
      id: serializer.fromJson<String>(json['id']),
      emailId: serializer.fromJson<String>(json['emailId']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      subject: serializer.fromJson<String>(json['subject']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<int>(json['priority']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      emailDate: serializer.fromJson<DateTime>(json['emailDate']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'emailId': serializer.toJson<String>(emailId),
      'sourceId': serializer.toJson<String?>(sourceId),
      'subject': serializer.toJson<String>(subject),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<int>(priority),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'emailDate': serializer.toJson<DateTime>(emailDate),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
    };
  }

  StatementQueueData copyWith(
          {String? id,
          String? emailId,
          Value<String?> sourceId = const Value.absent(),
          String? subject,
          String? status,
          int? priority,
          int? retryCount,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? emailDate,
          DateTime? queuedAt,
          Value<DateTime?> processedAt = const Value.absent()}) =>
      StatementQueueData(
        id: id ?? this.id,
        emailId: emailId ?? this.emailId,
        sourceId: sourceId.present ? sourceId.value : this.sourceId,
        subject: subject ?? this.subject,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        retryCount: retryCount ?? this.retryCount,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        emailDate: emailDate ?? this.emailDate,
        queuedAt: queuedAt ?? this.queuedAt,
        processedAt: processedAt.present ? processedAt.value : this.processedAt,
      );
  StatementQueueData copyWithCompanion(StatementQueueCompanion data) {
    return StatementQueueData(
      id: data.id.present ? data.id.value : this.id,
      emailId: data.emailId.present ? data.emailId.value : this.emailId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      subject: data.subject.present ? data.subject.value : this.subject,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      emailDate: data.emailDate.present ? data.emailDate.value : this.emailDate,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      processedAt:
          data.processedAt.present ? data.processedAt.value : this.processedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatementQueueData(')
          ..write('id: $id, ')
          ..write('emailId: $emailId, ')
          ..write('sourceId: $sourceId, ')
          ..write('subject: $subject, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('emailDate: $emailDate, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, emailId, sourceId, subject, status,
      priority, retryCount, errorMessage, emailDate, queuedAt, processedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatementQueueData &&
          other.id == this.id &&
          other.emailId == this.emailId &&
          other.sourceId == this.sourceId &&
          other.subject == this.subject &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage &&
          other.emailDate == this.emailDate &&
          other.queuedAt == this.queuedAt &&
          other.processedAt == this.processedAt);
}

class StatementQueueCompanion extends UpdateCompanion<StatementQueueData> {
  final Value<String> id;
  final Value<String> emailId;
  final Value<String?> sourceId;
  final Value<String> subject;
  final Value<String> status;
  final Value<int> priority;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<DateTime> emailDate;
  final Value<DateTime> queuedAt;
  final Value<DateTime?> processedAt;
  final Value<int> rowid;
  const StatementQueueCompanion({
    this.id = const Value.absent(),
    this.emailId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.subject = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.emailDate = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StatementQueueCompanion.insert({
    required String id,
    required String emailId,
    this.sourceId = const Value.absent(),
    required String subject,
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime emailDate,
    this.queuedAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        emailId = Value(emailId),
        subject = Value(subject),
        emailDate = Value(emailDate);
  static Insertable<StatementQueueData> custom({
    Expression<String>? id,
    Expression<String>? emailId,
    Expression<String>? sourceId,
    Expression<String>? subject,
    Expression<String>? status,
    Expression<int>? priority,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<DateTime>? emailDate,
    Expression<DateTime>? queuedAt,
    Expression<DateTime>? processedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emailId != null) 'email_id': emailId,
      if (sourceId != null) 'source_id': sourceId,
      if (subject != null) 'subject': subject,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (emailDate != null) 'email_date': emailDate,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (processedAt != null) 'processed_at': processedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StatementQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? emailId,
      Value<String?>? sourceId,
      Value<String>? subject,
      Value<String>? status,
      Value<int>? priority,
      Value<int>? retryCount,
      Value<String?>? errorMessage,
      Value<DateTime>? emailDate,
      Value<DateTime>? queuedAt,
      Value<DateTime?>? processedAt,
      Value<int>? rowid}) {
    return StatementQueueCompanion(
      id: id ?? this.id,
      emailId: emailId ?? this.emailId,
      sourceId: sourceId ?? this.sourceId,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      emailDate: emailDate ?? this.emailDate,
      queuedAt: queuedAt ?? this.queuedAt,
      processedAt: processedAt ?? this.processedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (emailId.present) {
      map['email_id'] = Variable<String>(emailId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (emailDate.present) {
      map['email_date'] = Variable<DateTime>(emailDate.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatementQueueCompanion(')
          ..write('id: $id, ')
          ..write('emailId: $emailId, ')
          ..write('sourceId: $sourceId, ')
          ..write('subject: $subject, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('emailDate: $emailDate, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) => AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LiabilitiesTable extends Liabilities
    with TableInfo<$LiabilitiesTable, Liability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiabilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _principalAmountMeta =
      const VerificationMeta('principalAmount');
  @override
  late final GeneratedColumn<double> principalAmount = GeneratedColumn<double>(
      'principal_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _outstandingAmountMeta =
      const VerificationMeta('outstandingAmount');
  @override
  late final GeneratedColumn<double> outstandingAmount =
      GeneratedColumn<double>('outstanding_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _interestRateMeta =
      const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
      'interest_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tenureMonthsMeta =
      const VerificationMeta('tenureMonths');
  @override
  late final GeneratedColumn<int> tenureMonths = GeneratedColumn<int>(
      'tenure_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _emiMeta = const VerificationMeta('emi');
  @override
  late final GeneratedColumn<double> emi = GeneratedColumn<double>(
      'emi', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _linkedAssetIdMeta =
      const VerificationMeta('linkedAssetId');
  @override
  late final GeneratedColumn<String> linkedAssetId = GeneratedColumn<String>(
      'linked_asset_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _institutionMeta =
      const VerificationMeta('institution');
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
      'institution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        currencyCode,
        principalAmount,
        outstandingAmount,
        interestRate,
        tenureMonths,
        emi,
        startDate,
        endDate,
        linkedAssetId,
        institution,
        isActive,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liabilities';
  @override
  VerificationContext validateIntegrity(Insertable<Liability> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('principal_amount')) {
      context.handle(
          _principalAmountMeta,
          principalAmount.isAcceptableOrUnknown(
              data['principal_amount']!, _principalAmountMeta));
    } else if (isInserting) {
      context.missing(_principalAmountMeta);
    }
    if (data.containsKey('outstanding_amount')) {
      context.handle(
          _outstandingAmountMeta,
          outstandingAmount.isAcceptableOrUnknown(
              data['outstanding_amount']!, _outstandingAmountMeta));
    } else if (isInserting) {
      context.missing(_outstandingAmountMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
          _interestRateMeta,
          interestRate.isAcceptableOrUnknown(
              data['interest_rate']!, _interestRateMeta));
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('tenure_months')) {
      context.handle(
          _tenureMonthsMeta,
          tenureMonths.isAcceptableOrUnknown(
              data['tenure_months']!, _tenureMonthsMeta));
    } else if (isInserting) {
      context.missing(_tenureMonthsMeta);
    }
    if (data.containsKey('emi')) {
      context.handle(
          _emiMeta, emi.isAcceptableOrUnknown(data['emi']!, _emiMeta));
    } else if (isInserting) {
      context.missing(_emiMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('linked_asset_id')) {
      context.handle(
          _linkedAssetIdMeta,
          linkedAssetId.isAcceptableOrUnknown(
              data['linked_asset_id']!, _linkedAssetIdMeta));
    }
    if (data.containsKey('institution')) {
      context.handle(
          _institutionMeta,
          institution.isAcceptableOrUnknown(
              data['institution']!, _institutionMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Liability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Liability(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      principalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}principal_amount'])!,
      outstandingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}outstanding_amount'])!,
      interestRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interest_rate'])!,
      tenureMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenure_months'])!,
      emi: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}emi'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      linkedAssetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}linked_asset_id']),
      institution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institution']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LiabilitiesTable createAlias(String alias) {
    return $LiabilitiesTable(attachedDatabase, alias);
  }
}

class Liability extends DataClass implements Insertable<Liability> {
  final String id;
  final String name;
  final String type;
  final String currencyCode;
  final double principalAmount;
  final double outstandingAmount;
  final double interestRate;
  final int tenureMonths;
  final double emi;
  final DateTime startDate;
  final DateTime? endDate;
  final String? linkedAssetId;
  final String? institution;
  final bool isActive;
  final DateTime createdAt;
  const Liability(
      {required this.id,
      required this.name,
      required this.type,
      required this.currencyCode,
      required this.principalAmount,
      required this.outstandingAmount,
      required this.interestRate,
      required this.tenureMonths,
      required this.emi,
      required this.startDate,
      this.endDate,
      this.linkedAssetId,
      this.institution,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency_code'] = Variable<String>(currencyCode);
    map['principal_amount'] = Variable<double>(principalAmount);
    map['outstanding_amount'] = Variable<double>(outstandingAmount);
    map['interest_rate'] = Variable<double>(interestRate);
    map['tenure_months'] = Variable<int>(tenureMonths);
    map['emi'] = Variable<double>(emi);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || linkedAssetId != null) {
      map['linked_asset_id'] = Variable<String>(linkedAssetId);
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LiabilitiesCompanion toCompanion(bool nullToAbsent) {
    return LiabilitiesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currencyCode: Value(currencyCode),
      principalAmount: Value(principalAmount),
      outstandingAmount: Value(outstandingAmount),
      interestRate: Value(interestRate),
      tenureMonths: Value(tenureMonths),
      emi: Value(emi),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      linkedAssetId: linkedAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAssetId),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Liability.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Liability(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      principalAmount: serializer.fromJson<double>(json['principalAmount']),
      outstandingAmount: serializer.fromJson<double>(json['outstandingAmount']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      tenureMonths: serializer.fromJson<int>(json['tenureMonths']),
      emi: serializer.fromJson<double>(json['emi']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      linkedAssetId: serializer.fromJson<String?>(json['linkedAssetId']),
      institution: serializer.fromJson<String?>(json['institution']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'principalAmount': serializer.toJson<double>(principalAmount),
      'outstandingAmount': serializer.toJson<double>(outstandingAmount),
      'interestRate': serializer.toJson<double>(interestRate),
      'tenureMonths': serializer.toJson<int>(tenureMonths),
      'emi': serializer.toJson<double>(emi),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'linkedAssetId': serializer.toJson<String?>(linkedAssetId),
      'institution': serializer.toJson<String?>(institution),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Liability copyWith(
          {String? id,
          String? name,
          String? type,
          String? currencyCode,
          double? principalAmount,
          double? outstandingAmount,
          double? interestRate,
          int? tenureMonths,
          double? emi,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          Value<String?> linkedAssetId = const Value.absent(),
          Value<String?> institution = const Value.absent(),
          bool? isActive,
          DateTime? createdAt}) =>
      Liability(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        currencyCode: currencyCode ?? this.currencyCode,
        principalAmount: principalAmount ?? this.principalAmount,
        outstandingAmount: outstandingAmount ?? this.outstandingAmount,
        interestRate: interestRate ?? this.interestRate,
        tenureMonths: tenureMonths ?? this.tenureMonths,
        emi: emi ?? this.emi,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        linkedAssetId:
            linkedAssetId.present ? linkedAssetId.value : this.linkedAssetId,
        institution: institution.present ? institution.value : this.institution,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Liability copyWithCompanion(LiabilitiesCompanion data) {
    return Liability(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      principalAmount: data.principalAmount.present
          ? data.principalAmount.value
          : this.principalAmount,
      outstandingAmount: data.outstandingAmount.present
          ? data.outstandingAmount.value
          : this.outstandingAmount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      tenureMonths: data.tenureMonths.present
          ? data.tenureMonths.value
          : this.tenureMonths,
      emi: data.emi.present ? data.emi.value : this.emi,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      linkedAssetId: data.linkedAssetId.present
          ? data.linkedAssetId.value
          : this.linkedAssetId,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Liability(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('outstandingAmount: $outstandingAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('emi: $emi, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('linkedAssetId: $linkedAssetId, ')
          ..write('institution: $institution, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      currencyCode,
      principalAmount,
      outstandingAmount,
      interestRate,
      tenureMonths,
      emi,
      startDate,
      endDate,
      linkedAssetId,
      institution,
      isActive,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Liability &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencyCode == this.currencyCode &&
          other.principalAmount == this.principalAmount &&
          other.outstandingAmount == this.outstandingAmount &&
          other.interestRate == this.interestRate &&
          other.tenureMonths == this.tenureMonths &&
          other.emi == this.emi &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.linkedAssetId == this.linkedAssetId &&
          other.institution == this.institution &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class LiabilitiesCompanion extends UpdateCompanion<Liability> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currencyCode;
  final Value<double> principalAmount;
  final Value<double> outstandingAmount;
  final Value<double> interestRate;
  final Value<int> tenureMonths;
  final Value<double> emi;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> linkedAssetId;
  final Value<String?> institution;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LiabilitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.outstandingAmount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.tenureMonths = const Value.absent(),
    this.emi = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.linkedAssetId = const Value.absent(),
    this.institution = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LiabilitiesCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String currencyCode,
    required double principalAmount,
    required double outstandingAmount,
    required double interestRate,
    required int tenureMonths,
    required double emi,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.linkedAssetId = const Value.absent(),
    this.institution = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        currencyCode = Value(currencyCode),
        principalAmount = Value(principalAmount),
        outstandingAmount = Value(outstandingAmount),
        interestRate = Value(interestRate),
        tenureMonths = Value(tenureMonths),
        emi = Value(emi),
        startDate = Value(startDate);
  static Insertable<Liability> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currencyCode,
    Expression<double>? principalAmount,
    Expression<double>? outstandingAmount,
    Expression<double>? interestRate,
    Expression<int>? tenureMonths,
    Expression<double>? emi,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? linkedAssetId,
    Expression<String>? institution,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (principalAmount != null) 'principal_amount': principalAmount,
      if (outstandingAmount != null) 'outstanding_amount': outstandingAmount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (tenureMonths != null) 'tenure_months': tenureMonths,
      if (emi != null) 'emi': emi,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (linkedAssetId != null) 'linked_asset_id': linkedAssetId,
      if (institution != null) 'institution': institution,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LiabilitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? currencyCode,
      Value<double>? principalAmount,
      Value<double>? outstandingAmount,
      Value<double>? interestRate,
      Value<int>? tenureMonths,
      Value<double>? emi,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<String?>? linkedAssetId,
      Value<String?>? institution,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return LiabilitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      principalAmount: principalAmount ?? this.principalAmount,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      interestRate: interestRate ?? this.interestRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      emi: emi ?? this.emi,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      linkedAssetId: linkedAssetId ?? this.linkedAssetId,
      institution: institution ?? this.institution,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (principalAmount.present) {
      map['principal_amount'] = Variable<double>(principalAmount.value);
    }
    if (outstandingAmount.present) {
      map['outstanding_amount'] = Variable<double>(outstandingAmount.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (tenureMonths.present) {
      map['tenure_months'] = Variable<int>(tenureMonths.value);
    }
    if (emi.present) {
      map['emi'] = Variable<double>(emi.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (linkedAssetId.present) {
      map['linked_asset_id'] = Variable<String>(linkedAssetId.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiabilitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('outstandingAmount: $outstandingAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('emi: $emi, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('linkedAssetId: $linkedAssetId, ')
          ..write('institution: $institution, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SipRecordsTable extends SipRecords
    with TableInfo<$SipRecordsTable, SipRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SipRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _dayOfMonthMeta =
      const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
      'day_of_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES goals (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        assetId,
        name,
        amount,
        currencyCode,
        dayOfMonth,
        frequency,
        startDate,
        endDate,
        isActive,
        goalId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sip_records';
  @override
  VerificationContext validateIntegrity(Insertable<SipRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
          _dayOfMonthMeta,
          dayOfMonth.isAcceptableOrUnknown(
              data['day_of_month']!, _dayOfMonthMeta));
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SipRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SipRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      dayOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_month'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SipRecordsTable createAlias(String alias) {
    return $SipRecordsTable(attachedDatabase, alias);
  }
}

class SipRecord extends DataClass implements Insertable<SipRecord> {
  final String id;
  final String assetId;
  final String name;
  final double amount;
  final String currencyCode;
  final int dayOfMonth;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? goalId;
  final DateTime createdAt;
  const SipRecord(
      {required this.id,
      required this.assetId,
      required this.name,
      required this.amount,
      required this.currencyCode,
      required this.dayOfMonth,
      required this.frequency,
      required this.startDate,
      this.endDate,
      required this.isActive,
      this.goalId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['currency_code'] = Variable<String>(currencyCode);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['frequency'] = Variable<String>(frequency);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SipRecordsCompanion toCompanion(bool nullToAbsent) {
    return SipRecordsCompanion(
      id: Value(id),
      assetId: Value(assetId),
      name: Value(name),
      amount: Value(amount),
      currencyCode: Value(currencyCode),
      dayOfMonth: Value(dayOfMonth),
      frequency: Value(frequency),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
      goalId:
          goalId == null && nullToAbsent ? const Value.absent() : Value(goalId),
      createdAt: Value(createdAt),
    );
  }

  factory SipRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SipRecord(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'frequency': serializer.toJson<String>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
      'goalId': serializer.toJson<String?>(goalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SipRecord copyWith(
          {String? id,
          String? assetId,
          String? name,
          double? amount,
          String? currencyCode,
          int? dayOfMonth,
          String? frequency,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          bool? isActive,
          Value<String?> goalId = const Value.absent(),
          DateTime? createdAt}) =>
      SipRecord(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        dayOfMonth: dayOfMonth ?? this.dayOfMonth,
        frequency: frequency ?? this.frequency,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        isActive: isActive ?? this.isActive,
        goalId: goalId.present ? goalId.value : this.goalId,
        createdAt: createdAt ?? this.createdAt,
      );
  SipRecord copyWithCompanion(SipRecordsCompanion data) {
    return SipRecord(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      dayOfMonth:
          data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SipRecord(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('goalId: $goalId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, name, amount, currencyCode,
      dayOfMonth, frequency, startDate, endDate, isActive, goalId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SipRecord &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.currencyCode == this.currencyCode &&
          other.dayOfMonth == this.dayOfMonth &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive &&
          other.goalId == this.goalId &&
          other.createdAt == this.createdAt);
}

class SipRecordsCompanion extends UpdateCompanion<SipRecord> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> currencyCode;
  final Value<int> dayOfMonth;
  final Value<String> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  final Value<String?> goalId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SipRecordsCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.goalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SipRecordsCompanion.insert({
    required String id,
    required String assetId,
    required String name,
    required double amount,
    required String currencyCode,
    required int dayOfMonth,
    this.frequency = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.goalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        assetId = Value(assetId),
        name = Value(name),
        amount = Value(amount),
        currencyCode = Value(currencyCode),
        dayOfMonth = Value(dayOfMonth),
        startDate = Value(startDate);
  static Insertable<SipRecord> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? currencyCode,
    Expression<int>? dayOfMonth,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
    Expression<String>? goalId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
      if (goalId != null) 'goal_id': goalId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SipRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? assetId,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? currencyCode,
      Value<int>? dayOfMonth,
      Value<String>? frequency,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? isActive,
      Value<String?>? goalId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SipRecordsCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      goalId: goalId ?? this.goalId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SipRecordsCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('goalId: $goalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DividendsTable extends Dividends
    with TableInfo<$DividendsTable, Dividend> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DividendsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _exDateMeta = const VerificationMeta('exDate');
  @override
  late final GeneratedColumn<DateTime> exDate = GeneratedColumn<DateTime>(
      'ex_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _paymentDateMeta =
      const VerificationMeta('paymentDate');
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
      'payment_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dividendTypeMeta =
      const VerificationMeta('dividendType');
  @override
  late final GeneratedColumn<String> dividendType = GeneratedColumn<String>(
      'dividend_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _isReinvestedMeta =
      const VerificationMeta('isReinvested');
  @override
  late final GeneratedColumn<bool> isReinvested = GeneratedColumn<bool>(
      'is_reinvested', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_reinvested" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        assetId,
        amount,
        currencyCode,
        exDate,
        paymentDate,
        dividendType,
        isReinvested,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dividends';
  @override
  VerificationContext validateIntegrity(Insertable<Dividend> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('ex_date')) {
      context.handle(_exDateMeta,
          exDate.isAcceptableOrUnknown(data['ex_date']!, _exDateMeta));
    } else if (isInserting) {
      context.missing(_exDateMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
          _paymentDateMeta,
          paymentDate.isAcceptableOrUnknown(
              data['payment_date']!, _paymentDateMeta));
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('dividend_type')) {
      context.handle(
          _dividendTypeMeta,
          dividendType.isAcceptableOrUnknown(
              data['dividend_type']!, _dividendTypeMeta));
    }
    if (data.containsKey('is_reinvested')) {
      context.handle(
          _isReinvestedMeta,
          isReinvested.isAcceptableOrUnknown(
              data['is_reinvested']!, _isReinvestedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dividend map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dividend(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      exDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ex_date'])!,
      paymentDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}payment_date'])!,
      dividendType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dividend_type'])!,
      isReinvested: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_reinvested'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DividendsTable createAlias(String alias) {
    return $DividendsTable(attachedDatabase, alias);
  }
}

class Dividend extends DataClass implements Insertable<Dividend> {
  final String id;
  final String assetId;
  final double amount;
  final String currencyCode;
  final DateTime exDate;
  final DateTime paymentDate;
  final String dividendType;
  final bool isReinvested;
  final DateTime createdAt;
  const Dividend(
      {required this.id,
      required this.assetId,
      required this.amount,
      required this.currencyCode,
      required this.exDate,
      required this.paymentDate,
      required this.dividendType,
      required this.isReinvested,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['amount'] = Variable<double>(amount);
    map['currency_code'] = Variable<String>(currencyCode);
    map['ex_date'] = Variable<DateTime>(exDate);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    map['dividend_type'] = Variable<String>(dividendType);
    map['is_reinvested'] = Variable<bool>(isReinvested);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DividendsCompanion toCompanion(bool nullToAbsent) {
    return DividendsCompanion(
      id: Value(id),
      assetId: Value(assetId),
      amount: Value(amount),
      currencyCode: Value(currencyCode),
      exDate: Value(exDate),
      paymentDate: Value(paymentDate),
      dividendType: Value(dividendType),
      isReinvested: Value(isReinvested),
      createdAt: Value(createdAt),
    );
  }

  factory Dividend.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dividend(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      amount: serializer.fromJson<double>(json['amount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      exDate: serializer.fromJson<DateTime>(json['exDate']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      dividendType: serializer.fromJson<String>(json['dividendType']),
      isReinvested: serializer.fromJson<bool>(json['isReinvested']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'amount': serializer.toJson<double>(amount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'exDate': serializer.toJson<DateTime>(exDate),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'dividendType': serializer.toJson<String>(dividendType),
      'isReinvested': serializer.toJson<bool>(isReinvested),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Dividend copyWith(
          {String? id,
          String? assetId,
          double? amount,
          String? currencyCode,
          DateTime? exDate,
          DateTime? paymentDate,
          String? dividendType,
          bool? isReinvested,
          DateTime? createdAt}) =>
      Dividend(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        exDate: exDate ?? this.exDate,
        paymentDate: paymentDate ?? this.paymentDate,
        dividendType: dividendType ?? this.dividendType,
        isReinvested: isReinvested ?? this.isReinvested,
        createdAt: createdAt ?? this.createdAt,
      );
  Dividend copyWithCompanion(DividendsCompanion data) {
    return Dividend(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      exDate: data.exDate.present ? data.exDate.value : this.exDate,
      paymentDate:
          data.paymentDate.present ? data.paymentDate.value : this.paymentDate,
      dividendType: data.dividendType.present
          ? data.dividendType.value
          : this.dividendType,
      isReinvested: data.isReinvested.present
          ? data.isReinvested.value
          : this.isReinvested,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dividend(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('exDate: $exDate, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('dividendType: $dividendType, ')
          ..write('isReinvested: $isReinvested, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, amount, currencyCode, exDate,
      paymentDate, dividendType, isReinvested, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dividend &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.amount == this.amount &&
          other.currencyCode == this.currencyCode &&
          other.exDate == this.exDate &&
          other.paymentDate == this.paymentDate &&
          other.dividendType == this.dividendType &&
          other.isReinvested == this.isReinvested &&
          other.createdAt == this.createdAt);
}

class DividendsCompanion extends UpdateCompanion<Dividend> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<double> amount;
  final Value<String> currencyCode;
  final Value<DateTime> exDate;
  final Value<DateTime> paymentDate;
  final Value<String> dividendType;
  final Value<bool> isReinvested;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DividendsCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.exDate = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.dividendType = const Value.absent(),
    this.isReinvested = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DividendsCompanion.insert({
    required String id,
    required String assetId,
    required double amount,
    required String currencyCode,
    required DateTime exDate,
    required DateTime paymentDate,
    this.dividendType = const Value.absent(),
    this.isReinvested = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        assetId = Value(assetId),
        amount = Value(amount),
        currencyCode = Value(currencyCode),
        exDate = Value(exDate),
        paymentDate = Value(paymentDate);
  static Insertable<Dividend> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<double>? amount,
    Expression<String>? currencyCode,
    Expression<DateTime>? exDate,
    Expression<DateTime>? paymentDate,
    Expression<String>? dividendType,
    Expression<bool>? isReinvested,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (exDate != null) 'ex_date': exDate,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (dividendType != null) 'dividend_type': dividendType,
      if (isReinvested != null) 'is_reinvested': isReinvested,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DividendsCompanion copyWith(
      {Value<String>? id,
      Value<String>? assetId,
      Value<double>? amount,
      Value<String>? currencyCode,
      Value<DateTime>? exDate,
      Value<DateTime>? paymentDate,
      Value<String>? dividendType,
      Value<bool>? isReinvested,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DividendsCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      exDate: exDate ?? this.exDate,
      paymentDate: paymentDate ?? this.paymentDate,
      dividendType: dividendType ?? this.dividendType,
      isReinvested: isReinvested ?? this.isReinvested,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (exDate.present) {
      map['ex_date'] = Variable<DateTime>(exDate.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (dividendType.present) {
      map['dividend_type'] = Variable<String>(dividendType.value);
    }
    if (isReinvested.present) {
      map['is_reinvested'] = Variable<bool>(isReinvested.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DividendsCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('exDate: $exDate, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('dividendType: $dividendType, ')
          ..write('isReinvested: $isReinvested, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PropertyExpensesTable extends PropertyExpenses
    with TableInfo<$PropertyExpensesTable, PropertyExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertyExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _expenseDateMeta =
      const VerificationMeta('expenseDate');
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
      'expense_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recurringDayMeta =
      const VerificationMeta('recurringDay');
  @override
  late final GeneratedColumn<int> recurringDay = GeneratedColumn<int>(
      'recurring_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        assetId,
        category,
        amount,
        currencyCode,
        expenseDate,
        description,
        isRecurring,
        recurringDay,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'property_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<PropertyExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
          _expenseDateMeta,
          expenseDate.isAcceptableOrUnknown(
              data['expense_date']!, _expenseDateMeta));
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurring_day')) {
      context.handle(
          _recurringDayMeta,
          recurringDay.isAcceptableOrUnknown(
              data['recurring_day']!, _recurringDayMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      expenseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expense_date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurringDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurring_day']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PropertyExpensesTable createAlias(String alias) {
    return $PropertyExpensesTable(attachedDatabase, alias);
  }
}

class PropertyExpense extends DataClass implements Insertable<PropertyExpense> {
  final String id;
  final String assetId;
  final String category;
  final double amount;
  final String currencyCode;
  final DateTime expenseDate;
  final String? description;
  final bool isRecurring;
  final int? recurringDay;
  final DateTime createdAt;
  const PropertyExpense(
      {required this.id,
      required this.assetId,
      required this.category,
      required this.amount,
      required this.currencyCode,
      required this.expenseDate,
      this.description,
      required this.isRecurring,
      this.recurringDay,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['currency_code'] = Variable<String>(currencyCode);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringDay != null) {
      map['recurring_day'] = Variable<int>(recurringDay);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PropertyExpensesCompanion toCompanion(bool nullToAbsent) {
    return PropertyExpensesCompanion(
      id: Value(id),
      assetId: Value(assetId),
      category: Value(category),
      amount: Value(amount),
      currencyCode: Value(currencyCode),
      expenseDate: Value(expenseDate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isRecurring: Value(isRecurring),
      recurringDay: recurringDay == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringDay),
      createdAt: Value(createdAt),
    );
  }

  factory PropertyExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyExpense(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      description: serializer.fromJson<String?>(json['description']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringDay: serializer.fromJson<int?>(json['recurringDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'description': serializer.toJson<String?>(description),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringDay': serializer.toJson<int?>(recurringDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PropertyExpense copyWith(
          {String? id,
          String? assetId,
          String? category,
          double? amount,
          String? currencyCode,
          DateTime? expenseDate,
          Value<String?> description = const Value.absent(),
          bool? isRecurring,
          Value<int?> recurringDay = const Value.absent(),
          DateTime? createdAt}) =>
      PropertyExpense(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        expenseDate: expenseDate ?? this.expenseDate,
        description: description.present ? description.value : this.description,
        isRecurring: isRecurring ?? this.isRecurring,
        recurringDay:
            recurringDay.present ? recurringDay.value : this.recurringDay,
        createdAt: createdAt ?? this.createdAt,
      );
  PropertyExpense copyWithCompanion(PropertyExpensesCompanion data) {
    return PropertyExpense(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      expenseDate:
          data.expenseDate.present ? data.expenseDate.value : this.expenseDate,
      description:
          data.description.present ? data.description.value : this.description,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurringDay: data.recurringDay.present
          ? data.recurringDay.value
          : this.recurringDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyExpense(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('description: $description, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringDay: $recurringDay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, category, amount, currencyCode,
      expenseDate, description, isRecurring, recurringDay, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyExpense &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.currencyCode == this.currencyCode &&
          other.expenseDate == this.expenseDate &&
          other.description == this.description &&
          other.isRecurring == this.isRecurring &&
          other.recurringDay == this.recurringDay &&
          other.createdAt == this.createdAt);
}

class PropertyExpensesCompanion extends UpdateCompanion<PropertyExpense> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<String> category;
  final Value<double> amount;
  final Value<String> currencyCode;
  final Value<DateTime> expenseDate;
  final Value<String?> description;
  final Value<bool> isRecurring;
  final Value<int?> recurringDay;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PropertyExpensesCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.description = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertyExpensesCompanion.insert({
    required String id,
    required String assetId,
    required String category,
    required double amount,
    required String currencyCode,
    required DateTime expenseDate,
    this.description = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        assetId = Value(assetId),
        category = Value(category),
        amount = Value(amount),
        currencyCode = Value(currencyCode),
        expenseDate = Value(expenseDate);
  static Insertable<PropertyExpense> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? currencyCode,
    Expression<DateTime>? expenseDate,
    Expression<String>? description,
    Expression<bool>? isRecurring,
    Expression<int>? recurringDay,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (description != null) 'description': description,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringDay != null) 'recurring_day': recurringDay,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertyExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? assetId,
      Value<String>? category,
      Value<double>? amount,
      Value<String>? currencyCode,
      Value<DateTime>? expenseDate,
      Value<String?>? description,
      Value<bool>? isRecurring,
      Value<int?>? recurringDay,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PropertyExpensesCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      expenseDate: expenseDate ?? this.expenseDate,
      description: description ?? this.description,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDay: recurringDay ?? this.recurringDay,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringDay.present) {
      map['recurring_day'] = Variable<int>(recurringDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertyExpensesCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('description: $description, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringDay: $recurringDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RentalIncomeTable extends RentalIncome
    with TableInfo<$RentalIncomeTable, RentalIncomeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RentalIncomeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (code)'));
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _tenantNameMeta =
      const VerificationMeta('tenantName');
  @override
  late final GeneratedColumn<String> tenantName = GeneratedColumn<String>(
      'tenant_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        assetId,
        amount,
        currencyCode,
        year,
        month,
        isPaid,
        tenantName,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rental_income';
  @override
  VerificationContext validateIntegrity(Insertable<RentalIncomeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('tenant_name')) {
      context.handle(
          _tenantNameMeta,
          tenantName.isAcceptableOrUnknown(
              data['tenant_name']!, _tenantNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RentalIncomeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RentalIncomeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      tenantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RentalIncomeTable createAlias(String alias) {
    return $RentalIncomeTable(attachedDatabase, alias);
  }
}

class RentalIncomeData extends DataClass
    implements Insertable<RentalIncomeData> {
  final String id;
  final String assetId;
  final double amount;
  final String currencyCode;
  final int year;
  final int month;
  final bool isPaid;
  final String? tenantName;
  final DateTime createdAt;
  const RentalIncomeData(
      {required this.id,
      required this.assetId,
      required this.amount,
      required this.currencyCode,
      required this.year,
      required this.month,
      required this.isPaid,
      this.tenantName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['amount'] = Variable<double>(amount);
    map['currency_code'] = Variable<String>(currencyCode);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || tenantName != null) {
      map['tenant_name'] = Variable<String>(tenantName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RentalIncomeCompanion toCompanion(bool nullToAbsent) {
    return RentalIncomeCompanion(
      id: Value(id),
      assetId: Value(assetId),
      amount: Value(amount),
      currencyCode: Value(currencyCode),
      year: Value(year),
      month: Value(month),
      isPaid: Value(isPaid),
      tenantName: tenantName == null && nullToAbsent
          ? const Value.absent()
          : Value(tenantName),
      createdAt: Value(createdAt),
    );
  }

  factory RentalIncomeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RentalIncomeData(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      amount: serializer.fromJson<double>(json['amount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      tenantName: serializer.fromJson<String?>(json['tenantName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'amount': serializer.toJson<double>(amount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'isPaid': serializer.toJson<bool>(isPaid),
      'tenantName': serializer.toJson<String?>(tenantName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RentalIncomeData copyWith(
          {String? id,
          String? assetId,
          double? amount,
          String? currencyCode,
          int? year,
          int? month,
          bool? isPaid,
          Value<String?> tenantName = const Value.absent(),
          DateTime? createdAt}) =>
      RentalIncomeData(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        amount: amount ?? this.amount,
        currencyCode: currencyCode ?? this.currencyCode,
        year: year ?? this.year,
        month: month ?? this.month,
        isPaid: isPaid ?? this.isPaid,
        tenantName: tenantName.present ? tenantName.value : this.tenantName,
        createdAt: createdAt ?? this.createdAt,
      );
  RentalIncomeData copyWithCompanion(RentalIncomeCompanion data) {
    return RentalIncomeData(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      tenantName:
          data.tenantName.present ? data.tenantName.value : this.tenantName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RentalIncomeData(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('isPaid: $isPaid, ')
          ..write('tenantName: $tenantName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, amount, currencyCode, year,
      month, isPaid, tenantName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RentalIncomeData &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.amount == this.amount &&
          other.currencyCode == this.currencyCode &&
          other.year == this.year &&
          other.month == this.month &&
          other.isPaid == this.isPaid &&
          other.tenantName == this.tenantName &&
          other.createdAt == this.createdAt);
}

class RentalIncomeCompanion extends UpdateCompanion<RentalIncomeData> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<double> amount;
  final Value<String> currencyCode;
  final Value<int> year;
  final Value<int> month;
  final Value<bool> isPaid;
  final Value<String?> tenantName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RentalIncomeCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.tenantName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RentalIncomeCompanion.insert({
    required String id,
    required String assetId,
    required double amount,
    required String currencyCode,
    required int year,
    required int month,
    this.isPaid = const Value.absent(),
    this.tenantName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        assetId = Value(assetId),
        amount = Value(amount),
        currencyCode = Value(currencyCode),
        year = Value(year),
        month = Value(month);
  static Insertable<RentalIncomeData> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<double>? amount,
    Expression<String>? currencyCode,
    Expression<int>? year,
    Expression<int>? month,
    Expression<bool>? isPaid,
    Expression<String>? tenantName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (isPaid != null) 'is_paid': isPaid,
      if (tenantName != null) 'tenant_name': tenantName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RentalIncomeCompanion copyWith(
      {Value<String>? id,
      Value<String>? assetId,
      Value<double>? amount,
      Value<String>? currencyCode,
      Value<int>? year,
      Value<int>? month,
      Value<bool>? isPaid,
      Value<String?>? tenantName,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RentalIncomeCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      year: year ?? this.year,
      month: month ?? this.month,
      isPaid: isPaid ?? this.isPaid,
      tenantName: tenantName ?? this.tenantName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (tenantName.present) {
      map['tenant_name'] = Variable<String>(tenantName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RentalIncomeCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('isPaid: $isPaid, ')
          ..write('tenantName: $tenantName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PropertyExitRulesTable extends PropertyExitRules
    with TableInfo<$PropertyExitRulesTable, PropertyExitRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertyExitRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES assets (id)'));
  static const VerificationMeta _ruleTypeMeta =
      const VerificationMeta('ruleType');
  @override
  late final GeneratedColumn<String> ruleType = GeneratedColumn<String>(
      'rule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thresholdValueMeta =
      const VerificationMeta('thresholdValue');
  @override
  late final GeneratedColumn<double> thresholdValue = GeneratedColumn<double>(
      'threshold_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lastCheckedAtMeta =
      const VerificationMeta('lastCheckedAt');
  @override
  late final GeneratedColumn<DateTime> lastCheckedAt =
      GeneratedColumn<DateTime>('last_checked_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isTriggeredMeta =
      const VerificationMeta('isTriggered');
  @override
  late final GeneratedColumn<bool> isTriggered = GeneratedColumn<bool>(
      'is_triggered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_triggered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        assetId,
        ruleType,
        thresholdValue,
        lastCheckedAt,
        isTriggered,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'property_exit_rules';
  @override
  VerificationContext validateIntegrity(Insertable<PropertyExitRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('rule_type')) {
      context.handle(_ruleTypeMeta,
          ruleType.isAcceptableOrUnknown(data['rule_type']!, _ruleTypeMeta));
    } else if (isInserting) {
      context.missing(_ruleTypeMeta);
    }
    if (data.containsKey('threshold_value')) {
      context.handle(
          _thresholdValueMeta,
          thresholdValue.isAcceptableOrUnknown(
              data['threshold_value']!, _thresholdValueMeta));
    } else if (isInserting) {
      context.missing(_thresholdValueMeta);
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
          _lastCheckedAtMeta,
          lastCheckedAt.isAcceptableOrUnknown(
              data['last_checked_at']!, _lastCheckedAtMeta));
    }
    if (data.containsKey('is_triggered')) {
      context.handle(
          _isTriggeredMeta,
          isTriggered.isAcceptableOrUnknown(
              data['is_triggered']!, _isTriggeredMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyExitRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyExitRule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      ruleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule_type'])!,
      thresholdValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}threshold_value'])!,
      lastCheckedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_checked_at']),
      isTriggered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_triggered'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PropertyExitRulesTable createAlias(String alias) {
    return $PropertyExitRulesTable(attachedDatabase, alias);
  }
}

class PropertyExitRule extends DataClass
    implements Insertable<PropertyExitRule> {
  final String id;
  final String assetId;
  final String ruleType;
  final double thresholdValue;
  final DateTime? lastCheckedAt;
  final bool isTriggered;
  final DateTime createdAt;
  const PropertyExitRule(
      {required this.id,
      required this.assetId,
      required this.ruleType,
      required this.thresholdValue,
      this.lastCheckedAt,
      required this.isTriggered,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['rule_type'] = Variable<String>(ruleType);
    map['threshold_value'] = Variable<double>(thresholdValue);
    if (!nullToAbsent || lastCheckedAt != null) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt);
    }
    map['is_triggered'] = Variable<bool>(isTriggered);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PropertyExitRulesCompanion toCompanion(bool nullToAbsent) {
    return PropertyExitRulesCompanion(
      id: Value(id),
      assetId: Value(assetId),
      ruleType: Value(ruleType),
      thresholdValue: Value(thresholdValue),
      lastCheckedAt: lastCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckedAt),
      isTriggered: Value(isTriggered),
      createdAt: Value(createdAt),
    );
  }

  factory PropertyExitRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyExitRule(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      ruleType: serializer.fromJson<String>(json['ruleType']),
      thresholdValue: serializer.fromJson<double>(json['thresholdValue']),
      lastCheckedAt: serializer.fromJson<DateTime?>(json['lastCheckedAt']),
      isTriggered: serializer.fromJson<bool>(json['isTriggered']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'ruleType': serializer.toJson<String>(ruleType),
      'thresholdValue': serializer.toJson<double>(thresholdValue),
      'lastCheckedAt': serializer.toJson<DateTime?>(lastCheckedAt),
      'isTriggered': serializer.toJson<bool>(isTriggered),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PropertyExitRule copyWith(
          {String? id,
          String? assetId,
          String? ruleType,
          double? thresholdValue,
          Value<DateTime?> lastCheckedAt = const Value.absent(),
          bool? isTriggered,
          DateTime? createdAt}) =>
      PropertyExitRule(
        id: id ?? this.id,
        assetId: assetId ?? this.assetId,
        ruleType: ruleType ?? this.ruleType,
        thresholdValue: thresholdValue ?? this.thresholdValue,
        lastCheckedAt:
            lastCheckedAt.present ? lastCheckedAt.value : this.lastCheckedAt,
        isTriggered: isTriggered ?? this.isTriggered,
        createdAt: createdAt ?? this.createdAt,
      );
  PropertyExitRule copyWithCompanion(PropertyExitRulesCompanion data) {
    return PropertyExitRule(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      ruleType: data.ruleType.present ? data.ruleType.value : this.ruleType,
      thresholdValue: data.thresholdValue.present
          ? data.thresholdValue.value
          : this.thresholdValue,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
      isTriggered:
          data.isTriggered.present ? data.isTriggered.value : this.isTriggered,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyExitRule(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('ruleType: $ruleType, ')
          ..write('thresholdValue: $thresholdValue, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('isTriggered: $isTriggered, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetId, ruleType, thresholdValue,
      lastCheckedAt, isTriggered, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyExitRule &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.ruleType == this.ruleType &&
          other.thresholdValue == this.thresholdValue &&
          other.lastCheckedAt == this.lastCheckedAt &&
          other.isTriggered == this.isTriggered &&
          other.createdAt == this.createdAt);
}

class PropertyExitRulesCompanion extends UpdateCompanion<PropertyExitRule> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<String> ruleType;
  final Value<double> thresholdValue;
  final Value<DateTime?> lastCheckedAt;
  final Value<bool> isTriggered;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PropertyExitRulesCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.ruleType = const Value.absent(),
    this.thresholdValue = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.isTriggered = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertyExitRulesCompanion.insert({
    required String id,
    required String assetId,
    required String ruleType,
    required double thresholdValue,
    this.lastCheckedAt = const Value.absent(),
    this.isTriggered = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        assetId = Value(assetId),
        ruleType = Value(ruleType),
        thresholdValue = Value(thresholdValue);
  static Insertable<PropertyExitRule> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<String>? ruleType,
    Expression<double>? thresholdValue,
    Expression<DateTime>? lastCheckedAt,
    Expression<bool>? isTriggered,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (ruleType != null) 'rule_type': ruleType,
      if (thresholdValue != null) 'threshold_value': thresholdValue,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (isTriggered != null) 'is_triggered': isTriggered,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertyExitRulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? assetId,
      Value<String>? ruleType,
      Value<double>? thresholdValue,
      Value<DateTime?>? lastCheckedAt,
      Value<bool>? isTriggered,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PropertyExitRulesCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      ruleType: ruleType ?? this.ruleType,
      thresholdValue: thresholdValue ?? this.thresholdValue,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      isTriggered: isTriggered ?? this.isTriggered,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (ruleType.present) {
      map['rule_type'] = Variable<String>(ruleType.value);
    }
    if (thresholdValue.present) {
      map['threshold_value'] = Variable<double>(thresholdValue.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt.value);
    }
    if (isTriggered.present) {
      map['is_triggered'] = Variable<bool>(isTriggered.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertyExitRulesCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('ruleType: $ruleType, ')
          ..write('thresholdValue: $thresholdValue, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('isTriggered: $isTriggered, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialInsightsTable extends FinancialInsights
    with TableInfo<$FinancialInsightsTable, FinancialInsight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialInsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isDismissedMeta =
      const VerificationMeta('isDismissed');
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
      'is_dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, message, severity, generatedAt, isDismissed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_insights';
  @override
  VerificationContext validateIntegrity(Insertable<FinancialInsight> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
          _isDismissedMeta,
          isDismissed.isAcceptableOrUnknown(
              data['is_dismissed']!, _isDismissedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialInsight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialInsight(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      isDismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dismissed'])!,
    );
  }

  @override
  $FinancialInsightsTable createAlias(String alias) {
    return $FinancialInsightsTable(attachedDatabase, alias);
  }
}

class FinancialInsight extends DataClass
    implements Insertable<FinancialInsight> {
  final String id;
  final String type;
  final String message;
  final String severity;
  final DateTime generatedAt;
  final bool isDismissed;
  const FinancialInsight(
      {required this.id,
      required this.type,
      required this.message,
      required this.severity,
      required this.generatedAt,
      required this.isDismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['message'] = Variable<String>(message);
    map['severity'] = Variable<String>(severity);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    return map;
  }

  FinancialInsightsCompanion toCompanion(bool nullToAbsent) {
    return FinancialInsightsCompanion(
      id: Value(id),
      type: Value(type),
      message: Value(message),
      severity: Value(severity),
      generatedAt: Value(generatedAt),
      isDismissed: Value(isDismissed),
    );
  }

  factory FinancialInsight.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialInsight(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      message: serializer.fromJson<String>(json['message']),
      severity: serializer.fromJson<String>(json['severity']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'message': serializer.toJson<String>(message),
      'severity': serializer.toJson<String>(severity),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'isDismissed': serializer.toJson<bool>(isDismissed),
    };
  }

  FinancialInsight copyWith(
          {String? id,
          String? type,
          String? message,
          String? severity,
          DateTime? generatedAt,
          bool? isDismissed}) =>
      FinancialInsight(
        id: id ?? this.id,
        type: type ?? this.type,
        message: message ?? this.message,
        severity: severity ?? this.severity,
        generatedAt: generatedAt ?? this.generatedAt,
        isDismissed: isDismissed ?? this.isDismissed,
      );
  FinancialInsight copyWithCompanion(FinancialInsightsCompanion data) {
    return FinancialInsight(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      message: data.message.present ? data.message.value : this.message,
      severity: data.severity.present ? data.severity.value : this.severity,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      isDismissed:
          data.isDismissed.present ? data.isDismissed.value : this.isDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialInsight(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('severity: $severity, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, message, severity, generatedAt, isDismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialInsight &&
          other.id == this.id &&
          other.type == this.type &&
          other.message == this.message &&
          other.severity == this.severity &&
          other.generatedAt == this.generatedAt &&
          other.isDismissed == this.isDismissed);
}

class FinancialInsightsCompanion extends UpdateCompanion<FinancialInsight> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> message;
  final Value<String> severity;
  final Value<DateTime> generatedAt;
  final Value<bool> isDismissed;
  final Value<int> rowid;
  const FinancialInsightsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.message = const Value.absent(),
    this.severity = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialInsightsCompanion.insert({
    required String id,
    required String type,
    required String message,
    required String severity,
    this.generatedAt = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        message = Value(message),
        severity = Value(severity);
  static Insertable<FinancialInsight> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? message,
    Expression<String>? severity,
    Expression<DateTime>? generatedAt,
    Expression<bool>? isDismissed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (message != null) 'message': message,
      if (severity != null) 'severity': severity,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialInsightsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? message,
      Value<String>? severity,
      Value<DateTime>? generatedAt,
      Value<bool>? isDismissed,
      Value<int>? rowid}) {
    return FinancialInsightsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      generatedAt: generatedAt ?? this.generatedAt,
      isDismissed: isDismissed ?? this.isDismissed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialInsightsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('severity: $severity, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $GoalAssetMappingsTable goalAssetMappings =
      $GoalAssetMappingsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $StatementSourcesTable statementSources =
      $StatementSourcesTable(this);
  late final $StatementQueueTable statementQueue = $StatementQueueTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $LiabilitiesTable liabilities = $LiabilitiesTable(this);
  late final $SipRecordsTable sipRecords = $SipRecordsTable(this);
  late final $DividendsTable dividends = $DividendsTable(this);
  late final $PropertyExpensesTable propertyExpenses =
      $PropertyExpensesTable(this);
  late final $RentalIncomeTable rentalIncome = $RentalIncomeTable(this);
  late final $PropertyExitRulesTable propertyExitRules =
      $PropertyExitRulesTable(this);
  late final $FinancialInsightsTable financialInsights =
      $FinancialInsightsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        currencies,
        accounts,
        categories,
        transactions,
        assets,
        goals,
        goalAssetMappings,
        budgets,
        statementSources,
        statementQueue,
        appSettings,
        liabilities,
        sipRecords,
        dividends,
        propertyExpenses,
        rentalIncome,
        propertyExitRules,
        financialInsights
      ];
}

typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  required String code,
  required String name,
  required String symbol,
  Value<double> rateToBase,
  Value<DateTime> lastUpdated,
  Value<int> rowid,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<String> code,
  Value<String> name,
  Value<String> symbol,
  Value<double> rateToBase,
  Value<DateTime> lastUpdated,
  Value<int> rowid,
});

final class $$CurrenciesTableReferences
    extends BaseReferences<_$AppDatabase, $CurrenciesTable, Currency> {
  $$CurrenciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.accounts,
          aliasName: $_aliasNameGenerator(
              db.currencies.code, db.accounts.currencyCode));

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.currencies.code, db.transactions.currencyCode));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AssetsTable, List<Asset>> _assetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.assets,
          aliasName:
              $_aliasNameGenerator(db.currencies.code, db.assets.currencyCode));

  $$AssetsTableProcessedTableManager get assetsRefs {
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_assetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.goals,
          aliasName:
              $_aliasNameGenerator(db.currencies.code, db.goals.currencyCode));

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.budgets,
          aliasName: $_aliasNameGenerator(
              db.currencies.code, db.budgets.currencyCode));

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager($_db, $_db.budgets)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LiabilitiesTable, List<Liability>>
      _liabilitiesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.liabilities,
              aliasName: $_aliasNameGenerator(
                  db.currencies.code, db.liabilities.currencyCode));

  $$LiabilitiesTableProcessedTableManager get liabilitiesRefs {
    final manager = $$LiabilitiesTableTableManager($_db, $_db.liabilities)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_liabilitiesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SipRecordsTable, List<SipRecord>>
      _sipRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sipRecords,
              aliasName: $_aliasNameGenerator(
                  db.currencies.code, db.sipRecords.currencyCode));

  $$SipRecordsTableProcessedTableManager get sipRecordsRefs {
    final manager = $$SipRecordsTableTableManager($_db, $_db.sipRecords)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_sipRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DividendsTable, List<Dividend>>
      _dividendsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dividends,
              aliasName: $_aliasNameGenerator(
                  db.currencies.code, db.dividends.currencyCode));

  $$DividendsTableProcessedTableManager get dividendsRefs {
    final manager = $$DividendsTableTableManager($_db, $_db.dividends)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_dividendsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PropertyExpensesTable, List<PropertyExpense>>
      _propertyExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.propertyExpenses,
              aliasName: $_aliasNameGenerator(
                  db.currencies.code, db.propertyExpenses.currencyCode));

  $$PropertyExpensesTableProcessedTableManager get propertyExpensesRefs {
    final manager =
        $$PropertyExpensesTableTableManager($_db, $_db.propertyExpenses)
            .filter((f) => f.currencyCode.code($_item.code));

    final cache =
        $_typedResult.readTableOrNull(_propertyExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RentalIncomeTable, List<RentalIncomeData>>
      _rentalIncomeRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.rentalIncome,
              aliasName: $_aliasNameGenerator(
                  db.currencies.code, db.rentalIncome.currencyCode));

  $$RentalIncomeTableProcessedTableManager get rentalIncomeRefs {
    final manager = $$RentalIncomeTableTableManager($_db, $_db.rentalIncome)
        .filter((f) => f.currencyCode.code($_item.code));

    final cache = $_typedResult.readTableOrNull(_rentalIncomeRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rateToBase => $composableBuilder(
      column: $table.rateToBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  Expression<bool> accountsRefs(
      Expression<bool> Function($$AccountsTableFilterComposer f) f) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> assetsRefs(
      Expression<bool> Function($$AssetsTableFilterComposer f) f) {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> goalsRefs(
      Expression<bool> Function($$GoalsTableFilterComposer f) f) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> budgetsRefs(
      Expression<bool> Function($$BudgetsTableFilterComposer f) f) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableFilterComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> liabilitiesRefs(
      Expression<bool> Function($$LiabilitiesTableFilterComposer f) f) {
    final $$LiabilitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.liabilities,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilitiesTableFilterComposer(
              $db: $db,
              $table: $db.liabilities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sipRecordsRefs(
      Expression<bool> Function($$SipRecordsTableFilterComposer f) f) {
    final $$SipRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.sipRecords,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SipRecordsTableFilterComposer(
              $db: $db,
              $table: $db.sipRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dividendsRefs(
      Expression<bool> Function($$DividendsTableFilterComposer f) f) {
    final $$DividendsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.dividends,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DividendsTableFilterComposer(
              $db: $db,
              $table: $db.dividends,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> propertyExpensesRefs(
      Expression<bool> Function($$PropertyExpensesTableFilterComposer f) f) {
    final $$PropertyExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.propertyExpenses,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PropertyExpensesTableFilterComposer(
              $db: $db,
              $table: $db.propertyExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> rentalIncomeRefs(
      Expression<bool> Function($$RentalIncomeTableFilterComposer f) f) {
    final $$RentalIncomeTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.rentalIncome,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RentalIncomeTableFilterComposer(
              $db: $db,
              $table: $db.rentalIncome,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rateToBase => $composableBuilder(
      column: $table.rateToBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get rateToBase => $composableBuilder(
      column: $table.rateToBase, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
      Expression<T> Function($$AccountsTableAnnotationComposer a) f) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> assetsRefs<T extends Object>(
      Expression<T> Function($$AssetsTableAnnotationComposer a) f) {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> goalsRefs<T extends Object>(
      Expression<T> Function($$GoalsTableAnnotationComposer a) f) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
      Expression<T> Function($$BudgetsTableAnnotationComposer a) f) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> liabilitiesRefs<T extends Object>(
      Expression<T> Function($$LiabilitiesTableAnnotationComposer a) f) {
    final $$LiabilitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.liabilities,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.liabilities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sipRecordsRefs<T extends Object>(
      Expression<T> Function($$SipRecordsTableAnnotationComposer a) f) {
    final $$SipRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.sipRecords,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SipRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.sipRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dividendsRefs<T extends Object>(
      Expression<T> Function($$DividendsTableAnnotationComposer a) f) {
    final $$DividendsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.dividends,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DividendsTableAnnotationComposer(
              $db: $db,
              $table: $db.dividends,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> propertyExpensesRefs<T extends Object>(
      Expression<T> Function($$PropertyExpensesTableAnnotationComposer a) f) {
    final $$PropertyExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.propertyExpenses,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PropertyExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.propertyExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> rentalIncomeRefs<T extends Object>(
      Expression<T> Function($$RentalIncomeTableAnnotationComposer a) f) {
    final $$RentalIncomeTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.rentalIncome,
        getReferencedColumn: (t) => t.currencyCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RentalIncomeTableAnnotationComposer(
              $db: $db,
              $table: $db.rentalIncome,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CurrenciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, $$CurrenciesTableReferences),
    Currency,
    PrefetchHooks Function(
        {bool accountsRefs,
        bool transactionsRefs,
        bool assetsRefs,
        bool goalsRefs,
        bool budgetsRefs,
        bool liabilitiesRefs,
        bool sipRecordsRefs,
        bool dividendsRefs,
        bool propertyExpensesRefs,
        bool rentalIncomeRefs})> {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<double> rateToBase = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            code: code,
            name: name,
            symbol: symbol,
            rateToBase: rateToBase,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String name,
            required String symbol,
            Value<double> rateToBase = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrenciesCompanion.insert(
            code: code,
            name: name,
            symbol: symbol,
            rateToBase: rateToBase,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CurrenciesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accountsRefs = false,
              transactionsRefs = false,
              assetsRefs = false,
              goalsRefs = false,
              budgetsRefs = false,
              liabilitiesRefs = false,
              sipRecordsRefs = false,
              dividendsRefs = false,
              propertyExpensesRefs = false,
              rentalIncomeRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountsRefs) db.accounts,
                if (transactionsRefs) db.transactions,
                if (assetsRefs) db.assets,
                if (goalsRefs) db.goals,
                if (budgetsRefs) db.budgets,
                if (liabilitiesRefs) db.liabilities,
                if (sipRecordsRefs) db.sipRecords,
                if (dividendsRefs) db.dividends,
                if (propertyExpensesRefs) db.propertyExpenses,
                if (rentalIncomeRefs) db.rentalIncome
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CurrenciesTableReferences._accountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .accountsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CurrenciesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (assetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CurrenciesTableReferences._assetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .assetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (goalsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CurrenciesTableReferences._goalsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .goalsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (budgetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CurrenciesTableReferences._budgetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .budgetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (liabilitiesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CurrenciesTableReferences
                            ._liabilitiesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .liabilitiesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (sipRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CurrenciesTableReferences
                            ._sipRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .sipRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (dividendsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CurrenciesTableReferences._dividendsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .dividendsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (propertyExpensesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CurrenciesTableReferences
                            ._propertyExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .propertyExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items),
                  if (rentalIncomeRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CurrenciesTableReferences
                            ._rentalIncomeRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .rentalIncomeRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyCode == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, $$CurrenciesTableReferences),
    Currency,
    PrefetchHooks Function(
        {bool accountsRefs,
        bool transactionsRefs,
        bool assetsRefs,
        bool goalsRefs,
        bool budgetsRefs,
        bool liabilitiesRefs,
        bool sipRecordsRefs,
        bool dividendsRefs,
        bool propertyExpensesRefs,
        bool rentalIncomeRefs})>;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String name,
  required String type,
  required String currencyCode,
  Value<String?> institution,
  Value<double> balance,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> currencyCode,
  Value<String?> institution,
  Value<double> balance,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.accounts.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transactions,
          aliasName:
              $_aliasNameGenerator(db.accounts.id, db.transactions.accountId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.accountId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool currencyCode, bool transactionsRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            type: type,
            currencyCode: currencyCode,
            institution: institution,
            balance: balance,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String currencyCode,
            Value<String?> institution = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            currencyCode: currencyCode,
            institution: institution,
            balance: balance,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {currencyCode = false, transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$AccountsTableReferences._currencyCodeTable(db),
                    referencedColumn:
                        $$AccountsTableReferences._currencyCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool currencyCode, bool transactionsRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> parentId,
  required String budgetType,
  Value<String?> icon,
  Value<int> colorValue,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentId,
  Value<String> budgetType,
  Value<String?> icon,
  Value<int> colorValue,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.transactions.categoryId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.categoryId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.budgets,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.budgets.categoryId));

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager($_db, $_db.budgets)
        .filter((f) => f.categoryId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetType => $composableBuilder(
      column: $table.budgetType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> budgetsRefs(
      Expression<bool> Function($$BudgetsTableFilterComposer f) f) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableFilterComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetType => $composableBuilder(
      column: $table.budgetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get budgetType => $composableBuilder(
      column: $table.budgetType, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
      Expression<T> Function($$BudgetsTableAnnotationComposer a) f) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool transactionsRefs, bool budgetsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String> budgetType = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            parentId: parentId,
            budgetType: budgetType,
            icon: icon,
            colorValue: colorValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> parentId = const Value.absent(),
            required String budgetType,
            Value<String?> icon = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            parentId: parentId,
            budgetType: budgetType,
            icon: icon,
            colorValue: colorValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {transactionsRefs = false, budgetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (budgetsRefs) db.budgets
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (budgetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._budgetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .budgetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool transactionsRefs, bool budgetsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String accountId,
  Value<String?> categoryId,
  required double amountSource,
  required String currencyCode,
  required double amountBase,
  required String description,
  Value<String?> merchant,
  required String type,
  required DateTime transactionDate,
  Value<String?> sourceStatementId,
  Value<bool> isRecurring,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<String?> categoryId,
  Value<double> amountSource,
  Value<String> currencyCode,
  Value<double> amountBase,
  Value<String> description,
  Value<String?> merchant,
  Value<String> type,
  Value<DateTime> transactionDate,
  Value<String?> sourceStatementId,
  Value<bool> isRecurring,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.transactions.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get accountId {
    if ($_item.accountId == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id($_item.accountId!));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.transactions.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    if ($_item.categoryId == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id($_item.categoryId!));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias($_aliasNameGenerator(
          db.transactions.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountSource => $composableBuilder(
      column: $table.amountSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountBase => $composableBuilder(
      column: $table.amountBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceStatementId => $composableBuilder(
      column: $table.sourceStatementId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountSource => $composableBuilder(
      column: $table.amountSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountBase => $composableBuilder(
      column: $table.amountBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceStatementId => $composableBuilder(
      column: $table.sourceStatementId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amountSource => $composableBuilder(
      column: $table.amountSource, builder: (column) => column);

  GeneratedColumn<double> get amountBase => $composableBuilder(
      column: $table.amountBase, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get sourceStatementId => $composableBuilder(
      column: $table.sourceStatementId, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool accountId, bool categoryId, bool currencyCode})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<double> amountSource = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<double> amountBase = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> merchant = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String?> sourceStatementId = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amountSource: amountSource,
            currencyCode: currencyCode,
            amountBase: amountBase,
            description: description,
            merchant: merchant,
            type: type,
            transactionDate: transactionDate,
            sourceStatementId: sourceStatementId,
            isRecurring: isRecurring,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            Value<String?> categoryId = const Value.absent(),
            required double amountSource,
            required String currencyCode,
            required double amountBase,
            required String description,
            Value<String?> merchant = const Value.absent(),
            required String type,
            required DateTime transactionDate,
            Value<String?> sourceStatementId = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amountSource: amountSource,
            currencyCode: currencyCode,
            amountBase: amountBase,
            description: description,
            merchant: merchant,
            type: type,
            transactionDate: transactionDate,
            sourceStatementId: sourceStatementId,
            isRecurring: isRecurring,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accountId = false, categoryId = false, currencyCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$TransactionsTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._accountIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$TransactionsTableReferences._currencyCodeTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._currencyCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool accountId, bool categoryId, bool currencyCode})>;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  required String id,
  required String name,
  required String type,
  required String currencyCode,
  required double purchaseValue,
  required double currentValue,
  required DateTime purchaseDate,
  required String geography,
  Value<bool> isLiquid,
  Value<int> lockInMonths,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> currencyCode,
  Value<double> purchaseValue,
  Value<double> currentValue,
  Value<DateTime> purchaseDate,
  Value<String> geography,
  Value<bool> isLiquid,
  Value<int> lockInMonths,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AssetsTableReferences
    extends BaseReferences<_$AppDatabase, $AssetsTable, Asset> {
  $$AssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.assets.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$GoalAssetMappingsTable, List<GoalAssetMapping>>
      _goalAssetMappingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.goalAssetMappings,
              aliasName: $_aliasNameGenerator(
                  db.assets.id, db.goalAssetMappings.assetId));

  $$GoalAssetMappingsTableProcessedTableManager get goalAssetMappingsRefs {
    final manager =
        $$GoalAssetMappingsTableTableManager($_db, $_db.goalAssetMappings)
            .filter((f) => f.assetId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_goalAssetMappingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LiabilitiesTable, List<Liability>>
      _liabilitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.liabilities,
          aliasName:
              $_aliasNameGenerator(db.assets.id, db.liabilities.linkedAssetId));

  $$LiabilitiesTableProcessedTableManager get liabilitiesRefs {
    final manager = $$LiabilitiesTableTableManager($_db, $_db.liabilities)
        .filter((f) => f.linkedAssetId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_liabilitiesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SipRecordsTable, List<SipRecord>>
      _sipRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.sipRecords,
          aliasName: $_aliasNameGenerator(db.assets.id, db.sipRecords.assetId));

  $$SipRecordsTableProcessedTableManager get sipRecordsRefs {
    final manager = $$SipRecordsTableTableManager($_db, $_db.sipRecords)
        .filter((f) => f.assetId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_sipRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DividendsTable, List<Dividend>>
      _dividendsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.dividends,
          aliasName: $_aliasNameGenerator(db.assets.id, db.dividends.assetId));

  $$DividendsTableProcessedTableManager get dividendsRefs {
    final manager = $$DividendsTableTableManager($_db, $_db.dividends)
        .filter((f) => f.assetId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_dividendsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PropertyExpensesTable, List<PropertyExpense>>
      _propertyExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.propertyExpenses,
              aliasName: $_aliasNameGenerator(
                  db.assets.id, db.propertyExpenses.assetId));

  $$PropertyExpensesTableProcessedTableManager get propertyExpensesRefs {
    final manager =
        $$PropertyExpensesTableTableManager($_db, $_db.propertyExpenses)
            .filter((f) => f.assetId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_propertyExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RentalIncomeTable, List<RentalIncomeData>>
      _rentalIncomeRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.rentalIncome,
              aliasName:
                  $_aliasNameGenerator(db.assets.id, db.rentalIncome.assetId));

  $$RentalIncomeTableProcessedTableManager get rentalIncomeRefs {
    final manager = $$RentalIncomeTableTableManager($_db, $_db.rentalIncome)
        .filter((f) => f.assetId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_rentalIncomeRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PropertyExitRulesTable, List<PropertyExitRule>>
      _propertyExitRulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.propertyExitRules,
              aliasName: $_aliasNameGenerator(
                  db.assets.id, db.propertyExitRules.assetId));

  $$PropertyExitRulesTableProcessedTableManager get propertyExitRulesRefs {
    final manager =
        $$PropertyExitRulesTableTableManager($_db, $_db.propertyExitRules)
            .filter((f) => f.assetId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_propertyExitRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchaseValue => $composableBuilder(
      column: $table.purchaseValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geography => $composableBuilder(
      column: $table.geography, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLiquid => $composableBuilder(
      column: $table.isLiquid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lockInMonths => $composableBuilder(
      column: $table.lockInMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> goalAssetMappingsRefs(
      Expression<bool> Function($$GoalAssetMappingsTableFilterComposer f) f) {
    final $$GoalAssetMappingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.goalAssetMappings,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalAssetMappingsTableFilterComposer(
              $db: $db,
              $table: $db.goalAssetMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> liabilitiesRefs(
      Expression<bool> Function($$LiabilitiesTableFilterComposer f) f) {
    final $$LiabilitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.liabilities,
        getReferencedColumn: (t) => t.linkedAssetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilitiesTableFilterComposer(
              $db: $db,
              $table: $db.liabilities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sipRecordsRefs(
      Expression<bool> Function($$SipRecordsTableFilterComposer f) f) {
    final $$SipRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sipRecords,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SipRecordsTableFilterComposer(
              $db: $db,
              $table: $db.sipRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dividendsRefs(
      Expression<bool> Function($$DividendsTableFilterComposer f) f) {
    final $$DividendsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dividends,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DividendsTableFilterComposer(
              $db: $db,
              $table: $db.dividends,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> propertyExpensesRefs(
      Expression<bool> Function($$PropertyExpensesTableFilterComposer f) f) {
    final $$PropertyExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.propertyExpenses,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PropertyExpensesTableFilterComposer(
              $db: $db,
              $table: $db.propertyExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> rentalIncomeRefs(
      Expression<bool> Function($$RentalIncomeTableFilterComposer f) f) {
    final $$RentalIncomeTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rentalIncome,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RentalIncomeTableFilterComposer(
              $db: $db,
              $table: $db.rentalIncome,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> propertyExitRulesRefs(
      Expression<bool> Function($$PropertyExitRulesTableFilterComposer f) f) {
    final $$PropertyExitRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.propertyExitRules,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PropertyExitRulesTableFilterComposer(
              $db: $db,
              $table: $db.propertyExitRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchaseValue => $composableBuilder(
      column: $table.purchaseValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentValue => $composableBuilder(
      column: $table.currentValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geography => $composableBuilder(
      column: $table.geography, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLiquid => $composableBuilder(
      column: $table.isLiquid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lockInMonths => $composableBuilder(
      column: $table.lockInMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get purchaseValue => $composableBuilder(
      column: $table.purchaseValue, builder: (column) => column);

  GeneratedColumn<double> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<String> get geography =>
      $composableBuilder(column: $table.geography, builder: (column) => column);

  GeneratedColumn<bool> get isLiquid =>
      $composableBuilder(column: $table.isLiquid, builder: (column) => column);

  GeneratedColumn<int> get lockInMonths => $composableBuilder(
      column: $table.lockInMonths, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> goalAssetMappingsRefs<T extends Object>(
      Expression<T> Function($$GoalAssetMappingsTableAnnotationComposer a) f) {
    final $$GoalAssetMappingsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.goalAssetMappings,
            getReferencedColumn: (t) => t.assetId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GoalAssetMappingsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.goalAssetMappings,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> liabilitiesRefs<T extends Object>(
      Expression<T> Function($$LiabilitiesTableAnnotationComposer a) f) {
    final $$LiabilitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.liabilities,
        getReferencedColumn: (t) => t.linkedAssetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LiabilitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.liabilities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sipRecordsRefs<T extends Object>(
      Expression<T> Function($$SipRecordsTableAnnotationComposer a) f) {
    final $$SipRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sipRecords,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SipRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.sipRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dividendsRefs<T extends Object>(
      Expression<T> Function($$DividendsTableAnnotationComposer a) f) {
    final $$DividendsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dividends,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DividendsTableAnnotationComposer(
              $db: $db,
              $table: $db.dividends,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> propertyExpensesRefs<T extends Object>(
      Expression<T> Function($$PropertyExpensesTableAnnotationComposer a) f) {
    final $$PropertyExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.propertyExpenses,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PropertyExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.propertyExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> rentalIncomeRefs<T extends Object>(
      Expression<T> Function($$RentalIncomeTableAnnotationComposer a) f) {
    final $$RentalIncomeTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rentalIncome,
        getReferencedColumn: (t) => t.assetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RentalIncomeTableAnnotationComposer(
              $db: $db,
              $table: $db.rentalIncome,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> propertyExitRulesRefs<T extends Object>(
      Expression<T> Function($$PropertyExitRulesTableAnnotationComposer a) f) {
    final $$PropertyExitRulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.propertyExitRules,
            getReferencedColumn: (t) => t.assetId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PropertyExitRulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.propertyExitRules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, $$AssetsTableReferences),
    Asset,
    PrefetchHooks Function(
        {bool currencyCode,
        bool goalAssetMappingsRefs,
        bool liabilitiesRefs,
        bool sipRecordsRefs,
        bool dividendsRefs,
        bool propertyExpensesRefs,
        bool rentalIncomeRefs,
        bool propertyExitRulesRefs})> {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<double> purchaseValue = const Value.absent(),
            Value<double> currentValue = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<String> geography = const Value.absent(),
            Value<bool> isLiquid = const Value.absent(),
            Value<int> lockInMonths = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetsCompanion(
            id: id,
            name: name,
            type: type,
            currencyCode: currencyCode,
            purchaseValue: purchaseValue,
            currentValue: currentValue,
            purchaseDate: purchaseDate,
            geography: geography,
            isLiquid: isLiquid,
            lockInMonths: lockInMonths,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String currencyCode,
            required double purchaseValue,
            required double currentValue,
            required DateTime purchaseDate,
            required String geography,
            Value<bool> isLiquid = const Value.absent(),
            Value<int> lockInMonths = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetsCompanion.insert(
            id: id,
            name: name,
            type: type,
            currencyCode: currencyCode,
            purchaseValue: purchaseValue,
            currentValue: currentValue,
            purchaseDate: purchaseDate,
            geography: geography,
            isLiquid: isLiquid,
            lockInMonths: lockInMonths,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AssetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {currencyCode = false,
              goalAssetMappingsRefs = false,
              liabilitiesRefs = false,
              sipRecordsRefs = false,
              dividendsRefs = false,
              propertyExpensesRefs = false,
              rentalIncomeRefs = false,
              propertyExitRulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (goalAssetMappingsRefs) db.goalAssetMappings,
                if (liabilitiesRefs) db.liabilities,
                if (sipRecordsRefs) db.sipRecords,
                if (dividendsRefs) db.dividends,
                if (propertyExpensesRefs) db.propertyExpenses,
                if (rentalIncomeRefs) db.rentalIncome,
                if (propertyExitRulesRefs) db.propertyExitRules
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$AssetsTableReferences._currencyCodeTable(db),
                    referencedColumn:
                        $$AssetsTableReferences._currencyCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (goalAssetMappingsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AssetsTableReferences
                            ._goalAssetMappingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .goalAssetMappingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items),
                  if (liabilitiesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._liabilitiesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .liabilitiesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.linkedAssetId == item.id),
                        typedResults: items),
                  if (sipRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._sipRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .sipRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items),
                  if (dividendsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._dividendsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .dividendsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items),
                  if (propertyExpensesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AssetsTableReferences
                            ._propertyExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .propertyExpensesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items),
                  if (rentalIncomeRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$AssetsTableReferences._rentalIncomeRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .rentalIncomeRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items),
                  if (propertyExitRulesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AssetsTableReferences
                            ._propertyExitRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AssetsTableReferences(db, table, p0)
                                .propertyExitRulesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.assetId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AssetsTable,
    Asset,
    $$AssetsTableFilterComposer,
    $$AssetsTableOrderingComposer,
    $$AssetsTableAnnotationComposer,
    $$AssetsTableCreateCompanionBuilder,
    $$AssetsTableUpdateCompanionBuilder,
    (Asset, $$AssetsTableReferences),
    Asset,
    PrefetchHooks Function(
        {bool currencyCode,
        bool goalAssetMappingsRefs,
        bool liabilitiesRefs,
        bool sipRecordsRefs,
        bool dividendsRefs,
        bool propertyExpensesRefs,
        bool rentalIncomeRefs,
        bool propertyExitRulesRefs})>;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String name,
  required String currencyCode,
  required double targetAmount,
  required DateTime targetDate,
  Value<String> priority,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> currencyCode,
  Value<double> targetAmount,
  Value<DateTime> targetDate,
  Value<String> priority,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.goals.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$GoalAssetMappingsTable, List<GoalAssetMapping>>
      _goalAssetMappingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.goalAssetMappings,
              aliasName: $_aliasNameGenerator(
                  db.goals.id, db.goalAssetMappings.goalId));

  $$GoalAssetMappingsTableProcessedTableManager get goalAssetMappingsRefs {
    final manager =
        $$GoalAssetMappingsTableTableManager($_db, $_db.goalAssetMappings)
            .filter((f) => f.goalId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_goalAssetMappingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SipRecordsTable, List<SipRecord>>
      _sipRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.sipRecords,
          aliasName: $_aliasNameGenerator(db.goals.id, db.sipRecords.goalId));

  $$SipRecordsTableProcessedTableManager get sipRecordsRefs {
    final manager = $$SipRecordsTableTableManager($_db, $_db.sipRecords)
        .filter((f) => f.goalId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_sipRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> goalAssetMappingsRefs(
      Expression<bool> Function($$GoalAssetMappingsTableFilterComposer f) f) {
    final $$GoalAssetMappingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.goalAssetMappings,
        getReferencedColumn: (t) => t.goalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalAssetMappingsTableFilterComposer(
              $db: $db,
              $table: $db.goalAssetMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sipRecordsRefs(
      Expression<bool> Function($$SipRecordsTableFilterComposer f) f) {
    final $$SipRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sipRecords,
        getReferencedColumn: (t) => t.goalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SipRecordsTableFilterComposer(
              $db: $db,
              $table: $db.sipRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> goalAssetMappingsRefs<T extends Object>(
      Expression<T> Function($$GoalAssetMappingsTableAnnotationComposer a) f) {
    final $$GoalAssetMappingsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.goalAssetMappings,
            getReferencedColumn: (t) => t.goalId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$GoalAssetMappingsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.goalAssetMappings,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> sipRecordsRefs<T extends Object>(
      Expression<T> Function($$SipRecordsTableAnnotationComposer a) f) {
    final $$SipRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sipRecords,
        getReferencedColumn: (t) => t.goalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SipRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.sipRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function(
        {bool currencyCode, bool goalAssetMappingsRefs, bool sipRecordsRefs})> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<double> targetAmount = const Value.absent(),
            Value<DateTime> targetDate = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            name: name,
            currencyCode: currencyCode,
            targetAmount: targetAmount,
            targetDate: targetDate,
            priority: priority,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String currencyCode,
            required double targetAmount,
            required DateTime targetDate,
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            id: id,
            name: name,
            currencyCode: currencyCode,
            targetAmount: targetAmount,
            targetDate: targetDate,
            priority: priority,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GoalsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {currencyCode = false,
              goalAssetMappingsRefs = false,
              sipRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (goalAssetMappingsRefs) db.goalAssetMappings,
                if (sipRecordsRefs) db.sipRecords
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$GoalsTableReferences._currencyCodeTable(db),
                    referencedColumn:
                        $$GoalsTableReferences._currencyCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (goalAssetMappingsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$GoalsTableReferences
                            ._goalAssetMappingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GoalsTableReferences(db, table, p0)
                                .goalAssetMappingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.goalId == item.id),
                        typedResults: items),
                  if (sipRecordsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$GoalsTableReferences._sipRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GoalsTableReferences(db, table, p0)
                                .sipRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.goalId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function(
        {bool currencyCode, bool goalAssetMappingsRefs, bool sipRecordsRefs})>;
typedef $$GoalAssetMappingsTableCreateCompanionBuilder
    = GoalAssetMappingsCompanion Function({
  required String goalId,
  required String assetId,
  required double allocationPercent,
  Value<int> rowid,
});
typedef $$GoalAssetMappingsTableUpdateCompanionBuilder
    = GoalAssetMappingsCompanion Function({
  Value<String> goalId,
  Value<String> assetId,
  Value<double> allocationPercent,
  Value<int> rowid,
});

final class $$GoalAssetMappingsTableReferences extends BaseReferences<
    _$AppDatabase, $GoalAssetMappingsTable, GoalAssetMapping> {
  $$GoalAssetMappingsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GoalsTable _goalIdTable(_$AppDatabase db) => db.goals.createAlias(
      $_aliasNameGenerator(db.goalAssetMappings.goalId, db.goals.id));

  $$GoalsTableProcessedTableManager? get goalId {
    if ($_item.goalId == null) return null;
    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.id($_item.goalId!));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets.createAlias(
      $_aliasNameGenerator(db.goalAssetMappings.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get assetId {
    if ($_item.assetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.assetId!));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GoalAssetMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalAssetMappingsTable> {
  $$GoalAssetMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get allocationPercent => $composableBuilder(
      column: $table.allocationPercent,
      builder: (column) => ColumnFilters(column));

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GoalAssetMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalAssetMappingsTable> {
  $$GoalAssetMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get allocationPercent => $composableBuilder(
      column: $table.allocationPercent,
      builder: (column) => ColumnOrderings(column));

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableOrderingComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GoalAssetMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalAssetMappingsTable> {
  $$GoalAssetMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get allocationPercent => $composableBuilder(
      column: $table.allocationPercent, builder: (column) => column);

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GoalAssetMappingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalAssetMappingsTable,
    GoalAssetMapping,
    $$GoalAssetMappingsTableFilterComposer,
    $$GoalAssetMappingsTableOrderingComposer,
    $$GoalAssetMappingsTableAnnotationComposer,
    $$GoalAssetMappingsTableCreateCompanionBuilder,
    $$GoalAssetMappingsTableUpdateCompanionBuilder,
    (GoalAssetMapping, $$GoalAssetMappingsTableReferences),
    GoalAssetMapping,
    PrefetchHooks Function({bool goalId, bool assetId})> {
  $$GoalAssetMappingsTableTableManager(
      _$AppDatabase db, $GoalAssetMappingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalAssetMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalAssetMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalAssetMappingsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> goalId = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<double> allocationPercent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAssetMappingsCompanion(
            goalId: goalId,
            assetId: assetId,
            allocationPercent: allocationPercent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String goalId,
            required String assetId,
            required double allocationPercent,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalAssetMappingsCompanion.insert(
            goalId: goalId,
            assetId: assetId,
            allocationPercent: allocationPercent,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GoalAssetMappingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({goalId = false, assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (goalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.goalId,
                    referencedTable:
                        $$GoalAssetMappingsTableReferences._goalIdTable(db),
                    referencedColumn:
                        $$GoalAssetMappingsTableReferences._goalIdTable(db).id,
                  ) as T;
                }
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$GoalAssetMappingsTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$GoalAssetMappingsTableReferences._assetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GoalAssetMappingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalAssetMappingsTable,
    GoalAssetMapping,
    $$GoalAssetMappingsTableFilterComposer,
    $$GoalAssetMappingsTableOrderingComposer,
    $$GoalAssetMappingsTableAnnotationComposer,
    $$GoalAssetMappingsTableCreateCompanionBuilder,
    $$GoalAssetMappingsTableUpdateCompanionBuilder,
    (GoalAssetMapping, $$GoalAssetMappingsTableReferences),
    GoalAssetMapping,
    PrefetchHooks Function({bool goalId, bool assetId})>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  required String categoryId,
  required int year,
  required int month,
  required double limitAmount,
  required String currencyCode,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String> categoryId,
  Value<int> year,
  Value<int> month,
  Value<double> limitAmount,
  Value<String> currencyCode,
  Value<int> rowid,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.budgets.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    if ($_item.categoryId == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id($_item.categoryId!));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.budgets.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function({bool categoryId, bool currencyCode})> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<double> limitAmount = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            categoryId: categoryId,
            year: year,
            month: month,
            limitAmount: limitAmount,
            currencyCode: currencyCode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String categoryId,
            required int year,
            required int month,
            required double limitAmount,
            required String currencyCode,
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            categoryId: categoryId,
            year: year,
            month: month,
            limitAmount: limitAmount,
            currencyCode: currencyCode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BudgetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({categoryId = false, currencyCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$BudgetsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$BudgetsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$BudgetsTableReferences._currencyCodeTable(db),
                    referencedColumn:
                        $$BudgetsTableReferences._currencyCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function({bool categoryId, bool currencyCode})>;
typedef $$StatementSourcesTableCreateCompanionBuilder
    = StatementSourcesCompanion Function({
  required String id,
  required String senderEmail,
  required String bankName,
  required String accountType,
  Value<String?> pdfPassword,
  Value<bool> isActive,
  Value<DateTime?> lastSyncAt,
  Value<int> rowid,
});
typedef $$StatementSourcesTableUpdateCompanionBuilder
    = StatementSourcesCompanion Function({
  Value<String> id,
  Value<String> senderEmail,
  Value<String> bankName,
  Value<String> accountType,
  Value<String?> pdfPassword,
  Value<bool> isActive,
  Value<DateTime?> lastSyncAt,
  Value<int> rowid,
});

final class $$StatementSourcesTableReferences extends BaseReferences<
    _$AppDatabase, $StatementSourcesTable, StatementSource> {
  $$StatementSourcesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StatementQueueTable, List<StatementQueueData>>
      _statementQueueRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.statementQueue,
              aliasName: $_aliasNameGenerator(
                  db.statementSources.id, db.statementQueue.sourceId));

  $$StatementQueueTableProcessedTableManager get statementQueueRefs {
    final manager = $$StatementQueueTableTableManager($_db, $_db.statementQueue)
        .filter((f) => f.sourceId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_statementQueueRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StatementSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $StatementSourcesTable> {
  $$StatementSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderEmail => $composableBuilder(
      column: $table.senderEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pdfPassword => $composableBuilder(
      column: $table.pdfPassword, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));

  Expression<bool> statementQueueRefs(
      Expression<bool> Function($$StatementQueueTableFilterComposer f) f) {
    final $$StatementQueueTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.statementQueue,
        getReferencedColumn: (t) => t.sourceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatementQueueTableFilterComposer(
              $db: $db,
              $table: $db.statementQueue,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StatementSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $StatementSourcesTable> {
  $$StatementSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderEmail => $composableBuilder(
      column: $table.senderEmail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pdfPassword => $composableBuilder(
      column: $table.pdfPassword, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));
}

class $$StatementSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatementSourcesTable> {
  $$StatementSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get senderEmail => $composableBuilder(
      column: $table.senderEmail, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => column);

  GeneratedColumn<String> get pdfPassword => $composableBuilder(
      column: $table.pdfPassword, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);

  Expression<T> statementQueueRefs<T extends Object>(
      Expression<T> Function($$StatementQueueTableAnnotationComposer a) f) {
    final $$StatementQueueTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.statementQueue,
        getReferencedColumn: (t) => t.sourceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatementQueueTableAnnotationComposer(
              $db: $db,
              $table: $db.statementQueue,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StatementSourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StatementSourcesTable,
    StatementSource,
    $$StatementSourcesTableFilterComposer,
    $$StatementSourcesTableOrderingComposer,
    $$StatementSourcesTableAnnotationComposer,
    $$StatementSourcesTableCreateCompanionBuilder,
    $$StatementSourcesTableUpdateCompanionBuilder,
    (StatementSource, $$StatementSourcesTableReferences),
    StatementSource,
    PrefetchHooks Function({bool statementQueueRefs})> {
  $$StatementSourcesTableTableManager(
      _$AppDatabase db, $StatementSourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatementSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatementSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatementSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> senderEmail = const Value.absent(),
            Value<String> bankName = const Value.absent(),
            Value<String> accountType = const Value.absent(),
            Value<String?> pdfPassword = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StatementSourcesCompanion(
            id: id,
            senderEmail: senderEmail,
            bankName: bankName,
            accountType: accountType,
            pdfPassword: pdfPassword,
            isActive: isActive,
            lastSyncAt: lastSyncAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String senderEmail,
            required String bankName,
            required String accountType,
            Value<String?> pdfPassword = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StatementSourcesCompanion.insert(
            id: id,
            senderEmail: senderEmail,
            bankName: bankName,
            accountType: accountType,
            pdfPassword: pdfPassword,
            isActive: isActive,
            lastSyncAt: lastSyncAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StatementSourcesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({statementQueueRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (statementQueueRefs) db.statementQueue
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (statementQueueRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$StatementSourcesTableReferences
                            ._statementQueueRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StatementSourcesTableReferences(db, table, p0)
                                .statementQueueRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.sourceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StatementSourcesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StatementSourcesTable,
    StatementSource,
    $$StatementSourcesTableFilterComposer,
    $$StatementSourcesTableOrderingComposer,
    $$StatementSourcesTableAnnotationComposer,
    $$StatementSourcesTableCreateCompanionBuilder,
    $$StatementSourcesTableUpdateCompanionBuilder,
    (StatementSource, $$StatementSourcesTableReferences),
    StatementSource,
    PrefetchHooks Function({bool statementQueueRefs})>;
typedef $$StatementQueueTableCreateCompanionBuilder = StatementQueueCompanion
    Function({
  required String id,
  required String emailId,
  Value<String?> sourceId,
  required String subject,
  Value<String> status,
  Value<int> priority,
  Value<int> retryCount,
  Value<String?> errorMessage,
  required DateTime emailDate,
  Value<DateTime> queuedAt,
  Value<DateTime?> processedAt,
  Value<int> rowid,
});
typedef $$StatementQueueTableUpdateCompanionBuilder = StatementQueueCompanion
    Function({
  Value<String> id,
  Value<String> emailId,
  Value<String?> sourceId,
  Value<String> subject,
  Value<String> status,
  Value<int> priority,
  Value<int> retryCount,
  Value<String?> errorMessage,
  Value<DateTime> emailDate,
  Value<DateTime> queuedAt,
  Value<DateTime?> processedAt,
  Value<int> rowid,
});

final class $$StatementQueueTableReferences extends BaseReferences<
    _$AppDatabase, $StatementQueueTable, StatementQueueData> {
  $$StatementQueueTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StatementSourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.statementSources.createAlias($_aliasNameGenerator(
          db.statementQueue.sourceId, db.statementSources.id));

  $$StatementSourcesTableProcessedTableManager? get sourceId {
    if ($_item.sourceId == null) return null;
    final manager =
        $$StatementSourcesTableTableManager($_db, $_db.statementSources)
            .filter((f) => f.id($_item.sourceId!));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StatementQueueTableFilterComposer
    extends Composer<_$AppDatabase, $StatementQueueTable> {
  $$StatementQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emailId => $composableBuilder(
      column: $table.emailId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get emailDate => $composableBuilder(
      column: $table.emailDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
      column: $table.queuedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => ColumnFilters(column));

  $$StatementSourcesTableFilterComposer get sourceId {
    final $$StatementSourcesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.statementSources,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatementSourcesTableFilterComposer(
              $db: $db,
              $table: $db.statementSources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StatementQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $StatementQueueTable> {
  $$StatementQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emailId => $composableBuilder(
      column: $table.emailId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get emailDate => $composableBuilder(
      column: $table.emailDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
      column: $table.queuedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => ColumnOrderings(column));

  $$StatementSourcesTableOrderingComposer get sourceId {
    final $$StatementSourcesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.statementSources,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatementSourcesTableOrderingComposer(
              $db: $db,
              $table: $db.statementSources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StatementQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatementQueueTable> {
  $$StatementQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get emailId =>
      $composableBuilder(column: $table.emailId, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get emailDate =>
      $composableBuilder(column: $table.emailDate, builder: (column) => column);

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => column);

  $$StatementSourcesTableAnnotationComposer get sourceId {
    final $$StatementSourcesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.statementSources,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatementSourcesTableAnnotationComposer(
              $db: $db,
              $table: $db.statementSources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StatementQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StatementQueueTable,
    StatementQueueData,
    $$StatementQueueTableFilterComposer,
    $$StatementQueueTableOrderingComposer,
    $$StatementQueueTableAnnotationComposer,
    $$StatementQueueTableCreateCompanionBuilder,
    $$StatementQueueTableUpdateCompanionBuilder,
    (StatementQueueData, $$StatementQueueTableReferences),
    StatementQueueData,
    PrefetchHooks Function({bool sourceId})> {
  $$StatementQueueTableTableManager(
      _$AppDatabase db, $StatementQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatementQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatementQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatementQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> emailId = const Value.absent(),
            Value<String?> sourceId = const Value.absent(),
            Value<String> subject = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> emailDate = const Value.absent(),
            Value<DateTime> queuedAt = const Value.absent(),
            Value<DateTime?> processedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StatementQueueCompanion(
            id: id,
            emailId: emailId,
            sourceId: sourceId,
            subject: subject,
            status: status,
            priority: priority,
            retryCount: retryCount,
            errorMessage: errorMessage,
            emailDate: emailDate,
            queuedAt: queuedAt,
            processedAt: processedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String emailId,
            Value<String?> sourceId = const Value.absent(),
            required String subject,
            Value<String> status = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            required DateTime emailDate,
            Value<DateTime> queuedAt = const Value.absent(),
            Value<DateTime?> processedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StatementQueueCompanion.insert(
            id: id,
            emailId: emailId,
            sourceId: sourceId,
            subject: subject,
            status: status,
            priority: priority,
            retryCount: retryCount,
            errorMessage: errorMessage,
            emailDate: emailDate,
            queuedAt: queuedAt,
            processedAt: processedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StatementQueueTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sourceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceId,
                    referencedTable:
                        $$StatementQueueTableReferences._sourceIdTable(db),
                    referencedColumn:
                        $$StatementQueueTableReferences._sourceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StatementQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StatementQueueTable,
    StatementQueueData,
    $$StatementQueueTableFilterComposer,
    $$StatementQueueTableOrderingComposer,
    $$StatementQueueTableAnnotationComposer,
    $$StatementQueueTableCreateCompanionBuilder,
    $$StatementQueueTableUpdateCompanionBuilder,
    (StatementQueueData, $$StatementQueueTableReferences),
    StatementQueueData,
    PrefetchHooks Function({bool sourceId})>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;
typedef $$LiabilitiesTableCreateCompanionBuilder = LiabilitiesCompanion
    Function({
  required String id,
  required String name,
  required String type,
  required String currencyCode,
  required double principalAmount,
  required double outstandingAmount,
  required double interestRate,
  required int tenureMonths,
  required double emi,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String?> linkedAssetId,
  Value<String?> institution,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$LiabilitiesTableUpdateCompanionBuilder = LiabilitiesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> currencyCode,
  Value<double> principalAmount,
  Value<double> outstandingAmount,
  Value<double> interestRate,
  Value<int> tenureMonths,
  Value<double> emi,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String?> linkedAssetId,
  Value<String?> institution,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$LiabilitiesTableReferences
    extends BaseReferences<_$AppDatabase, $LiabilitiesTable, Liability> {
  $$LiabilitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias($_aliasNameGenerator(
          db.liabilities.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AssetsTable _linkedAssetIdTable(_$AppDatabase db) =>
      db.assets.createAlias(
          $_aliasNameGenerator(db.liabilities.linkedAssetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get linkedAssetId {
    if ($_item.linkedAssetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.linkedAssetId!));
    final item = $_typedResult.readTableOrNull(_linkedAssetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LiabilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get principalAmount => $composableBuilder(
      column: $table.principalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get outstandingAmount => $composableBuilder(
      column: $table.outstandingAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenureMonths => $composableBuilder(
      column: $table.tenureMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get emi => $composableBuilder(
      column: $table.emi, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableFilterComposer get linkedAssetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.linkedAssetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LiabilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get principalAmount => $composableBuilder(
      column: $table.principalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get outstandingAmount => $composableBuilder(
      column: $table.outstandingAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRate => $composableBuilder(
      column: $table.interestRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenureMonths => $composableBuilder(
      column: $table.tenureMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get emi => $composableBuilder(
      column: $table.emi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableOrderingComposer get linkedAssetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.linkedAssetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LiabilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get principalAmount => $composableBuilder(
      column: $table.principalAmount, builder: (column) => column);

  GeneratedColumn<double> get outstandingAmount => $composableBuilder(
      column: $table.outstandingAmount, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => column);

  GeneratedColumn<int> get tenureMonths => $composableBuilder(
      column: $table.tenureMonths, builder: (column) => column);

  GeneratedColumn<double> get emi =>
      $composableBuilder(column: $table.emi, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AssetsTableAnnotationComposer get linkedAssetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.linkedAssetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LiabilitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LiabilitiesTable,
    Liability,
    $$LiabilitiesTableFilterComposer,
    $$LiabilitiesTableOrderingComposer,
    $$LiabilitiesTableAnnotationComposer,
    $$LiabilitiesTableCreateCompanionBuilder,
    $$LiabilitiesTableUpdateCompanionBuilder,
    (Liability, $$LiabilitiesTableReferences),
    Liability,
    PrefetchHooks Function({bool currencyCode, bool linkedAssetId})> {
  $$LiabilitiesTableTableManager(_$AppDatabase db, $LiabilitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiabilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiabilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiabilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<double> principalAmount = const Value.absent(),
            Value<double> outstandingAmount = const Value.absent(),
            Value<double> interestRate = const Value.absent(),
            Value<int> tenureMonths = const Value.absent(),
            Value<double> emi = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> linkedAssetId = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LiabilitiesCompanion(
            id: id,
            name: name,
            type: type,
            currencyCode: currencyCode,
            principalAmount: principalAmount,
            outstandingAmount: outstandingAmount,
            interestRate: interestRate,
            tenureMonths: tenureMonths,
            emi: emi,
            startDate: startDate,
            endDate: endDate,
            linkedAssetId: linkedAssetId,
            institution: institution,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String currencyCode,
            required double principalAmount,
            required double outstandingAmount,
            required double interestRate,
            required int tenureMonths,
            required double emi,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> linkedAssetId = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LiabilitiesCompanion.insert(
            id: id,
            name: name,
            type: type,
            currencyCode: currencyCode,
            principalAmount: principalAmount,
            outstandingAmount: outstandingAmount,
            interestRate: interestRate,
            tenureMonths: tenureMonths,
            emi: emi,
            startDate: startDate,
            endDate: endDate,
            linkedAssetId: linkedAssetId,
            institution: institution,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LiabilitiesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {currencyCode = false, linkedAssetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$LiabilitiesTableReferences._currencyCodeTable(db),
                    referencedColumn: $$LiabilitiesTableReferences
                        ._currencyCodeTable(db)
                        .code,
                  ) as T;
                }
                if (linkedAssetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.linkedAssetId,
                    referencedTable:
                        $$LiabilitiesTableReferences._linkedAssetIdTable(db),
                    referencedColumn:
                        $$LiabilitiesTableReferences._linkedAssetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LiabilitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LiabilitiesTable,
    Liability,
    $$LiabilitiesTableFilterComposer,
    $$LiabilitiesTableOrderingComposer,
    $$LiabilitiesTableAnnotationComposer,
    $$LiabilitiesTableCreateCompanionBuilder,
    $$LiabilitiesTableUpdateCompanionBuilder,
    (Liability, $$LiabilitiesTableReferences),
    Liability,
    PrefetchHooks Function({bool currencyCode, bool linkedAssetId})>;
typedef $$SipRecordsTableCreateCompanionBuilder = SipRecordsCompanion Function({
  required String id,
  required String assetId,
  required String name,
  required double amount,
  required String currencyCode,
  required int dayOfMonth,
  Value<String> frequency,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<bool> isActive,
  Value<String?> goalId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SipRecordsTableUpdateCompanionBuilder = SipRecordsCompanion Function({
  Value<String> id,
  Value<String> assetId,
  Value<String> name,
  Value<double> amount,
  Value<String> currencyCode,
  Value<int> dayOfMonth,
  Value<String> frequency,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<bool> isActive,
  Value<String?> goalId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$SipRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $SipRecordsTable, SipRecord> {
  $$SipRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets
      .createAlias($_aliasNameGenerator(db.sipRecords.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get assetId {
    if ($_item.assetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.assetId!));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.sipRecords.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GoalsTable _goalIdTable(_$AppDatabase db) => db.goals
      .createAlias($_aliasNameGenerator(db.sipRecords.goalId, db.goals.id));

  $$GoalsTableProcessedTableManager? get goalId {
    if ($_item.goalId == null) return null;
    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.id($_item.goalId!));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SipRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SipRecordsTable> {
  $$SipRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SipRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SipRecordsTable> {
  $$SipRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableOrderingComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SipRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SipRecordsTable> {
  $$SipRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SipRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SipRecordsTable,
    SipRecord,
    $$SipRecordsTableFilterComposer,
    $$SipRecordsTableOrderingComposer,
    $$SipRecordsTableAnnotationComposer,
    $$SipRecordsTableCreateCompanionBuilder,
    $$SipRecordsTableUpdateCompanionBuilder,
    (SipRecord, $$SipRecordsTableReferences),
    SipRecord,
    PrefetchHooks Function({bool assetId, bool currencyCode, bool goalId})> {
  $$SipRecordsTableTableManager(_$AppDatabase db, $SipRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SipRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SipRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SipRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<int> dayOfMonth = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> goalId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SipRecordsCompanion(
            id: id,
            assetId: assetId,
            name: name,
            amount: amount,
            currencyCode: currencyCode,
            dayOfMonth: dayOfMonth,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
            goalId: goalId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String assetId,
            required String name,
            required double amount,
            required String currencyCode,
            required int dayOfMonth,
            Value<String> frequency = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> goalId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SipRecordsCompanion.insert(
            id: id,
            assetId: assetId,
            name: name,
            amount: amount,
            currencyCode: currencyCode,
            dayOfMonth: dayOfMonth,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            isActive: isActive,
            goalId: goalId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SipRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {assetId = false, currencyCode = false, goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$SipRecordsTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$SipRecordsTableReferences._assetIdTable(db).id,
                  ) as T;
                }
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$SipRecordsTableReferences._currencyCodeTable(db),
                    referencedColumn:
                        $$SipRecordsTableReferences._currencyCodeTable(db).code,
                  ) as T;
                }
                if (goalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.goalId,
                    referencedTable:
                        $$SipRecordsTableReferences._goalIdTable(db),
                    referencedColumn:
                        $$SipRecordsTableReferences._goalIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SipRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SipRecordsTable,
    SipRecord,
    $$SipRecordsTableFilterComposer,
    $$SipRecordsTableOrderingComposer,
    $$SipRecordsTableAnnotationComposer,
    $$SipRecordsTableCreateCompanionBuilder,
    $$SipRecordsTableUpdateCompanionBuilder,
    (SipRecord, $$SipRecordsTableReferences),
    SipRecord,
    PrefetchHooks Function({bool assetId, bool currencyCode, bool goalId})>;
typedef $$DividendsTableCreateCompanionBuilder = DividendsCompanion Function({
  required String id,
  required String assetId,
  required double amount,
  required String currencyCode,
  required DateTime exDate,
  required DateTime paymentDate,
  Value<String> dividendType,
  Value<bool> isReinvested,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DividendsTableUpdateCompanionBuilder = DividendsCompanion Function({
  Value<String> id,
  Value<String> assetId,
  Value<double> amount,
  Value<String> currencyCode,
  Value<DateTime> exDate,
  Value<DateTime> paymentDate,
  Value<String> dividendType,
  Value<bool> isReinvested,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$DividendsTableReferences
    extends BaseReferences<_$AppDatabase, $DividendsTable, Dividend> {
  $$DividendsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets
      .createAlias($_aliasNameGenerator(db.dividends.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get assetId {
    if ($_item.assetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.assetId!));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.dividends.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DividendsTableFilterComposer
    extends Composer<_$AppDatabase, $DividendsTable> {
  $$DividendsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get exDate => $composableBuilder(
      column: $table.exDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dividendType => $composableBuilder(
      column: $table.dividendType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReinvested => $composableBuilder(
      column: $table.isReinvested, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DividendsTableOrderingComposer
    extends Composer<_$AppDatabase, $DividendsTable> {
  $$DividendsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get exDate => $composableBuilder(
      column: $table.exDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dividendType => $composableBuilder(
      column: $table.dividendType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReinvested => $composableBuilder(
      column: $table.isReinvested,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DividendsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DividendsTable> {
  $$DividendsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get exDate =>
      $composableBuilder(column: $table.exDate, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => column);

  GeneratedColumn<String> get dividendType => $composableBuilder(
      column: $table.dividendType, builder: (column) => column);

  GeneratedColumn<bool> get isReinvested => $composableBuilder(
      column: $table.isReinvested, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DividendsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DividendsTable,
    Dividend,
    $$DividendsTableFilterComposer,
    $$DividendsTableOrderingComposer,
    $$DividendsTableAnnotationComposer,
    $$DividendsTableCreateCompanionBuilder,
    $$DividendsTableUpdateCompanionBuilder,
    (Dividend, $$DividendsTableReferences),
    Dividend,
    PrefetchHooks Function({bool assetId, bool currencyCode})> {
  $$DividendsTableTableManager(_$AppDatabase db, $DividendsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DividendsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DividendsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DividendsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<DateTime> exDate = const Value.absent(),
            Value<DateTime> paymentDate = const Value.absent(),
            Value<String> dividendType = const Value.absent(),
            Value<bool> isReinvested = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DividendsCompanion(
            id: id,
            assetId: assetId,
            amount: amount,
            currencyCode: currencyCode,
            exDate: exDate,
            paymentDate: paymentDate,
            dividendType: dividendType,
            isReinvested: isReinvested,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String assetId,
            required double amount,
            required String currencyCode,
            required DateTime exDate,
            required DateTime paymentDate,
            Value<String> dividendType = const Value.absent(),
            Value<bool> isReinvested = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DividendsCompanion.insert(
            id: id,
            assetId: assetId,
            amount: amount,
            currencyCode: currencyCode,
            exDate: exDate,
            paymentDate: paymentDate,
            dividendType: dividendType,
            isReinvested: isReinvested,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DividendsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false, currencyCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$DividendsTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$DividendsTableReferences._assetIdTable(db).id,
                  ) as T;
                }
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$DividendsTableReferences._currencyCodeTable(db),
                    referencedColumn:
                        $$DividendsTableReferences._currencyCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DividendsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DividendsTable,
    Dividend,
    $$DividendsTableFilterComposer,
    $$DividendsTableOrderingComposer,
    $$DividendsTableAnnotationComposer,
    $$DividendsTableCreateCompanionBuilder,
    $$DividendsTableUpdateCompanionBuilder,
    (Dividend, $$DividendsTableReferences),
    Dividend,
    PrefetchHooks Function({bool assetId, bool currencyCode})>;
typedef $$PropertyExpensesTableCreateCompanionBuilder
    = PropertyExpensesCompanion Function({
  required String id,
  required String assetId,
  required String category,
  required double amount,
  required String currencyCode,
  required DateTime expenseDate,
  Value<String?> description,
  Value<bool> isRecurring,
  Value<int?> recurringDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PropertyExpensesTableUpdateCompanionBuilder
    = PropertyExpensesCompanion Function({
  Value<String> id,
  Value<String> assetId,
  Value<String> category,
  Value<double> amount,
  Value<String> currencyCode,
  Value<DateTime> expenseDate,
  Value<String?> description,
  Value<bool> isRecurring,
  Value<int?> recurringDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PropertyExpensesTableReferences extends BaseReferences<
    _$AppDatabase, $PropertyExpensesTable, PropertyExpense> {
  $$PropertyExpensesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets.createAlias(
      $_aliasNameGenerator(db.propertyExpenses.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get assetId {
    if ($_item.assetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.assetId!));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias($_aliasNameGenerator(
          db.propertyExpenses.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PropertyExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertyExpensesTable> {
  $$PropertyExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurringDay => $composableBuilder(
      column: $table.recurringDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PropertyExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertyExpensesTable> {
  $$PropertyExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurringDay => $composableBuilder(
      column: $table.recurringDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PropertyExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertyExpensesTable> {
  $$PropertyExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<int> get recurringDay => $composableBuilder(
      column: $table.recurringDay, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PropertyExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PropertyExpensesTable,
    PropertyExpense,
    $$PropertyExpensesTableFilterComposer,
    $$PropertyExpensesTableOrderingComposer,
    $$PropertyExpensesTableAnnotationComposer,
    $$PropertyExpensesTableCreateCompanionBuilder,
    $$PropertyExpensesTableUpdateCompanionBuilder,
    (PropertyExpense, $$PropertyExpensesTableReferences),
    PropertyExpense,
    PrefetchHooks Function({bool assetId, bool currencyCode})> {
  $$PropertyExpensesTableTableManager(
      _$AppDatabase db, $PropertyExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertyExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertyExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertyExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<DateTime> expenseDate = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<int?> recurringDay = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PropertyExpensesCompanion(
            id: id,
            assetId: assetId,
            category: category,
            amount: amount,
            currencyCode: currencyCode,
            expenseDate: expenseDate,
            description: description,
            isRecurring: isRecurring,
            recurringDay: recurringDay,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String assetId,
            required String category,
            required double amount,
            required String currencyCode,
            required DateTime expenseDate,
            Value<String?> description = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<int?> recurringDay = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PropertyExpensesCompanion.insert(
            id: id,
            assetId: assetId,
            category: category,
            amount: amount,
            currencyCode: currencyCode,
            expenseDate: expenseDate,
            description: description,
            isRecurring: isRecurring,
            recurringDay: recurringDay,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PropertyExpensesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false, currencyCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$PropertyExpensesTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$PropertyExpensesTableReferences._assetIdTable(db).id,
                  ) as T;
                }
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable: $$PropertyExpensesTableReferences
                        ._currencyCodeTable(db),
                    referencedColumn: $$PropertyExpensesTableReferences
                        ._currencyCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PropertyExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PropertyExpensesTable,
    PropertyExpense,
    $$PropertyExpensesTableFilterComposer,
    $$PropertyExpensesTableOrderingComposer,
    $$PropertyExpensesTableAnnotationComposer,
    $$PropertyExpensesTableCreateCompanionBuilder,
    $$PropertyExpensesTableUpdateCompanionBuilder,
    (PropertyExpense, $$PropertyExpensesTableReferences),
    PropertyExpense,
    PrefetchHooks Function({bool assetId, bool currencyCode})>;
typedef $$RentalIncomeTableCreateCompanionBuilder = RentalIncomeCompanion
    Function({
  required String id,
  required String assetId,
  required double amount,
  required String currencyCode,
  required int year,
  required int month,
  Value<bool> isPaid,
  Value<String?> tenantName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$RentalIncomeTableUpdateCompanionBuilder = RentalIncomeCompanion
    Function({
  Value<String> id,
  Value<String> assetId,
  Value<double> amount,
  Value<String> currencyCode,
  Value<int> year,
  Value<int> month,
  Value<bool> isPaid,
  Value<String?> tenantName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$RentalIncomeTableReferences extends BaseReferences<_$AppDatabase,
    $RentalIncomeTable, RentalIncomeData> {
  $$RentalIncomeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets
      .createAlias($_aliasNameGenerator(db.rentalIncome.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get assetId {
    if ($_item.assetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.assetId!));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyCodeTable(_$AppDatabase db) =>
      db.currencies.createAlias($_aliasNameGenerator(
          db.rentalIncome.currencyCode, db.currencies.code));

  $$CurrenciesTableProcessedTableManager? get currencyCode {
    if ($_item.currencyCode == null) return null;
    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code($_item.currencyCode!));
    final item = $_typedResult.readTableOrNull(_currencyCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RentalIncomeTableFilterComposer
    extends Composer<_$AppDatabase, $RentalIncomeTable> {
  $$RentalIncomeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantName => $composableBuilder(
      column: $table.tenantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyCode {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RentalIncomeTableOrderingComposer
    extends Composer<_$AppDatabase, $RentalIncomeTable> {
  $$RentalIncomeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantName => $composableBuilder(
      column: $table.tenantName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyCode {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RentalIncomeTableAnnotationComposer
    extends Composer<_$AppDatabase, $RentalIncomeTable> {
  $$RentalIncomeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<String> get tenantName => $composableBuilder(
      column: $table.tenantName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyCode {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyCode,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RentalIncomeTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RentalIncomeTable,
    RentalIncomeData,
    $$RentalIncomeTableFilterComposer,
    $$RentalIncomeTableOrderingComposer,
    $$RentalIncomeTableAnnotationComposer,
    $$RentalIncomeTableCreateCompanionBuilder,
    $$RentalIncomeTableUpdateCompanionBuilder,
    (RentalIncomeData, $$RentalIncomeTableReferences),
    RentalIncomeData,
    PrefetchHooks Function({bool assetId, bool currencyCode})> {
  $$RentalIncomeTableTableManager(_$AppDatabase db, $RentalIncomeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RentalIncomeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RentalIncomeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RentalIncomeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<String?> tenantName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RentalIncomeCompanion(
            id: id,
            assetId: assetId,
            amount: amount,
            currencyCode: currencyCode,
            year: year,
            month: month,
            isPaid: isPaid,
            tenantName: tenantName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String assetId,
            required double amount,
            required String currencyCode,
            required int year,
            required int month,
            Value<bool> isPaid = const Value.absent(),
            Value<String?> tenantName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RentalIncomeCompanion.insert(
            id: id,
            assetId: assetId,
            amount: amount,
            currencyCode: currencyCode,
            year: year,
            month: month,
            isPaid: isPaid,
            tenantName: tenantName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RentalIncomeTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false, currencyCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$RentalIncomeTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$RentalIncomeTableReferences._assetIdTable(db).id,
                  ) as T;
                }
                if (currencyCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyCode,
                    referencedTable:
                        $$RentalIncomeTableReferences._currencyCodeTable(db),
                    referencedColumn: $$RentalIncomeTableReferences
                        ._currencyCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RentalIncomeTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RentalIncomeTable,
    RentalIncomeData,
    $$RentalIncomeTableFilterComposer,
    $$RentalIncomeTableOrderingComposer,
    $$RentalIncomeTableAnnotationComposer,
    $$RentalIncomeTableCreateCompanionBuilder,
    $$RentalIncomeTableUpdateCompanionBuilder,
    (RentalIncomeData, $$RentalIncomeTableReferences),
    RentalIncomeData,
    PrefetchHooks Function({bool assetId, bool currencyCode})>;
typedef $$PropertyExitRulesTableCreateCompanionBuilder
    = PropertyExitRulesCompanion Function({
  required String id,
  required String assetId,
  required String ruleType,
  required double thresholdValue,
  Value<DateTime?> lastCheckedAt,
  Value<bool> isTriggered,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PropertyExitRulesTableUpdateCompanionBuilder
    = PropertyExitRulesCompanion Function({
  Value<String> id,
  Value<String> assetId,
  Value<String> ruleType,
  Value<double> thresholdValue,
  Value<DateTime?> lastCheckedAt,
  Value<bool> isTriggered,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PropertyExitRulesTableReferences extends BaseReferences<
    _$AppDatabase, $PropertyExitRulesTable, PropertyExitRule> {
  $$PropertyExitRulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AssetsTable _assetIdTable(_$AppDatabase db) => db.assets.createAlias(
      $_aliasNameGenerator(db.propertyExitRules.assetId, db.assets.id));

  $$AssetsTableProcessedTableManager? get assetId {
    if ($_item.assetId == null) return null;
    final manager = $$AssetsTableTableManager($_db, $_db.assets)
        .filter((f) => f.id($_item.assetId!));
    final item = $_typedResult.readTableOrNull(_assetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PropertyExitRulesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertyExitRulesTable> {
  $$PropertyExitRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thresholdValue => $composableBuilder(
      column: $table.thresholdValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTriggered => $composableBuilder(
      column: $table.isTriggered, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AssetsTableFilterComposer get assetId {
    final $$AssetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableFilterComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PropertyExitRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertyExitRulesTable> {
  $$PropertyExitRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thresholdValue => $composableBuilder(
      column: $table.thresholdValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTriggered => $composableBuilder(
      column: $table.isTriggered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AssetsTableOrderingComposer get assetId {
    final $$AssetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableOrderingComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PropertyExitRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertyExitRulesTable> {
  $$PropertyExitRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleType =>
      $composableBuilder(column: $table.ruleType, builder: (column) => column);

  GeneratedColumn<double> get thresholdValue => $composableBuilder(
      column: $table.thresholdValue, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => column);

  GeneratedColumn<bool> get isTriggered => $composableBuilder(
      column: $table.isTriggered, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AssetsTableAnnotationComposer get assetId {
    final $$AssetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assetId,
        referencedTable: $db.assets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AssetsTableAnnotationComposer(
              $db: $db,
              $table: $db.assets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PropertyExitRulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PropertyExitRulesTable,
    PropertyExitRule,
    $$PropertyExitRulesTableFilterComposer,
    $$PropertyExitRulesTableOrderingComposer,
    $$PropertyExitRulesTableAnnotationComposer,
    $$PropertyExitRulesTableCreateCompanionBuilder,
    $$PropertyExitRulesTableUpdateCompanionBuilder,
    (PropertyExitRule, $$PropertyExitRulesTableReferences),
    PropertyExitRule,
    PrefetchHooks Function({bool assetId})> {
  $$PropertyExitRulesTableTableManager(
      _$AppDatabase db, $PropertyExitRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertyExitRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertyExitRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertyExitRulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> assetId = const Value.absent(),
            Value<String> ruleType = const Value.absent(),
            Value<double> thresholdValue = const Value.absent(),
            Value<DateTime?> lastCheckedAt = const Value.absent(),
            Value<bool> isTriggered = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PropertyExitRulesCompanion(
            id: id,
            assetId: assetId,
            ruleType: ruleType,
            thresholdValue: thresholdValue,
            lastCheckedAt: lastCheckedAt,
            isTriggered: isTriggered,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String assetId,
            required String ruleType,
            required double thresholdValue,
            Value<DateTime?> lastCheckedAt = const Value.absent(),
            Value<bool> isTriggered = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PropertyExitRulesCompanion.insert(
            id: id,
            assetId: assetId,
            ruleType: ruleType,
            thresholdValue: thresholdValue,
            lastCheckedAt: lastCheckedAt,
            isTriggered: isTriggered,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PropertyExitRulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assetId,
                    referencedTable:
                        $$PropertyExitRulesTableReferences._assetIdTable(db),
                    referencedColumn:
                        $$PropertyExitRulesTableReferences._assetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PropertyExitRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PropertyExitRulesTable,
    PropertyExitRule,
    $$PropertyExitRulesTableFilterComposer,
    $$PropertyExitRulesTableOrderingComposer,
    $$PropertyExitRulesTableAnnotationComposer,
    $$PropertyExitRulesTableCreateCompanionBuilder,
    $$PropertyExitRulesTableUpdateCompanionBuilder,
    (PropertyExitRule, $$PropertyExitRulesTableReferences),
    PropertyExitRule,
    PrefetchHooks Function({bool assetId})>;
typedef $$FinancialInsightsTableCreateCompanionBuilder
    = FinancialInsightsCompanion Function({
  required String id,
  required String type,
  required String message,
  required String severity,
  Value<DateTime> generatedAt,
  Value<bool> isDismissed,
  Value<int> rowid,
});
typedef $$FinancialInsightsTableUpdateCompanionBuilder
    = FinancialInsightsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> message,
  Value<String> severity,
  Value<DateTime> generatedAt,
  Value<bool> isDismissed,
  Value<int> rowid,
});

class $$FinancialInsightsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialInsightsTable> {
  $$FinancialInsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnFilters(column));
}

class $$FinancialInsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialInsightsTable> {
  $$FinancialInsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnOrderings(column));
}

class $$FinancialInsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialInsightsTable> {
  $$FinancialInsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => column);
}

class $$FinancialInsightsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialInsightsTable,
    FinancialInsight,
    $$FinancialInsightsTableFilterComposer,
    $$FinancialInsightsTableOrderingComposer,
    $$FinancialInsightsTableAnnotationComposer,
    $$FinancialInsightsTableCreateCompanionBuilder,
    $$FinancialInsightsTableUpdateCompanionBuilder,
    (
      FinancialInsight,
      BaseReferences<_$AppDatabase, $FinancialInsightsTable, FinancialInsight>
    ),
    FinancialInsight,
    PrefetchHooks Function()> {
  $$FinancialInsightsTableTableManager(
      _$AppDatabase db, $FinancialInsightsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialInsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialInsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialInsightsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialInsightsCompanion(
            id: id,
            type: type,
            message: message,
            severity: severity,
            generatedAt: generatedAt,
            isDismissed: isDismissed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String message,
            required String severity,
            Value<DateTime> generatedAt = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialInsightsCompanion.insert(
            id: id,
            type: type,
            message: message,
            severity: severity,
            generatedAt: generatedAt,
            isDismissed: isDismissed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialInsightsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinancialInsightsTable,
    FinancialInsight,
    $$FinancialInsightsTableFilterComposer,
    $$FinancialInsightsTableOrderingComposer,
    $$FinancialInsightsTableAnnotationComposer,
    $$FinancialInsightsTableCreateCompanionBuilder,
    $$FinancialInsightsTableUpdateCompanionBuilder,
    (
      FinancialInsight,
      BaseReferences<_$AppDatabase, $FinancialInsightsTable, FinancialInsight>
    ),
    FinancialInsight,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$GoalAssetMappingsTableTableManager get goalAssetMappings =>
      $$GoalAssetMappingsTableTableManager(_db, _db.goalAssetMappings);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$StatementSourcesTableTableManager get statementSources =>
      $$StatementSourcesTableTableManager(_db, _db.statementSources);
  $$StatementQueueTableTableManager get statementQueue =>
      $$StatementQueueTableTableManager(_db, _db.statementQueue);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$LiabilitiesTableTableManager get liabilities =>
      $$LiabilitiesTableTableManager(_db, _db.liabilities);
  $$SipRecordsTableTableManager get sipRecords =>
      $$SipRecordsTableTableManager(_db, _db.sipRecords);
  $$DividendsTableTableManager get dividends =>
      $$DividendsTableTableManager(_db, _db.dividends);
  $$PropertyExpensesTableTableManager get propertyExpenses =>
      $$PropertyExpensesTableTableManager(_db, _db.propertyExpenses);
  $$RentalIncomeTableTableManager get rentalIncome =>
      $$RentalIncomeTableTableManager(_db, _db.rentalIncome);
  $$PropertyExitRulesTableTableManager get propertyExitRules =>
      $$PropertyExitRulesTableTableManager(_db, _db.propertyExitRules);
  $$FinancialInsightsTableTableManager get financialInsights =>
      $$FinancialInsightsTableTableManager(_db, _db.financialInsights);
}
