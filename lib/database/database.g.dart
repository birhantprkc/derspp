// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedDateMeta = const VerificationMeta(
    'addedDate',
  );
  @override
  late final GeneratedColumn<DateTime> addedDate = GeneratedColumn<DateTime>(
    'added_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverImageMeta = const VerificationMeta(
    'coverImage',
  );
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
    'cover_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalCoverImageMeta =
      const VerificationMeta('originalCoverImage');
  @override
  late final GeneratedColumn<String> originalCoverImage =
      GeneratedColumn<String>(
        'original_cover_image',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scraperTypeMeta = const VerificationMeta(
    'scraperType',
  );
  @override
  late final GeneratedColumn<String> scraperType = GeneratedColumn<String>(
    'scraper_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fsource'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sourceId,
    baseUrl,
    addedDate,
    coverImage,
    originalCoverImage,
    position,
    scraperType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('added_date')) {
      context.handle(
        _addedDateMeta,
        addedDate.isAcceptableOrUnknown(data['added_date']!, _addedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_addedDateMeta);
    }
    if (data.containsKey('cover_image')) {
      context.handle(
        _coverImageMeta,
        coverImage.isAcceptableOrUnknown(data['cover_image']!, _coverImageMeta),
      );
    }
    if (data.containsKey('original_cover_image')) {
      context.handle(
        _originalCoverImageMeta,
        originalCoverImage.isAcceptableOrUnknown(
          data['original_cover_image']!,
          _originalCoverImageMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('scraper_type')) {
      context.handle(
        _scraperTypeMeta,
        scraperType.isAcceptableOrUnknown(
          data['scraper_type']!,
          _scraperTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      addedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_date'],
      )!,
      coverImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image'],
      ),
      originalCoverImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_cover_image'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      scraperType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scraper_type'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String name;
  final String sourceId;
  final String baseUrl;
  final DateTime addedDate;
  final String? coverImage;
  final String? originalCoverImage;
  final int position;
  final String scraperType;
  const Book({
    required this.id,
    required this.name,
    required this.sourceId,
    required this.baseUrl,
    required this.addedDate,
    this.coverImage,
    this.originalCoverImage,
    required this.position,
    required this.scraperType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['source_id'] = Variable<String>(sourceId);
    map['base_url'] = Variable<String>(baseUrl);
    map['added_date'] = Variable<DateTime>(addedDate);
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    if (!nullToAbsent || originalCoverImage != null) {
      map['original_cover_image'] = Variable<String>(originalCoverImage);
    }
    map['position'] = Variable<int>(position);
    map['scraper_type'] = Variable<String>(scraperType);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      name: Value(name),
      sourceId: Value(sourceId),
      baseUrl: Value(baseUrl),
      addedDate: Value(addedDate),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      originalCoverImage: originalCoverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalCoverImage),
      position: Value(position),
      scraperType: Value(scraperType),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      addedDate: serializer.fromJson<DateTime>(json['addedDate']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      originalCoverImage: serializer.fromJson<String?>(
        json['originalCoverImage'],
      ),
      position: serializer.fromJson<int>(json['position']),
      scraperType: serializer.fromJson<String>(json['scraperType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sourceId': serializer.toJson<String>(sourceId),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'addedDate': serializer.toJson<DateTime>(addedDate),
      'coverImage': serializer.toJson<String?>(coverImage),
      'originalCoverImage': serializer.toJson<String?>(originalCoverImage),
      'position': serializer.toJson<int>(position),
      'scraperType': serializer.toJson<String>(scraperType),
    };
  }

  Book copyWith({
    String? id,
    String? name,
    String? sourceId,
    String? baseUrl,
    DateTime? addedDate,
    Value<String?> coverImage = const Value.absent(),
    Value<String?> originalCoverImage = const Value.absent(),
    int? position,
    String? scraperType,
  }) => Book(
    id: id ?? this.id,
    name: name ?? this.name,
    sourceId: sourceId ?? this.sourceId,
    baseUrl: baseUrl ?? this.baseUrl,
    addedDate: addedDate ?? this.addedDate,
    coverImage: coverImage.present ? coverImage.value : this.coverImage,
    originalCoverImage: originalCoverImage.present
        ? originalCoverImage.value
        : this.originalCoverImage,
    position: position ?? this.position,
    scraperType: scraperType ?? this.scraperType,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      addedDate: data.addedDate.present ? data.addedDate.value : this.addedDate,
      coverImage: data.coverImage.present
          ? data.coverImage.value
          : this.coverImage,
      originalCoverImage: data.originalCoverImage.present
          ? data.originalCoverImage.value
          : this.originalCoverImage,
      position: data.position.present ? data.position.value : this.position,
      scraperType: data.scraperType.present
          ? data.scraperType.value
          : this.scraperType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceId: $sourceId, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('addedDate: $addedDate, ')
          ..write('coverImage: $coverImage, ')
          ..write('originalCoverImage: $originalCoverImage, ')
          ..write('position: $position, ')
          ..write('scraperType: $scraperType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sourceId,
    baseUrl,
    addedDate,
    coverImage,
    originalCoverImage,
    position,
    scraperType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.name == this.name &&
          other.sourceId == this.sourceId &&
          other.baseUrl == this.baseUrl &&
          other.addedDate == this.addedDate &&
          other.coverImage == this.coverImage &&
          other.originalCoverImage == this.originalCoverImage &&
          other.position == this.position &&
          other.scraperType == this.scraperType);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> sourceId;
  final Value<String> baseUrl;
  final Value<DateTime> addedDate;
  final Value<String?> coverImage;
  final Value<String?> originalCoverImage;
  final Value<int> position;
  final Value<String> scraperType;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.addedDate = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.originalCoverImage = const Value.absent(),
    this.position = const Value.absent(),
    this.scraperType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String name,
    required String sourceId,
    required String baseUrl,
    required DateTime addedDate,
    this.coverImage = const Value.absent(),
    this.originalCoverImage = const Value.absent(),
    this.position = const Value.absent(),
    this.scraperType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sourceId = Value(sourceId),
       baseUrl = Value(baseUrl),
       addedDate = Value(addedDate);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sourceId,
    Expression<String>? baseUrl,
    Expression<DateTime>? addedDate,
    Expression<String>? coverImage,
    Expression<String>? originalCoverImage,
    Expression<int>? position,
    Expression<String>? scraperType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sourceId != null) 'source_id': sourceId,
      if (baseUrl != null) 'base_url': baseUrl,
      if (addedDate != null) 'added_date': addedDate,
      if (coverImage != null) 'cover_image': coverImage,
      if (originalCoverImage != null)
        'original_cover_image': originalCoverImage,
      if (position != null) 'position': position,
      if (scraperType != null) 'scraper_type': scraperType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? sourceId,
    Value<String>? baseUrl,
    Value<DateTime>? addedDate,
    Value<String?>? coverImage,
    Value<String?>? originalCoverImage,
    Value<int>? position,
    Value<String>? scraperType,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceId: sourceId ?? this.sourceId,
      baseUrl: baseUrl ?? this.baseUrl,
      addedDate: addedDate ?? this.addedDate,
      coverImage: coverImage ?? this.coverImage,
      originalCoverImage: originalCoverImage ?? this.originalCoverImage,
      position: position ?? this.position,
      scraperType: scraperType ?? this.scraperType,
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
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (addedDate.present) {
      map['added_date'] = Variable<DateTime>(addedDate.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (originalCoverImage.present) {
      map['original_cover_image'] = Variable<String>(originalCoverImage.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (scraperType.present) {
      map['scraper_type'] = Variable<String>(scraperType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceId: $sourceId, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('addedDate: $addedDate, ')
          ..write('coverImage: $coverImage, ')
          ..write('originalCoverImage: $originalCoverImage, ')
          ..write('position: $position, ')
          ..write('scraperType: $scraperType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PublishersTable extends Publishers
    with TableInfo<$PublishersTable, Publisher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PublishersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scraperTypeMeta = const VerificationMeta(
    'scraperType',
  );
  @override
  late final GeneratedColumn<String> scraperType = GeneratedColumn<String>(
    'scraper_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fsource'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, url, sourceId, scraperType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'publishers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Publisher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('scraper_type')) {
      context.handle(
        _scraperTypeMeta,
        scraperType.isAcceptableOrUnknown(
          data['scraper_type']!,
          _scraperTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Publisher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Publisher(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      scraperType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scraper_type'],
      )!,
    );
  }

  @override
  $PublishersTable createAlias(String alias) {
    return $PublishersTable(attachedDatabase, alias);
  }
}

class Publisher extends DataClass implements Insertable<Publisher> {
  final int id;
  final String name;
  final String url;
  final String sourceId;
  final String scraperType;
  const Publisher({
    required this.id,
    required this.name,
    required this.url,
    required this.sourceId,
    required this.scraperType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['source_id'] = Variable<String>(sourceId);
    map['scraper_type'] = Variable<String>(scraperType);
    return map;
  }

  PublishersCompanion toCompanion(bool nullToAbsent) {
    return PublishersCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      sourceId: Value(sourceId),
      scraperType: Value(scraperType),
    );
  }

  factory Publisher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Publisher(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      scraperType: serializer.fromJson<String>(json['scraperType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'sourceId': serializer.toJson<String>(sourceId),
      'scraperType': serializer.toJson<String>(scraperType),
    };
  }

  Publisher copyWith({
    int? id,
    String? name,
    String? url,
    String? sourceId,
    String? scraperType,
  }) => Publisher(
    id: id ?? this.id,
    name: name ?? this.name,
    url: url ?? this.url,
    sourceId: sourceId ?? this.sourceId,
    scraperType: scraperType ?? this.scraperType,
  );
  Publisher copyWithCompanion(PublishersCompanion data) {
    return Publisher(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      scraperType: data.scraperType.present
          ? data.scraperType.value
          : this.scraperType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Publisher(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('sourceId: $sourceId, ')
          ..write('scraperType: $scraperType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, url, sourceId, scraperType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Publisher &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.sourceId == this.sourceId &&
          other.scraperType == this.scraperType);
}

class PublishersCompanion extends UpdateCompanion<Publisher> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String> sourceId;
  final Value<String> scraperType;
  const PublishersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.scraperType = const Value.absent(),
  });
  PublishersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String url,
    required String sourceId,
    this.scraperType = const Value.absent(),
  }) : name = Value(name),
       url = Value(url),
       sourceId = Value(sourceId);
  static Insertable<Publisher> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? sourceId,
    Expression<String>? scraperType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (sourceId != null) 'source_id': sourceId,
      if (scraperType != null) 'scraper_type': scraperType,
    });
  }

  PublishersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? url,
    Value<String>? sourceId,
    Value<String>? scraperType,
  }) {
    return PublishersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      sourceId: sourceId ?? this.sourceId,
      scraperType: scraperType ?? this.scraperType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (scraperType.present) {
      map['scraper_type'] = Variable<String>(scraperType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PublishersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('sourceId: $sourceId, ')
          ..write('scraperType: $scraperType')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
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

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
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
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
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

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
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
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionFoldersTable extends QuestionFolders
    with TableInfo<$QuestionFoldersTable, QuestionFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionFoldersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionFolder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuestionFoldersTable createAlias(String alias) {
    return $QuestionFoldersTable(attachedDatabase, alias);
  }
}

class QuestionFolder extends DataClass implements Insertable<QuestionFolder> {
  final int id;
  final String name;
  final DateTime createdAt;
  const QuestionFolder({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuestionFoldersCompanion toCompanion(bool nullToAbsent) {
    return QuestionFoldersCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory QuestionFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionFolder(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuestionFolder copyWith({int? id, String? name, DateTime? createdAt}) =>
      QuestionFolder(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  QuestionFolder copyWithCompanion(QuestionFoldersCompanion data) {
    return QuestionFolder(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionFolder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionFolder &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class QuestionFoldersCompanion extends UpdateCompanion<QuestionFolder> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const QuestionFoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuestionFoldersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<QuestionFolder> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuestionFoldersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return QuestionFoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionFoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavedQuestionsTable extends SavedQuestions
    with TableInfo<$SavedQuestionsTable, SavedQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedQuestionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES question_folders (id)',
    ),
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scraperTypeMeta = const VerificationMeta(
    'scraperType',
  );
  @override
  late final GeneratedColumn<String> scraperType = GeneratedColumn<String>(
    'scraper_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breadcrumbsMeta = const VerificationMeta(
    'breadcrumbs',
  );
  @override
  late final GeneratedColumn<String> breadcrumbs = GeneratedColumn<String>(
    'breadcrumbs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    baseUrl,
    scraperType,
    bookId,
    chapterId,
    questionId,
    breadcrumbs,
    rawJson,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('scraper_type')) {
      context.handle(
        _scraperTypeMeta,
        scraperType.isAcceptableOrUnknown(
          data['scraper_type']!,
          _scraperTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scraperTypeMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('breadcrumbs')) {
      context.handle(
        _breadcrumbsMeta,
        breadcrumbs.isAcceptableOrUnknown(
          data['breadcrumbs']!,
          _breadcrumbsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_breadcrumbsMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      scraperType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scraper_type'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      breadcrumbs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breadcrumbs'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedQuestionsTable createAlias(String alias) {
    return $SavedQuestionsTable(attachedDatabase, alias);
  }
}

class SavedQuestion extends DataClass implements Insertable<SavedQuestion> {
  final int id;
  final int folderId;
  final String baseUrl;
  final String scraperType;
  final String bookId;
  final String chapterId;
  final String questionId;
  final String breadcrumbs;
  final String rawJson;
  final DateTime savedAt;
  const SavedQuestion({
    required this.id,
    required this.folderId,
    required this.baseUrl,
    required this.scraperType,
    required this.bookId,
    required this.chapterId,
    required this.questionId,
    required this.breadcrumbs,
    required this.rawJson,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_id'] = Variable<int>(folderId);
    map['base_url'] = Variable<String>(baseUrl);
    map['scraper_type'] = Variable<String>(scraperType);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['question_id'] = Variable<String>(questionId);
    map['breadcrumbs'] = Variable<String>(breadcrumbs);
    map['raw_json'] = Variable<String>(rawJson);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedQuestionsCompanion toCompanion(bool nullToAbsent) {
    return SavedQuestionsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      baseUrl: Value(baseUrl),
      scraperType: Value(scraperType),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      questionId: Value(questionId),
      breadcrumbs: Value(breadcrumbs),
      rawJson: Value(rawJson),
      savedAt: Value(savedAt),
    );
  }

  factory SavedQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedQuestion(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      scraperType: serializer.fromJson<String>(json['scraperType']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      breadcrumbs: serializer.fromJson<String>(json['breadcrumbs']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'scraperType': serializer.toJson<String>(scraperType),
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'questionId': serializer.toJson<String>(questionId),
      'breadcrumbs': serializer.toJson<String>(breadcrumbs),
      'rawJson': serializer.toJson<String>(rawJson),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedQuestion copyWith({
    int? id,
    int? folderId,
    String? baseUrl,
    String? scraperType,
    String? bookId,
    String? chapterId,
    String? questionId,
    String? breadcrumbs,
    String? rawJson,
    DateTime? savedAt,
  }) => SavedQuestion(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    baseUrl: baseUrl ?? this.baseUrl,
    scraperType: scraperType ?? this.scraperType,
    bookId: bookId ?? this.bookId,
    chapterId: chapterId ?? this.chapterId,
    questionId: questionId ?? this.questionId,
    breadcrumbs: breadcrumbs ?? this.breadcrumbs,
    rawJson: rawJson ?? this.rawJson,
    savedAt: savedAt ?? this.savedAt,
  );
  SavedQuestion copyWithCompanion(SavedQuestionsCompanion data) {
    return SavedQuestion(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      scraperType: data.scraperType.present
          ? data.scraperType.value
          : this.scraperType,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      breadcrumbs: data.breadcrumbs.present
          ? data.breadcrumbs.value
          : this.breadcrumbs,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedQuestion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('scraperType: $scraperType, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('questionId: $questionId, ')
          ..write('breadcrumbs: $breadcrumbs, ')
          ..write('rawJson: $rawJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folderId,
    baseUrl,
    scraperType,
    bookId,
    chapterId,
    questionId,
    breadcrumbs,
    rawJson,
    savedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedQuestion &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.baseUrl == this.baseUrl &&
          other.scraperType == this.scraperType &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.questionId == this.questionId &&
          other.breadcrumbs == this.breadcrumbs &&
          other.rawJson == this.rawJson &&
          other.savedAt == this.savedAt);
}

class SavedQuestionsCompanion extends UpdateCompanion<SavedQuestion> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<String> baseUrl;
  final Value<String> scraperType;
  final Value<String> bookId;
  final Value<String> chapterId;
  final Value<String> questionId;
  final Value<String> breadcrumbs;
  final Value<String> rawJson;
  final Value<DateTime> savedAt;
  const SavedQuestionsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.scraperType = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.breadcrumbs = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  SavedQuestionsCompanion.insert({
    this.id = const Value.absent(),
    required int folderId,
    required String baseUrl,
    required String scraperType,
    required String bookId,
    required String chapterId,
    required String questionId,
    required String breadcrumbs,
    required String rawJson,
    this.savedAt = const Value.absent(),
  }) : folderId = Value(folderId),
       baseUrl = Value(baseUrl),
       scraperType = Value(scraperType),
       bookId = Value(bookId),
       chapterId = Value(chapterId),
       questionId = Value(questionId),
       breadcrumbs = Value(breadcrumbs),
       rawJson = Value(rawJson);
  static Insertable<SavedQuestion> custom({
    Expression<int>? id,
    Expression<int>? folderId,
    Expression<String>? baseUrl,
    Expression<String>? scraperType,
    Expression<String>? bookId,
    Expression<String>? chapterId,
    Expression<String>? questionId,
    Expression<String>? breadcrumbs,
    Expression<String>? rawJson,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (baseUrl != null) 'base_url': baseUrl,
      if (scraperType != null) 'scraper_type': scraperType,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (questionId != null) 'question_id': questionId,
      if (breadcrumbs != null) 'breadcrumbs': breadcrumbs,
      if (rawJson != null) 'raw_json': rawJson,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  SavedQuestionsCompanion copyWith({
    Value<int>? id,
    Value<int>? folderId,
    Value<String>? baseUrl,
    Value<String>? scraperType,
    Value<String>? bookId,
    Value<String>? chapterId,
    Value<String>? questionId,
    Value<String>? breadcrumbs,
    Value<String>? rawJson,
    Value<DateTime>? savedAt,
  }) {
    return SavedQuestionsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      baseUrl: baseUrl ?? this.baseUrl,
      scraperType: scraperType ?? this.scraperType,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      questionId: questionId ?? this.questionId,
      breadcrumbs: breadcrumbs ?? this.breadcrumbs,
      rawJson: rawJson ?? this.rawJson,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (scraperType.present) {
      map['scraper_type'] = Variable<String>(scraperType.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (breadcrumbs.present) {
      map['breadcrumbs'] = Variable<String>(breadcrumbs.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('scraperType: $scraperType, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('questionId: $questionId, ')
          ..write('breadcrumbs: $breadcrumbs, ')
          ..write('rawJson: $rawJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $PublishersTable publishers = $PublishersTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $QuestionFoldersTable questionFolders = $QuestionFoldersTable(
    this,
  );
  late final $SavedQuestionsTable savedQuestions = $SavedQuestionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    publishers,
    settings,
    questionFolders,
    savedQuestions,
  ];
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required String id,
      required String name,
      required String sourceId,
      required String baseUrl,
      required DateTime addedDate,
      Value<String?> coverImage,
      Value<String?> originalCoverImage,
      Value<int> position,
      Value<String> scraperType,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> sourceId,
      Value<String> baseUrl,
      Value<DateTime> addedDate,
      Value<String?> coverImage,
      Value<String?> originalCoverImage,
      Value<int> position,
      Value<String> scraperType,
      Value<int> rowid,
    });

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedDate => $composableBuilder(
    column: $table.addedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalCoverImage => $composableBuilder(
    column: $table.originalCoverImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedDate => $composableBuilder(
    column: $table.addedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalCoverImage => $composableBuilder(
    column: $table.originalCoverImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
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

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get addedDate =>
      $composableBuilder(column: $table.addedDate, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalCoverImage => $composableBuilder(
    column: $table.originalCoverImage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => column,
  );
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
          Book,
          PrefetchHooks Function()
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<DateTime> addedDate = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<String?> originalCoverImage = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> scraperType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                name: name,
                sourceId: sourceId,
                baseUrl: baseUrl,
                addedDate: addedDate,
                coverImage: coverImage,
                originalCoverImage: originalCoverImage,
                position: position,
                scraperType: scraperType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String sourceId,
                required String baseUrl,
                required DateTime addedDate,
                Value<String?> coverImage = const Value.absent(),
                Value<String?> originalCoverImage = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> scraperType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                name: name,
                sourceId: sourceId,
                baseUrl: baseUrl,
                addedDate: addedDate,
                coverImage: coverImage,
                originalCoverImage: originalCoverImage,
                position: position,
                scraperType: scraperType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
      Book,
      PrefetchHooks Function()
    >;
typedef $$PublishersTableCreateCompanionBuilder =
    PublishersCompanion Function({
      Value<int> id,
      required String name,
      required String url,
      required String sourceId,
      Value<String> scraperType,
    });
typedef $$PublishersTableUpdateCompanionBuilder =
    PublishersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> url,
      Value<String> sourceId,
      Value<String> scraperType,
    });

class $$PublishersTableFilterComposer
    extends Composer<_$AppDatabase, $PublishersTable> {
  $$PublishersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PublishersTableOrderingComposer
    extends Composer<_$AppDatabase, $PublishersTable> {
  $$PublishersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PublishersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PublishersTable> {
  $$PublishersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => column,
  );
}

class $$PublishersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PublishersTable,
          Publisher,
          $$PublishersTableFilterComposer,
          $$PublishersTableOrderingComposer,
          $$PublishersTableAnnotationComposer,
          $$PublishersTableCreateCompanionBuilder,
          $$PublishersTableUpdateCompanionBuilder,
          (
            Publisher,
            BaseReferences<_$AppDatabase, $PublishersTable, Publisher>,
          ),
          Publisher,
          PrefetchHooks Function()
        > {
  $$PublishersTableTableManager(_$AppDatabase db, $PublishersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PublishersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PublishersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PublishersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> scraperType = const Value.absent(),
              }) => PublishersCompanion(
                id: id,
                name: name,
                url: url,
                sourceId: sourceId,
                scraperType: scraperType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String url,
                required String sourceId,
                Value<String> scraperType = const Value.absent(),
              }) => PublishersCompanion.insert(
                id: id,
                name: name,
                url: url,
                sourceId: sourceId,
                scraperType: scraperType,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PublishersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PublishersTable,
      Publisher,
      $$PublishersTableFilterComposer,
      $$PublishersTableOrderingComposer,
      $$PublishersTableAnnotationComposer,
      $$PublishersTableCreateCompanionBuilder,
      $$PublishersTableUpdateCompanionBuilder,
      (Publisher, BaseReferences<_$AppDatabase, $PublishersTable, Publisher>),
      Publisher,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
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

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$QuestionFoldersTableCreateCompanionBuilder =
    QuestionFoldersCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$QuestionFoldersTableUpdateCompanionBuilder =
    QuestionFoldersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$QuestionFoldersTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuestionFoldersTable, QuestionFolder> {
  $$QuestionFoldersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SavedQuestionsTable, List<SavedQuestion>>
  _savedQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savedQuestions,
    aliasName: $_aliasNameGenerator(
      db.questionFolders.id,
      db.savedQuestions.folderId,
    ),
  );

  $$SavedQuestionsTableProcessedTableManager get savedQuestionsRefs {
    final manager = $$SavedQuestionsTableTableManager(
      $_db,
      $_db.savedQuestions,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_savedQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestionFoldersTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionFoldersTable> {
  $$QuestionFoldersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> savedQuestionsRefs(
    Expression<bool> Function($$SavedQuestionsTableFilterComposer f) f,
  ) {
    final $$SavedQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedQuestions,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.savedQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionFoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionFoldersTable> {
  $$QuestionFoldersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionFoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionFoldersTable> {
  $$QuestionFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> savedQuestionsRefs<T extends Object>(
    Expression<T> Function($$SavedQuestionsTableAnnotationComposer a) f,
  ) {
    final $$SavedQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedQuestions,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.savedQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionFoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionFoldersTable,
          QuestionFolder,
          $$QuestionFoldersTableFilterComposer,
          $$QuestionFoldersTableOrderingComposer,
          $$QuestionFoldersTableAnnotationComposer,
          $$QuestionFoldersTableCreateCompanionBuilder,
          $$QuestionFoldersTableUpdateCompanionBuilder,
          (QuestionFolder, $$QuestionFoldersTableReferences),
          QuestionFolder,
          PrefetchHooks Function({bool savedQuestionsRefs})
        > {
  $$QuestionFoldersTableTableManager(
    _$AppDatabase db,
    $QuestionFoldersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuestionFoldersCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuestionFoldersCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionFoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({savedQuestionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (savedQuestionsRefs) db.savedQuestions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (savedQuestionsRefs)
                    await $_getPrefetchedData<
                      QuestionFolder,
                      $QuestionFoldersTable,
                      SavedQuestion
                    >(
                      currentTable: table,
                      referencedTable: $$QuestionFoldersTableReferences
                          ._savedQuestionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuestionFoldersTableReferences(
                            db,
                            table,
                            p0,
                          ).savedQuestionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.folderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuestionFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionFoldersTable,
      QuestionFolder,
      $$QuestionFoldersTableFilterComposer,
      $$QuestionFoldersTableOrderingComposer,
      $$QuestionFoldersTableAnnotationComposer,
      $$QuestionFoldersTableCreateCompanionBuilder,
      $$QuestionFoldersTableUpdateCompanionBuilder,
      (QuestionFolder, $$QuestionFoldersTableReferences),
      QuestionFolder,
      PrefetchHooks Function({bool savedQuestionsRefs})
    >;
typedef $$SavedQuestionsTableCreateCompanionBuilder =
    SavedQuestionsCompanion Function({
      Value<int> id,
      required int folderId,
      required String baseUrl,
      required String scraperType,
      required String bookId,
      required String chapterId,
      required String questionId,
      required String breadcrumbs,
      required String rawJson,
      Value<DateTime> savedAt,
    });
typedef $$SavedQuestionsTableUpdateCompanionBuilder =
    SavedQuestionsCompanion Function({
      Value<int> id,
      Value<int> folderId,
      Value<String> baseUrl,
      Value<String> scraperType,
      Value<String> bookId,
      Value<String> chapterId,
      Value<String> questionId,
      Value<String> breadcrumbs,
      Value<String> rawJson,
      Value<DateTime> savedAt,
    });

final class $$SavedQuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $SavedQuestionsTable, SavedQuestion> {
  $$SavedQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestionFoldersTable _folderIdTable(_$AppDatabase db) =>
      db.questionFolders.createAlias(
        $_aliasNameGenerator(db.savedQuestions.folderId, db.questionFolders.id),
      );

  $$QuestionFoldersTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<int>('folder_id')!;

    final manager = $$QuestionFoldersTableTableManager(
      $_db,
      $_db.questionFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavedQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedQuestionsTable> {
  $$SavedQuestionsTableFilterComposer({
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

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breadcrumbs => $composableBuilder(
    column: $table.breadcrumbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestionFoldersTableFilterComposer get folderId {
    final $$QuestionFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.questionFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionFoldersTableFilterComposer(
            $db: $db,
            $table: $db.questionFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedQuestionsTable> {
  $$SavedQuestionsTableOrderingComposer({
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

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breadcrumbs => $composableBuilder(
    column: $table.breadcrumbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestionFoldersTableOrderingComposer get folderId {
    final $$QuestionFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.questionFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.questionFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedQuestionsTable> {
  $$SavedQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get scraperType => $composableBuilder(
    column: $table.scraperType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breadcrumbs => $composableBuilder(
    column: $table.breadcrumbs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$QuestionFoldersTableAnnotationComposer get folderId {
    final $$QuestionFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.questionFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.questionFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedQuestionsTable,
          SavedQuestion,
          $$SavedQuestionsTableFilterComposer,
          $$SavedQuestionsTableOrderingComposer,
          $$SavedQuestionsTableAnnotationComposer,
          $$SavedQuestionsTableCreateCompanionBuilder,
          $$SavedQuestionsTableUpdateCompanionBuilder,
          (SavedQuestion, $$SavedQuestionsTableReferences),
          SavedQuestion,
          PrefetchHooks Function({bool folderId})
        > {
  $$SavedQuestionsTableTableManager(
    _$AppDatabase db,
    $SavedQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> folderId = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String> scraperType = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<String> breadcrumbs = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
              }) => SavedQuestionsCompanion(
                id: id,
                folderId: folderId,
                baseUrl: baseUrl,
                scraperType: scraperType,
                bookId: bookId,
                chapterId: chapterId,
                questionId: questionId,
                breadcrumbs: breadcrumbs,
                rawJson: rawJson,
                savedAt: savedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int folderId,
                required String baseUrl,
                required String scraperType,
                required String bookId,
                required String chapterId,
                required String questionId,
                required String breadcrumbs,
                required String rawJson,
                Value<DateTime> savedAt = const Value.absent(),
              }) => SavedQuestionsCompanion.insert(
                id: id,
                folderId: folderId,
                baseUrl: baseUrl,
                scraperType: scraperType,
                bookId: bookId,
                chapterId: chapterId,
                questionId: questionId,
                breadcrumbs: breadcrumbs,
                rawJson: rawJson,
                savedAt: savedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavedQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable: $$SavedQuestionsTableReferences
                                    ._folderIdTable(db),
                                referencedColumn:
                                    $$SavedQuestionsTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SavedQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedQuestionsTable,
      SavedQuestion,
      $$SavedQuestionsTableFilterComposer,
      $$SavedQuestionsTableOrderingComposer,
      $$SavedQuestionsTableAnnotationComposer,
      $$SavedQuestionsTableCreateCompanionBuilder,
      $$SavedQuestionsTableUpdateCompanionBuilder,
      (SavedQuestion, $$SavedQuestionsTableReferences),
      SavedQuestion,
      PrefetchHooks Function({bool folderId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$PublishersTableTableManager get publishers =>
      $$PublishersTableTableManager(_db, _db.publishers);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$QuestionFoldersTableTableManager get questionFolders =>
      $$QuestionFoldersTableTableManager(_db, _db.questionFolders);
  $$SavedQuestionsTableTableManager get savedQuestions =>
      $$SavedQuestionsTableTableManager(_db, _db.savedQuestions);
}
