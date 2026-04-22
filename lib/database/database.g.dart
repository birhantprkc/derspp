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
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES question_folders (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, parentId];
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
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
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
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
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
  final int? parentId;
  const QuestionFolder({
    required this.id,
    required this.name,
    required this.createdAt,
    this.parentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    return map;
  }

  QuestionFoldersCompanion toCompanion(bool nullToAbsent) {
    return QuestionFoldersCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
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
      parentId: serializer.fromJson<int?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'parentId': serializer.toJson<int?>(parentId),
    };
  }

  QuestionFolder copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    Value<int?> parentId = const Value.absent(),
  }) => QuestionFolder(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    parentId: parentId.present ? parentId.value : this.parentId,
  );
  QuestionFolder copyWithCompanion(QuestionFoldersCompanion data) {
    return QuestionFolder(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionFolder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionFolder &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.parentId == this.parentId);
}

class QuestionFoldersCompanion extends UpdateCompanion<QuestionFolder> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int?> parentId;
  const QuestionFoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  QuestionFoldersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.parentId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<QuestionFolder> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  QuestionFoldersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<int?>? parentId,
  }) {
    return QuestionFoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      parentId: parentId ?? this.parentId,
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
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionFoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('parentId: $parentId')
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _reviewStepMeta = const VerificationMeta(
    'reviewStep',
  );
  @override
  late final GeneratedColumn<int> reviewStep = GeneratedColumn<int>(
    'review_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewIntervalMeta =
      const VerificationMeta('lastReviewInterval');
  @override
  late final GeneratedColumn<int> lastReviewInterval = GeneratedColumn<int>(
    'last_review_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    notes,
    savedAt,
    nextReviewDate,
    reviewStep,
    lastReviewInterval,
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
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    }
    if (data.containsKey('review_step')) {
      context.handle(
        _reviewStepMeta,
        reviewStep.isAcceptableOrUnknown(data['review_step']!, _reviewStepMeta),
      );
    }
    if (data.containsKey('last_review_interval')) {
      context.handle(
        _lastReviewIntervalMeta,
        lastReviewInterval.isAcceptableOrUnknown(
          data['last_review_interval']!,
          _lastReviewIntervalMeta,
        ),
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
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      )!,
      reviewStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_step'],
      )!,
      lastReviewInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_review_interval'],
      ),
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
  final String? notes;
  final DateTime savedAt;
  final DateTime nextReviewDate;
  final int reviewStep;
  final int? lastReviewInterval;
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
    this.notes,
    required this.savedAt,
    required this.nextReviewDate,
    required this.reviewStep,
    this.lastReviewInterval,
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
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['saved_at'] = Variable<DateTime>(savedAt);
    map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    map['review_step'] = Variable<int>(reviewStep);
    if (!nullToAbsent || lastReviewInterval != null) {
      map['last_review_interval'] = Variable<int>(lastReviewInterval);
    }
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
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      savedAt: Value(savedAt),
      nextReviewDate: Value(nextReviewDate),
      reviewStep: Value(reviewStep),
      lastReviewInterval: lastReviewInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewInterval),
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
      notes: serializer.fromJson<String?>(json['notes']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
      nextReviewDate: serializer.fromJson<DateTime>(json['nextReviewDate']),
      reviewStep: serializer.fromJson<int>(json['reviewStep']),
      lastReviewInterval: serializer.fromJson<int?>(json['lastReviewInterval']),
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
      'notes': serializer.toJson<String?>(notes),
      'savedAt': serializer.toJson<DateTime>(savedAt),
      'nextReviewDate': serializer.toJson<DateTime>(nextReviewDate),
      'reviewStep': serializer.toJson<int>(reviewStep),
      'lastReviewInterval': serializer.toJson<int?>(lastReviewInterval),
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
    Value<String?> notes = const Value.absent(),
    DateTime? savedAt,
    DateTime? nextReviewDate,
    int? reviewStep,
    Value<int?> lastReviewInterval = const Value.absent(),
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
    notes: notes.present ? notes.value : this.notes,
    savedAt: savedAt ?? this.savedAt,
    nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    reviewStep: reviewStep ?? this.reviewStep,
    lastReviewInterval: lastReviewInterval.present
        ? lastReviewInterval.value
        : this.lastReviewInterval,
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
      notes: data.notes.present ? data.notes.value : this.notes,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      reviewStep: data.reviewStep.present
          ? data.reviewStep.value
          : this.reviewStep,
      lastReviewInterval: data.lastReviewInterval.present
          ? data.lastReviewInterval.value
          : this.lastReviewInterval,
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
          ..write('notes: $notes, ')
          ..write('savedAt: $savedAt, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('reviewStep: $reviewStep, ')
          ..write('lastReviewInterval: $lastReviewInterval')
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
    notes,
    savedAt,
    nextReviewDate,
    reviewStep,
    lastReviewInterval,
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
          other.notes == this.notes &&
          other.savedAt == this.savedAt &&
          other.nextReviewDate == this.nextReviewDate &&
          other.reviewStep == this.reviewStep &&
          other.lastReviewInterval == this.lastReviewInterval);
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
  final Value<String?> notes;
  final Value<DateTime> savedAt;
  final Value<DateTime> nextReviewDate;
  final Value<int> reviewStep;
  final Value<int?> lastReviewInterval;
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
    this.notes = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.reviewStep = const Value.absent(),
    this.lastReviewInterval = const Value.absent(),
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
    this.notes = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.reviewStep = const Value.absent(),
    this.lastReviewInterval = const Value.absent(),
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
    Expression<String>? notes,
    Expression<DateTime>? savedAt,
    Expression<DateTime>? nextReviewDate,
    Expression<int>? reviewStep,
    Expression<int>? lastReviewInterval,
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
      if (notes != null) 'notes': notes,
      if (savedAt != null) 'saved_at': savedAt,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (reviewStep != null) 'review_step': reviewStep,
      if (lastReviewInterval != null)
        'last_review_interval': lastReviewInterval,
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
    Value<String?>? notes,
    Value<DateTime>? savedAt,
    Value<DateTime>? nextReviewDate,
    Value<int>? reviewStep,
    Value<int?>? lastReviewInterval,
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
      notes: notes ?? this.notes,
      savedAt: savedAt ?? this.savedAt,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      reviewStep: reviewStep ?? this.reviewStep,
      lastReviewInterval: lastReviewInterval ?? this.lastReviewInterval,
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (reviewStep.present) {
      map['review_step'] = Variable<int>(reviewStep.value);
    }
    if (lastReviewInterval.present) {
      map['last_review_interval'] = Variable<int>(lastReviewInterval.value);
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
          ..write('notes: $notes, ')
          ..write('savedAt: $savedAt, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('reviewStep: $reviewStep, ')
          ..write('lastReviewInterval: $lastReviewInterval')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final DateTime date;
  final int type;
  const ReviewLog({required this.id, required this.date, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<int>(type);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
    );
  }

  factory ReviewLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<int>(type),
    };
  }

  ReviewLog copyWith({int? id, DateTime? date, int? type}) => ReviewLog(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
  );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> type;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
  });
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? type,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    isDone,
    dayIndex,
    category,
    date,
    startDate,
    frequency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;
  final bool isDone;
  final int dayIndex;
  final String category;
  final DateTime? date;
  final DateTime startDate;
  final int frequency;
  const Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.dayIndex,
    required this.category,
    this.date,
    required this.startDate,
    required this.frequency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['is_done'] = Variable<bool>(isDone);
    map['day_index'] = Variable<int>(dayIndex);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['frequency'] = Variable<int>(frequency);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      isDone: Value(isDone),
      dayIndex: Value(dayIndex),
      category: Value(category),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      startDate: Value(startDate),
      frequency: Value(frequency),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime?>(json['date']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      frequency: serializer.fromJson<int>(json['frequency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'isDone': serializer.toJson<bool>(isDone),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime?>(date),
      'startDate': serializer.toJson<DateTime>(startDate),
      'frequency': serializer.toJson<int>(frequency),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    bool? isDone,
    int? dayIndex,
    String? category,
    Value<DateTime?> date = const Value.absent(),
    DateTime? startDate,
    int? frequency,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    isDone: isDone ?? this.isDone,
    dayIndex: dayIndex ?? this.dayIndex,
    category: category ?? this.category,
    date: date.present ? date.value : this.date,
    startDate: startDate ?? this.startDate,
    frequency: frequency ?? this.frequency,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isDone: $isDone, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('startDate: $startDate, ')
          ..write('frequency: $frequency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    isDone,
    dayIndex,
    category,
    date,
    startDate,
    frequency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.isDone == this.isDone &&
          other.dayIndex == this.dayIndex &&
          other.category == this.category &&
          other.date == this.date &&
          other.startDate == this.startDate &&
          other.frequency == this.frequency);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<bool> isDone;
  final Value<int> dayIndex;
  final Value<String> category;
  final Value<DateTime?> date;
  final Value<DateTime> startDate;
  final Value<int> frequency;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isDone = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.startDate = const Value.absent(),
    this.frequency = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.isDone = const Value.absent(),
    required int dayIndex,
    required String category,
    this.date = const Value.absent(),
    this.startDate = const Value.absent(),
    this.frequency = const Value.absent(),
  }) : title = Value(title),
       dayIndex = Value(dayIndex),
       category = Value(category);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<bool>? isDone,
    Expression<int>? dayIndex,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<DateTime>? startDate,
    Expression<int>? frequency,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isDone != null) 'is_done': isDone,
      if (dayIndex != null) 'day_index': dayIndex,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (startDate != null) 'start_date': startDate,
      if (frequency != null) 'frequency': frequency,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<bool>? isDone,
    Value<int>? dayIndex,
    Value<String>? category,
    Value<DateTime?>? date,
    Value<DateTime>? startDate,
    Value<int>? frequency,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dayIndex: dayIndex ?? this.dayIndex,
      category: category ?? this.category,
      date: date ?? this.date,
      startDate: startDate ?? this.startDate,
      frequency: frequency ?? this.frequency,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isDone: $isDone, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('startDate: $startDate, ')
          ..write('frequency: $frequency')
          ..write(')'))
        .toString();
  }
}

class $RoutineCompletionsTable extends RoutineCompletions
    with TableInfo<$RoutineCompletionsTable, RoutineCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineCompletionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $RoutineCompletionsTable createAlias(String alias) {
    return $RoutineCompletionsTable(attachedDatabase, alias);
  }
}

class RoutineCompletion extends DataClass
    implements Insertable<RoutineCompletion> {
  final int id;
  final int taskId;
  final DateTime date;
  const RoutineCompletion({
    required this.id,
    required this.taskId,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<int>(taskId);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  RoutineCompletionsCompanion toCompanion(bool nullToAbsent) {
    return RoutineCompletionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      date: Value(date),
    );
  }

  factory RoutineCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineCompletion(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<int>(json['taskId']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<int>(taskId),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  RoutineCompletion copyWith({int? id, int? taskId, DateTime? date}) =>
      RoutineCompletion(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        date: date ?? this.date,
      );
  RoutineCompletion copyWithCompanion(RoutineCompletionsCompanion data) {
    return RoutineCompletion(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineCompletion &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.date == this.date);
}

class RoutineCompletionsCompanion extends UpdateCompanion<RoutineCompletion> {
  final Value<int> id;
  final Value<int> taskId;
  final Value<DateTime> date;
  const RoutineCompletionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.date = const Value.absent(),
  });
  RoutineCompletionsCompanion.insert({
    this.id = const Value.absent(),
    required int taskId,
    required DateTime date,
  }) : taskId = Value(taskId),
       date = Value(date);
  static Insertable<RoutineCompletion> custom({
    Expression<int>? id,
    Expression<int>? taskId,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (date != null) 'date': date,
    });
  }

  RoutineCompletionsCompanion copyWith({
    Value<int>? id,
    Value<int>? taskId,
    Value<DateTime>? date,
  }) {
    return RoutineCompletionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $StudySubjectsTable extends StudySubjects
    with TableInfo<$StudySubjectsTable, StudySubject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySubjectsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_subjects (id)',
    ),
  );
  static const VerificationMeta _isLeafMeta = const VerificationMeta('isLeaf');
  @override
  late final GeneratedColumn<bool> isLeaf = GeneratedColumn<bool>(
    'is_leaf',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_leaf" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isKnownMeta = const VerificationMeta(
    'isKnown',
  );
  @override
  late final GeneratedColumn<bool> isKnown = GeneratedColumn<bool>(
    'is_known',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_known" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastReviewIntervalMeta =
      const VerificationMeta('lastReviewInterval');
  @override
  late final GeneratedColumn<int> lastReviewInterval = GeneratedColumn<int>(
    'last_review_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncWithFolderIdMeta = const VerificationMeta(
    'syncWithFolderId',
  );
  @override
  late final GeneratedColumn<int> syncWithFolderId = GeneratedColumn<int>(
    'sync_with_folder_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES question_folders (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    isLeaf,
    isKnown,
    nextReviewDate,
    lastReviewInterval,
    syncWithFolderId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySubject> instance, {
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
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_leaf')) {
      context.handle(
        _isLeafMeta,
        isLeaf.isAcceptableOrUnknown(data['is_leaf']!, _isLeafMeta),
      );
    }
    if (data.containsKey('is_known')) {
      context.handle(
        _isKnownMeta,
        isKnown.isAcceptableOrUnknown(data['is_known']!, _isKnownMeta),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    }
    if (data.containsKey('last_review_interval')) {
      context.handle(
        _lastReviewIntervalMeta,
        lastReviewInterval.isAcceptableOrUnknown(
          data['last_review_interval']!,
          _lastReviewIntervalMeta,
        ),
      );
    }
    if (data.containsKey('sync_with_folder_id')) {
      context.handle(
        _syncWithFolderIdMeta,
        syncWithFolderId.isAcceptableOrUnknown(
          data['sync_with_folder_id']!,
          _syncWithFolderIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySubject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySubject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      isLeaf: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_leaf'],
      )!,
      isKnown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_known'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      ),
      lastReviewInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_review_interval'],
      ),
      syncWithFolderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_with_folder_id'],
      ),
    );
  }

  @override
  $StudySubjectsTable createAlias(String alias) {
    return $StudySubjectsTable(attachedDatabase, alias);
  }
}

class StudySubject extends DataClass implements Insertable<StudySubject> {
  final int id;
  final String name;
  final int? parentId;
  final bool isLeaf;
  final bool isKnown;
  final DateTime? nextReviewDate;
  final int? lastReviewInterval;
  final int? syncWithFolderId;
  const StudySubject({
    required this.id,
    required this.name,
    this.parentId,
    required this.isLeaf,
    required this.isKnown,
    this.nextReviewDate,
    this.lastReviewInterval,
    this.syncWithFolderId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['is_leaf'] = Variable<bool>(isLeaf);
    map['is_known'] = Variable<bool>(isKnown);
    if (!nullToAbsent || nextReviewDate != null) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    }
    if (!nullToAbsent || lastReviewInterval != null) {
      map['last_review_interval'] = Variable<int>(lastReviewInterval);
    }
    if (!nullToAbsent || syncWithFolderId != null) {
      map['sync_with_folder_id'] = Variable<int>(syncWithFolderId);
    }
    return map;
  }

  StudySubjectsCompanion toCompanion(bool nullToAbsent) {
    return StudySubjectsCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isLeaf: Value(isLeaf),
      isKnown: Value(isKnown),
      nextReviewDate: nextReviewDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewDate),
      lastReviewInterval: lastReviewInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewInterval),
      syncWithFolderId: syncWithFolderId == null && nullToAbsent
          ? const Value.absent()
          : Value(syncWithFolderId),
    );
  }

  factory StudySubject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySubject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      isLeaf: serializer.fromJson<bool>(json['isLeaf']),
      isKnown: serializer.fromJson<bool>(json['isKnown']),
      nextReviewDate: serializer.fromJson<DateTime?>(json['nextReviewDate']),
      lastReviewInterval: serializer.fromJson<int?>(json['lastReviewInterval']),
      syncWithFolderId: serializer.fromJson<int?>(json['syncWithFolderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'isLeaf': serializer.toJson<bool>(isLeaf),
      'isKnown': serializer.toJson<bool>(isKnown),
      'nextReviewDate': serializer.toJson<DateTime?>(nextReviewDate),
      'lastReviewInterval': serializer.toJson<int?>(lastReviewInterval),
      'syncWithFolderId': serializer.toJson<int?>(syncWithFolderId),
    };
  }

  StudySubject copyWith({
    int? id,
    String? name,
    Value<int?> parentId = const Value.absent(),
    bool? isLeaf,
    bool? isKnown,
    Value<DateTime?> nextReviewDate = const Value.absent(),
    Value<int?> lastReviewInterval = const Value.absent(),
    Value<int?> syncWithFolderId = const Value.absent(),
  }) => StudySubject(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    isLeaf: isLeaf ?? this.isLeaf,
    isKnown: isKnown ?? this.isKnown,
    nextReviewDate: nextReviewDate.present
        ? nextReviewDate.value
        : this.nextReviewDate,
    lastReviewInterval: lastReviewInterval.present
        ? lastReviewInterval.value
        : this.lastReviewInterval,
    syncWithFolderId: syncWithFolderId.present
        ? syncWithFolderId.value
        : this.syncWithFolderId,
  );
  StudySubject copyWithCompanion(StudySubjectsCompanion data) {
    return StudySubject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isLeaf: data.isLeaf.present ? data.isLeaf.value : this.isLeaf,
      isKnown: data.isKnown.present ? data.isKnown.value : this.isKnown,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      lastReviewInterval: data.lastReviewInterval.present
          ? data.lastReviewInterval.value
          : this.lastReviewInterval,
      syncWithFolderId: data.syncWithFolderId.present
          ? data.syncWithFolderId.value
          : this.syncWithFolderId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySubject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('isLeaf: $isLeaf, ')
          ..write('isKnown: $isKnown, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('lastReviewInterval: $lastReviewInterval, ')
          ..write('syncWithFolderId: $syncWithFolderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentId,
    isLeaf,
    isKnown,
    nextReviewDate,
    lastReviewInterval,
    syncWithFolderId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySubject &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.isLeaf == this.isLeaf &&
          other.isKnown == this.isKnown &&
          other.nextReviewDate == this.nextReviewDate &&
          other.lastReviewInterval == this.lastReviewInterval &&
          other.syncWithFolderId == this.syncWithFolderId);
}

class StudySubjectsCompanion extends UpdateCompanion<StudySubject> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<bool> isLeaf;
  final Value<bool> isKnown;
  final Value<DateTime?> nextReviewDate;
  final Value<int?> lastReviewInterval;
  final Value<int?> syncWithFolderId;
  const StudySubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isLeaf = const Value.absent(),
    this.isKnown = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.lastReviewInterval = const Value.absent(),
    this.syncWithFolderId = const Value.absent(),
  });
  StudySubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    this.isLeaf = const Value.absent(),
    this.isKnown = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.lastReviewInterval = const Value.absent(),
    this.syncWithFolderId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<StudySubject> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<bool>? isLeaf,
    Expression<bool>? isKnown,
    Expression<DateTime>? nextReviewDate,
    Expression<int>? lastReviewInterval,
    Expression<int>? syncWithFolderId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (isLeaf != null) 'is_leaf': isLeaf,
      if (isKnown != null) 'is_known': isKnown,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (lastReviewInterval != null)
        'last_review_interval': lastReviewInterval,
      if (syncWithFolderId != null) 'sync_with_folder_id': syncWithFolderId,
    });
  }

  StudySubjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
    Value<bool>? isLeaf,
    Value<bool>? isKnown,
    Value<DateTime?>? nextReviewDate,
    Value<int?>? lastReviewInterval,
    Value<int?>? syncWithFolderId,
  }) {
    return StudySubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      isLeaf: isLeaf ?? this.isLeaf,
      isKnown: isKnown ?? this.isKnown,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewInterval: lastReviewInterval ?? this.lastReviewInterval,
      syncWithFolderId: syncWithFolderId ?? this.syncWithFolderId,
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
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (isLeaf.present) {
      map['is_leaf'] = Variable<bool>(isLeaf.value);
    }
    if (isKnown.present) {
      map['is_known'] = Variable<bool>(isKnown.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (lastReviewInterval.present) {
      map['last_review_interval'] = Variable<int>(lastReviewInterval.value);
    }
    if (syncWithFolderId.present) {
      map['sync_with_folder_id'] = Variable<int>(syncWithFolderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('isLeaf: $isLeaf, ')
          ..write('isKnown: $isKnown, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('lastReviewInterval: $lastReviewInterval, ')
          ..write('syncWithFolderId: $syncWithFolderId')
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
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $RoutineCompletionsTable routineCompletions =
      $RoutineCompletionsTable(this);
  late final $StudySubjectsTable studySubjects = $StudySubjectsTable(this);
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
    reviewLogs,
    tasks,
    routineCompletions,
    studySubjects,
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
      Value<int?> parentId,
    });
typedef $$QuestionFoldersTableUpdateCompanionBuilder =
    QuestionFoldersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<int?> parentId,
    });

final class $$QuestionFoldersTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuestionFoldersTable, QuestionFolder> {
  $$QuestionFoldersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestionFoldersTable _parentIdTable(_$AppDatabase db) =>
      db.questionFolders.createAlias(
        $_aliasNameGenerator(
          db.questionFolders.parentId,
          db.questionFolders.id,
        ),
      );

  $$QuestionFoldersTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$QuestionFoldersTableTableManager(
      $_db,
      $_db.questionFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

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

  static MultiTypedResultKey<$StudySubjectsTable, List<StudySubject>>
  _studySubjectsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studySubjects,
    aliasName: $_aliasNameGenerator(
      db.questionFolders.id,
      db.studySubjects.syncWithFolderId,
    ),
  );

  $$StudySubjectsTableProcessedTableManager get studySubjectsRefs {
    final manager = $$StudySubjectsTableTableManager(
      $_db,
      $_db.studySubjects,
    ).filter((f) => f.syncWithFolderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studySubjectsRefsTable($_db));
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

  $$QuestionFoldersTableFilterComposer get parentId {
    final $$QuestionFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
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

  Expression<bool> studySubjectsRefs(
    Expression<bool> Function($$StudySubjectsTableFilterComposer f) f,
  ) {
    final $$StudySubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySubjects,
      getReferencedColumn: (t) => t.syncWithFolderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySubjectsTableFilterComposer(
            $db: $db,
            $table: $db.studySubjects,
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

  $$QuestionFoldersTableOrderingComposer get parentId {
    final $$QuestionFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
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

  $$QuestionFoldersTableAnnotationComposer get parentId {
    final $$QuestionFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
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

  Expression<T> studySubjectsRefs<T extends Object>(
    Expression<T> Function($$StudySubjectsTableAnnotationComposer a) f,
  ) {
    final $$StudySubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySubjects,
      getReferencedColumn: (t) => t.syncWithFolderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySubjects,
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
          PrefetchHooks Function({
            bool parentId,
            bool savedQuestionsRefs,
            bool studySubjectsRefs,
          })
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
                Value<int?> parentId = const Value.absent(),
              }) => QuestionFoldersCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                parentId: parentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
              }) => QuestionFoldersCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                parentId: parentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionFoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                savedQuestionsRefs = false,
                studySubjectsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (savedQuestionsRefs) db.savedQuestions,
                    if (studySubjectsRefs) db.studySubjects,
                  ],
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
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable:
                                        $$QuestionFoldersTableReferences
                                            ._parentIdTable(db),
                                    referencedColumn:
                                        $$QuestionFoldersTableReferences
                                            ._parentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studySubjectsRefs)
                        await $_getPrefetchedData<
                          QuestionFolder,
                          $QuestionFoldersTable,
                          StudySubject
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionFoldersTableReferences
                              ._studySubjectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionFoldersTableReferences(
                                db,
                                table,
                                p0,
                              ).studySubjectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.syncWithFolderId == item.id,
                              ),
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
      PrefetchHooks Function({
        bool parentId,
        bool savedQuestionsRefs,
        bool studySubjectsRefs,
      })
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
      Value<String?> notes,
      Value<DateTime> savedAt,
      Value<DateTime> nextReviewDate,
      Value<int> reviewStep,
      Value<int?> lastReviewInterval,
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
      Value<String?> notes,
      Value<DateTime> savedAt,
      Value<DateTime> nextReviewDate,
      Value<int> reviewStep,
      Value<int?> lastReviewInterval,
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewStep => $composableBuilder(
    column: $table.reviewStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewInterval => $composableBuilder(
    column: $table.lastReviewInterval,
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewStep => $composableBuilder(
    column: $table.reviewStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewInterval => $composableBuilder(
    column: $table.lastReviewInterval,
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

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewStep => $composableBuilder(
    column: $table.reviewStep,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReviewInterval => $composableBuilder(
    column: $table.lastReviewInterval,
    builder: (column) => column,
  );

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
                Value<String?> notes = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<DateTime> nextReviewDate = const Value.absent(),
                Value<int> reviewStep = const Value.absent(),
                Value<int?> lastReviewInterval = const Value.absent(),
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
                notes: notes,
                savedAt: savedAt,
                nextReviewDate: nextReviewDate,
                reviewStep: reviewStep,
                lastReviewInterval: lastReviewInterval,
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
                Value<String?> notes = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<DateTime> nextReviewDate = const Value.absent(),
                Value<int> reviewStep = const Value.absent(),
                Value<int?> lastReviewInterval = const Value.absent(),
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
                notes: notes,
                savedAt: savedAt,
                nextReviewDate: nextReviewDate,
                reviewStep: reviewStep,
                lastReviewInterval: lastReviewInterval,
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
typedef $$ReviewLogsTableCreateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> type,
    });
typedef $$ReviewLogsTableUpdateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> type,
    });

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLog,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (
            ReviewLog,
            BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog>,
          ),
          ReviewLog,
          PrefetchHooks Function()
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => ReviewLogsCompanion(id: id, date: date, type: type),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => ReviewLogsCompanion.insert(id: id, date: date, type: type),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLog,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLog, BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog>),
      ReviewLog,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required String title,
      Value<bool> isDone,
      required int dayIndex,
      required String category,
      Value<DateTime?> date,
      Value<DateTime> startDate,
      Value<int> frequency,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<bool> isDone,
      Value<int> dayIndex,
      Value<String> category,
      Value<DateTime?> date,
      Value<DateTime> startDate,
      Value<int> frequency,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineCompletionsTable, List<RoutineCompletion>>
  _routineCompletionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineCompletions,
        aliasName: $_aliasNameGenerator(
          db.tasks.id,
          db.routineCompletions.taskId,
        ),
      );

  $$RoutineCompletionsTableProcessedTableManager get routineCompletionsRefs {
    final manager = $$RoutineCompletionsTableTableManager(
      $_db,
      $_db.routineCompletions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineCompletionsRefs(
    Expression<bool> Function($$RoutineCompletionsTableFilterComposer f) f,
  ) {
    final $$RoutineCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineCompletions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.routineCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  Expression<T> routineCompletionsRefs<T extends Object>(
    Expression<T> Function($$RoutineCompletionsTableAnnotationComposer a) f,
  ) {
    final $$RoutineCompletionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineCompletions,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineCompletionsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineCompletions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool routineCompletionsRefs})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime?> date = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> frequency = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                isDone: isDone,
                dayIndex: dayIndex,
                category: category,
                date: date,
                startDate: startDate,
                frequency: frequency,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<bool> isDone = const Value.absent(),
                required int dayIndex,
                required String category,
                Value<DateTime?> date = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> frequency = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                isDone: isDone,
                dayIndex: dayIndex,
                category: category,
                date: date,
                startDate: startDate,
                frequency: frequency,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({routineCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineCompletionsRefs) db.routineCompletions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineCompletionsRefs)
                    await $_getPrefetchedData<
                      Task,
                      $TasksTable,
                      RoutineCompletion
                    >(
                      currentTable: table,
                      referencedTable: $$TasksTableReferences
                          ._routineCompletionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TasksTableReferences(
                        db,
                        table,
                        p0,
                      ).routineCompletionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool routineCompletionsRefs})
    >;
typedef $$RoutineCompletionsTableCreateCompanionBuilder =
    RoutineCompletionsCompanion Function({
      Value<int> id,
      required int taskId,
      required DateTime date,
    });
typedef $$RoutineCompletionsTableUpdateCompanionBuilder =
    RoutineCompletionsCompanion Function({
      Value<int> id,
      Value<int> taskId,
      Value<DateTime> date,
    });

final class $$RoutineCompletionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RoutineCompletionsTable,
          RoutineCompletion
        > {
  $$RoutineCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.routineCompletions.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineCompletionsTable,
          RoutineCompletion,
          $$RoutineCompletionsTableFilterComposer,
          $$RoutineCompletionsTableOrderingComposer,
          $$RoutineCompletionsTableAnnotationComposer,
          $$RoutineCompletionsTableCreateCompanionBuilder,
          $$RoutineCompletionsTableUpdateCompanionBuilder,
          (RoutineCompletion, $$RoutineCompletionsTableReferences),
          RoutineCompletion,
          PrefetchHooks Function({bool taskId})
        > {
  $$RoutineCompletionsTableTableManager(
    _$AppDatabase db,
    $RoutineCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineCompletionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => RoutineCompletionsCompanion(
                id: id,
                taskId: taskId,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taskId,
                required DateTime date,
              }) => RoutineCompletionsCompanion.insert(
                id: id,
                taskId: taskId,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
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
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$RoutineCompletionsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$RoutineCompletionsTableReferences
                                        ._taskIdTable(db)
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

typedef $$RoutineCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineCompletionsTable,
      RoutineCompletion,
      $$RoutineCompletionsTableFilterComposer,
      $$RoutineCompletionsTableOrderingComposer,
      $$RoutineCompletionsTableAnnotationComposer,
      $$RoutineCompletionsTableCreateCompanionBuilder,
      $$RoutineCompletionsTableUpdateCompanionBuilder,
      (RoutineCompletion, $$RoutineCompletionsTableReferences),
      RoutineCompletion,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$StudySubjectsTableCreateCompanionBuilder =
    StudySubjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> parentId,
      Value<bool> isLeaf,
      Value<bool> isKnown,
      Value<DateTime?> nextReviewDate,
      Value<int?> lastReviewInterval,
      Value<int?> syncWithFolderId,
    });
typedef $$StudySubjectsTableUpdateCompanionBuilder =
    StudySubjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> parentId,
      Value<bool> isLeaf,
      Value<bool> isKnown,
      Value<DateTime?> nextReviewDate,
      Value<int?> lastReviewInterval,
      Value<int?> syncWithFolderId,
    });

final class $$StudySubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $StudySubjectsTable, StudySubject> {
  $$StudySubjectsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudySubjectsTable _parentIdTable(_$AppDatabase db) =>
      db.studySubjects.createAlias(
        $_aliasNameGenerator(db.studySubjects.parentId, db.studySubjects.id),
      );

  $$StudySubjectsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$StudySubjectsTableTableManager(
      $_db,
      $_db.studySubjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuestionFoldersTable _syncWithFolderIdTable(_$AppDatabase db) =>
      db.questionFolders.createAlias(
        $_aliasNameGenerator(
          db.studySubjects.syncWithFolderId,
          db.questionFolders.id,
        ),
      );

  $$QuestionFoldersTableProcessedTableManager? get syncWithFolderId {
    final $_column = $_itemColumn<int>('sync_with_folder_id');
    if ($_column == null) return null;
    final manager = $$QuestionFoldersTableTableManager(
      $_db,
      $_db.questionFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_syncWithFolderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudySubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySubjectsTable> {
  $$StudySubjectsTableFilterComposer({
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

  ColumnFilters<bool> get isLeaf => $composableBuilder(
    column: $table.isLeaf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isKnown => $composableBuilder(
    column: $table.isKnown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewInterval => $composableBuilder(
    column: $table.lastReviewInterval,
    builder: (column) => ColumnFilters(column),
  );

  $$StudySubjectsTableFilterComposer get parentId {
    final $$StudySubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.studySubjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySubjectsTableFilterComposer(
            $db: $db,
            $table: $db.studySubjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionFoldersTableFilterComposer get syncWithFolderId {
    final $$QuestionFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.syncWithFolderId,
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

class $$StudySubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySubjectsTable> {
  $$StudySubjectsTableOrderingComposer({
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

  ColumnOrderings<bool> get isLeaf => $composableBuilder(
    column: $table.isLeaf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isKnown => $composableBuilder(
    column: $table.isKnown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewInterval => $composableBuilder(
    column: $table.lastReviewInterval,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudySubjectsTableOrderingComposer get parentId {
    final $$StudySubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.studySubjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.studySubjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionFoldersTableOrderingComposer get syncWithFolderId {
    final $$QuestionFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.syncWithFolderId,
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

class $$StudySubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySubjectsTable> {
  $$StudySubjectsTableAnnotationComposer({
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

  GeneratedColumn<bool> get isLeaf =>
      $composableBuilder(column: $table.isLeaf, builder: (column) => column);

  GeneratedColumn<bool> get isKnown =>
      $composableBuilder(column: $table.isKnown, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReviewInterval => $composableBuilder(
    column: $table.lastReviewInterval,
    builder: (column) => column,
  );

  $$StudySubjectsTableAnnotationComposer get parentId {
    final $$StudySubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.studySubjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySubjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionFoldersTableAnnotationComposer get syncWithFolderId {
    final $$QuestionFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.syncWithFolderId,
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

class $$StudySubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySubjectsTable,
          StudySubject,
          $$StudySubjectsTableFilterComposer,
          $$StudySubjectsTableOrderingComposer,
          $$StudySubjectsTableAnnotationComposer,
          $$StudySubjectsTableCreateCompanionBuilder,
          $$StudySubjectsTableUpdateCompanionBuilder,
          (StudySubject, $$StudySubjectsTableReferences),
          StudySubject,
          PrefetchHooks Function({bool parentId, bool syncWithFolderId})
        > {
  $$StudySubjectsTableTableManager(_$AppDatabase db, $StudySubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<bool> isLeaf = const Value.absent(),
                Value<bool> isKnown = const Value.absent(),
                Value<DateTime?> nextReviewDate = const Value.absent(),
                Value<int?> lastReviewInterval = const Value.absent(),
                Value<int?> syncWithFolderId = const Value.absent(),
              }) => StudySubjectsCompanion(
                id: id,
                name: name,
                parentId: parentId,
                isLeaf: isLeaf,
                isKnown: isKnown,
                nextReviewDate: nextReviewDate,
                lastReviewInterval: lastReviewInterval,
                syncWithFolderId: syncWithFolderId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> parentId = const Value.absent(),
                Value<bool> isLeaf = const Value.absent(),
                Value<bool> isKnown = const Value.absent(),
                Value<DateTime?> nextReviewDate = const Value.absent(),
                Value<int?> lastReviewInterval = const Value.absent(),
                Value<int?> syncWithFolderId = const Value.absent(),
              }) => StudySubjectsCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                isLeaf: isLeaf,
                isKnown: isKnown,
                nextReviewDate: nextReviewDate,
                lastReviewInterval: lastReviewInterval,
                syncWithFolderId: syncWithFolderId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudySubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({parentId = false, syncWithFolderId = false}) {
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
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable:
                                        $$StudySubjectsTableReferences
                                            ._parentIdTable(db),
                                    referencedColumn:
                                        $$StudySubjectsTableReferences
                                            ._parentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (syncWithFolderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.syncWithFolderId,
                                    referencedTable:
                                        $$StudySubjectsTableReferences
                                            ._syncWithFolderIdTable(db),
                                    referencedColumn:
                                        $$StudySubjectsTableReferences
                                            ._syncWithFolderIdTable(db)
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

typedef $$StudySubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySubjectsTable,
      StudySubject,
      $$StudySubjectsTableFilterComposer,
      $$StudySubjectsTableOrderingComposer,
      $$StudySubjectsTableAnnotationComposer,
      $$StudySubjectsTableCreateCompanionBuilder,
      $$StudySubjectsTableUpdateCompanionBuilder,
      (StudySubject, $$StudySubjectsTableReferences),
      StudySubject,
      PrefetchHooks Function({bool parentId, bool syncWithFolderId})
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
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$RoutineCompletionsTableTableManager get routineCompletions =>
      $$RoutineCompletionsTableTableManager(_db, _db.routineCompletions);
  $$StudySubjectsTableTableManager get studySubjects =>
      $$StudySubjectsTableTableManager(_db, _db.studySubjects);
}
