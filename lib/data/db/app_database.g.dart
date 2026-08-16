// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DiariesTable extends Diaries with TableInfo<$DiariesTable, Diary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherMeta = const VerificationMeta(
    'weather',
  );
  @override
  late final GeneratedColumn<String> weather = GeneratedColumn<String>(
    'weather',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<String> temperature = GeneratedColumn<String>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<String> device = GeneratedColumn<String>(
    'device',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncRevMeta = const VerificationMeta(
    'syncRev',
  );
  @override
  late final GeneratedColumn<int> syncRev = GeneratedColumn<int>(
    'sync_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryDate,
    createdAt,
    updatedAt,
    title,
    body,
    mood,
    weather,
    temperature,
    locationName,
    lat,
    lng,
    device,
    wordCount,
    isFavorite,
    isDeleted,
    deletedAt,
    syncRev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Diary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('weather')) {
      context.handle(
        _weatherMeta,
        weather.isAcceptableOrUnknown(data['weather']!, _weatherMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('device')) {
      context.handle(
        _deviceMeta,
        device.isAcceptableOrUnknown(data['device']!, _deviceMeta),
      );
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_rev')) {
      context.handle(
        _syncRevMeta,
        syncRev.isAcceptableOrUnknown(data['sync_rev']!, _syncRevMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Diary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Diary(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      ),
      weather: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temperature'],
      ),
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      device: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device'],
      ),
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_rev'],
      )!,
    );
  }

  @override
  $DiariesTable createAlias(String alias) {
    return $DiariesTable(attachedDatabase, alias);
  }
}

class Diary extends DataClass implements Insertable<Diary> {
  final String id;

  /// 归属日期（用于按天分组，规整到当天 00:00）
  final DateTime entryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? title;

  /// M1：正文以纯文本存储；后续里程碑扩展为块结构 JSON
  final String body;
  final String? mood;
  final String? weather;
  final String? temperature;
  final String? locationName;
  final double? lat;
  final double? lng;
  final String? device;
  final int wordCount;
  final bool isFavorite;
  final bool isDeleted;
  final DateTime? deletedAt;
  final int syncRev;
  const Diary({
    required this.id,
    required this.entryDate,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    required this.body,
    this.mood,
    this.weather,
    this.temperature,
    this.locationName,
    this.lat,
    this.lng,
    this.device,
    required this.wordCount,
    required this.isFavorite,
    required this.isDeleted,
    this.deletedAt,
    required this.syncRev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_date'] = Variable<DateTime>(entryDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    if (!nullToAbsent || weather != null) {
      map['weather'] = Variable<String>(weather);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<String>(temperature);
    }
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<String>(device);
    }
    map['word_count'] = Variable<int>(wordCount);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_rev'] = Variable<int>(syncRev);
    return map;
  }

  DiariesCompanion toCompanion(bool nullToAbsent) {
    return DiariesCompanion(
      id: Value(id),
      entryDate: Value(entryDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      body: Value(body),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      device: device == null && nullToAbsent
          ? const Value.absent()
          : Value(device),
      wordCount: Value(wordCount),
      isFavorite: Value(isFavorite),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncRev: Value(syncRev),
    );
  }

  factory Diary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Diary(
      id: serializer.fromJson<String>(json['id']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      mood: serializer.fromJson<String?>(json['mood']),
      weather: serializer.fromJson<String?>(json['weather']),
      temperature: serializer.fromJson<String?>(json['temperature']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      device: serializer.fromJson<String?>(json['device']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncRev: serializer.fromJson<int>(json['syncRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String>(body),
      'mood': serializer.toJson<String?>(mood),
      'weather': serializer.toJson<String?>(weather),
      'temperature': serializer.toJson<String?>(temperature),
      'locationName': serializer.toJson<String?>(locationName),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'device': serializer.toJson<String?>(device),
      'wordCount': serializer.toJson<int>(wordCount),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncRev': serializer.toJson<int>(syncRev),
    };
  }

  Diary copyWith({
    String? id,
    DateTime? entryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> title = const Value.absent(),
    String? body,
    Value<String?> mood = const Value.absent(),
    Value<String?> weather = const Value.absent(),
    Value<String?> temperature = const Value.absent(),
    Value<String?> locationName = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<String?> device = const Value.absent(),
    int? wordCount,
    bool? isFavorite,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? syncRev,
  }) => Diary(
    id: id ?? this.id,
    entryDate: entryDate ?? this.entryDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    title: title.present ? title.value : this.title,
    body: body ?? this.body,
    mood: mood.present ? mood.value : this.mood,
    weather: weather.present ? weather.value : this.weather,
    temperature: temperature.present ? temperature.value : this.temperature,
    locationName: locationName.present ? locationName.value : this.locationName,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    device: device.present ? device.value : this.device,
    wordCount: wordCount ?? this.wordCount,
    isFavorite: isFavorite ?? this.isFavorite,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncRev: syncRev ?? this.syncRev,
  );
  Diary copyWithCompanion(DiariesCompanion data) {
    return Diary(
      id: data.id.present ? data.id.value : this.id,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      mood: data.mood.present ? data.mood.value : this.mood,
      weather: data.weather.present ? data.weather.value : this.weather,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      device: data.device.present ? data.device.value : this.device,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncRev: data.syncRev.present ? data.syncRev.value : this.syncRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Diary(')
          ..write('id: $id, ')
          ..write('entryDate: $entryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('mood: $mood, ')
          ..write('weather: $weather, ')
          ..write('temperature: $temperature, ')
          ..write('locationName: $locationName, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('device: $device, ')
          ..write('wordCount: $wordCount, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncRev: $syncRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryDate,
    createdAt,
    updatedAt,
    title,
    body,
    mood,
    weather,
    temperature,
    locationName,
    lat,
    lng,
    device,
    wordCount,
    isFavorite,
    isDeleted,
    deletedAt,
    syncRev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diary &&
          other.id == this.id &&
          other.entryDate == this.entryDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.body == this.body &&
          other.mood == this.mood &&
          other.weather == this.weather &&
          other.temperature == this.temperature &&
          other.locationName == this.locationName &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.device == this.device &&
          other.wordCount == this.wordCount &&
          other.isFavorite == this.isFavorite &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncRev == this.syncRev);
}

class DiariesCompanion extends UpdateCompanion<Diary> {
  final Value<String> id;
  final Value<DateTime> entryDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> title;
  final Value<String> body;
  final Value<String?> mood;
  final Value<String?> weather;
  final Value<String?> temperature;
  final Value<String?> locationName;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> device;
  final Value<int> wordCount;
  final Value<bool> isFavorite;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<int> syncRev;
  final Value<int> rowid;
  const DiariesCompanion({
    this.id = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.mood = const Value.absent(),
    this.weather = const Value.absent(),
    this.temperature = const Value.absent(),
    this.locationName = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.device = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiariesCompanion.insert({
    required String id,
    required DateTime entryDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.mood = const Value.absent(),
    this.weather = const Value.absent(),
    this.temperature = const Value.absent(),
    this.locationName = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.device = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncRev = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryDate = Value(entryDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Diary> custom({
    Expression<String>? id,
    Expression<DateTime>? entryDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? mood,
    Expression<String>? weather,
    Expression<String>? temperature,
    Expression<String>? locationName,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? device,
    Expression<int>? wordCount,
    Expression<bool>? isFavorite,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<int>? syncRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryDate != null) 'entry_date': entryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (mood != null) 'mood': mood,
      if (weather != null) 'weather': weather,
      if (temperature != null) 'temperature': temperature,
      if (locationName != null) 'location_name': locationName,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (device != null) 'device': device,
      if (wordCount != null) 'word_count': wordCount,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncRev != null) 'sync_rev': syncRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiariesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? entryDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? title,
    Value<String>? body,
    Value<String?>? mood,
    Value<String?>? weather,
    Value<String?>? temperature,
    Value<String?>? locationName,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<String?>? device,
    Value<int>? wordCount,
    Value<bool>? isFavorite,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<int>? syncRev,
    Value<int>? rowid,
  }) {
    return DiariesCompanion(
      id: id ?? this.id,
      entryDate: entryDate ?? this.entryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      body: body ?? this.body,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
      temperature: temperature ?? this.temperature,
      locationName: locationName ?? this.locationName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      device: device ?? this.device,
      wordCount: wordCount ?? this.wordCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncRev: syncRev ?? this.syncRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (weather.present) {
      map['weather'] = Variable<String>(weather.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<String>(temperature.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (device.present) {
      map['device'] = Variable<String>(device.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncRev.present) {
      map['sync_rev'] = Variable<int>(syncRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiariesCompanion(')
          ..write('id: $id, ')
          ..write('entryDate: $entryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('mood: $mood, ')
          ..write('weather: $weather, ')
          ..write('temperature: $temperature, ')
          ..write('locationName: $locationName, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('device: $device, ')
          ..write('wordCount: $wordCount, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncRev: $syncRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaAssetsTable extends MediaAssets
    with TableInfo<$MediaAssetsTable, MediaAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaryIdMeta = const VerificationMeta(
    'diaryId',
  );
  @override
  late final GeneratedColumn<String> diaryId = GeneratedColumn<String>(
    'diary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diaries (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbPathMeta = const VerificationMeta(
    'thumbPath',
  );
  @override
  late final GeneratedColumn<String> thumbPath = GeneratedColumn<String>(
    'thumb_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diaryId,
    type,
    localPath,
    thumbPath,
    durationMs,
    width,
    height,
    sizeBytes,
    caption,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('diary_id')) {
      context.handle(
        _diaryIdMeta,
        diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('thumb_path')) {
      context.handle(
        _thumbPathMeta,
        thumbPath.isAcceptableOrUnknown(data['thumb_path']!, _thumbPathMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      diaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diary_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      thumbPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumb_path'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $MediaAssetsTable createAlias(String alias) {
    return $MediaAssetsTable(attachedDatabase, alias);
  }
}

class MediaAsset extends DataClass implements Insertable<MediaAsset> {
  final String id;
  final String diaryId;

  /// image / audio / video / sketch
  final String type;
  final String localPath;
  final String? thumbPath;
  final int? durationMs;
  final int? width;
  final int? height;
  final int? sizeBytes;
  final String? caption;
  final int orderIndex;
  const MediaAsset({
    required this.id,
    required this.diaryId,
    required this.type,
    required this.localPath,
    this.thumbPath,
    this.durationMs,
    this.width,
    this.height,
    this.sizeBytes,
    this.caption,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['diary_id'] = Variable<String>(diaryId);
    map['type'] = Variable<String>(type);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || thumbPath != null) {
      map['thumb_path'] = Variable<String>(thumbPath);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  MediaAssetsCompanion toCompanion(bool nullToAbsent) {
    return MediaAssetsCompanion(
      id: Value(id),
      diaryId: Value(diaryId),
      type: Value(type),
      localPath: Value(localPath),
      thumbPath: thumbPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbPath),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      orderIndex: Value(orderIndex),
    );
  }

  factory MediaAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaAsset(
      id: serializer.fromJson<String>(json['id']),
      diaryId: serializer.fromJson<String>(json['diaryId']),
      type: serializer.fromJson<String>(json['type']),
      localPath: serializer.fromJson<String>(json['localPath']),
      thumbPath: serializer.fromJson<String?>(json['thumbPath']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      caption: serializer.fromJson<String?>(json['caption']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'diaryId': serializer.toJson<String>(diaryId),
      'type': serializer.toJson<String>(type),
      'localPath': serializer.toJson<String>(localPath),
      'thumbPath': serializer.toJson<String?>(thumbPath),
      'durationMs': serializer.toJson<int?>(durationMs),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'caption': serializer.toJson<String?>(caption),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  MediaAsset copyWith({
    String? id,
    String? diaryId,
    String? type,
    String? localPath,
    Value<String?> thumbPath = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> sizeBytes = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    int? orderIndex,
  }) => MediaAsset(
    id: id ?? this.id,
    diaryId: diaryId ?? this.diaryId,
    type: type ?? this.type,
    localPath: localPath ?? this.localPath,
    thumbPath: thumbPath.present ? thumbPath.value : this.thumbPath,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
    caption: caption.present ? caption.value : this.caption,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  MediaAsset copyWithCompanion(MediaAssetsCompanion data) {
    return MediaAsset(
      id: data.id.present ? data.id.value : this.id,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      type: data.type.present ? data.type.value : this.type,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      thumbPath: data.thumbPath.present ? data.thumbPath.value : this.thumbPath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      caption: data.caption.present ? data.caption.value : this.caption,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaAsset(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('type: $type, ')
          ..write('localPath: $localPath, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('caption: $caption, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    diaryId,
    type,
    localPath,
    thumbPath,
    durationMs,
    width,
    height,
    sizeBytes,
    caption,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaAsset &&
          other.id == this.id &&
          other.diaryId == this.diaryId &&
          other.type == this.type &&
          other.localPath == this.localPath &&
          other.thumbPath == this.thumbPath &&
          other.durationMs == this.durationMs &&
          other.width == this.width &&
          other.height == this.height &&
          other.sizeBytes == this.sizeBytes &&
          other.caption == this.caption &&
          other.orderIndex == this.orderIndex);
}

class MediaAssetsCompanion extends UpdateCompanion<MediaAsset> {
  final Value<String> id;
  final Value<String> diaryId;
  final Value<String> type;
  final Value<String> localPath;
  final Value<String?> thumbPath;
  final Value<int?> durationMs;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> sizeBytes;
  final Value<String?> caption;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const MediaAssetsCompanion({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.type = const Value.absent(),
    this.localPath = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.caption = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaAssetsCompanion.insert({
    required String id,
    required String diaryId,
    required String type,
    required String localPath,
    this.thumbPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.caption = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       diaryId = Value(diaryId),
       type = Value(type),
       localPath = Value(localPath);
  static Insertable<MediaAsset> custom({
    Expression<String>? id,
    Expression<String>? diaryId,
    Expression<String>? type,
    Expression<String>? localPath,
    Expression<String>? thumbPath,
    Expression<int>? durationMs,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? sizeBytes,
    Expression<String>? caption,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryId != null) 'diary_id': diaryId,
      if (type != null) 'type': type,
      if (localPath != null) 'local_path': localPath,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (caption != null) 'caption': caption,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaAssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? diaryId,
    Value<String>? type,
    Value<String>? localPath,
    Value<String?>? thumbPath,
    Value<int?>? durationMs,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? sizeBytes,
    Value<String?>? caption,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return MediaAssetsCompanion(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      thumbPath: thumbPath ?? this.thumbPath,
      durationMs: durationMs ?? this.durationMs,
      width: width ?? this.width,
      height: height ?? this.height,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      caption: caption ?? this.caption,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<String>(diaryId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String>(thumbPath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaAssetsCompanion(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('type: $type, ')
          ..write('localPath: $localPath, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('caption: $caption, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DiariesTable diaries = $DiariesTable(this);
  late final $MediaAssetsTable mediaAssets = $MediaAssetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [diaries, mediaAssets];
}

typedef $$DiariesTableCreateCompanionBuilder = DiariesCompanion Function({
  required String id,
  required DateTime entryDate,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> title,
  Value<String> body,
  Value<String?> mood,
  Value<String?> weather,
  Value<String?> temperature,
  Value<String?> locationName,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> device,
  Value<int> wordCount,
  Value<bool> isFavorite,
  Value<bool> isDeleted,
  Value<DateTime?> deletedAt,
  Value<int> syncRev,
  Value<int> rowid,
});
typedef $$DiariesTableUpdateCompanionBuilder = DiariesCompanion Function({
  Value<String> id,
  Value<DateTime> entryDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> title,
  Value<String> body,
  Value<String?> mood,
  Value<String?> weather,
  Value<String?> temperature,
  Value<String?> locationName,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> device,
  Value<int> wordCount,
  Value<bool> isFavorite,
  Value<bool> isDeleted,
  Value<DateTime?> deletedAt,
  Value<int> syncRev,
  Value<int> rowid,
});

final class $$DiariesTableReferences
    extends BaseReferences<_$AppDatabase, $DiariesTable, Diary> {
  $$DiariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaAssetsTable, List<MediaAsset>>
  _mediaAssetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaAssets,
    aliasName: 'diaries__id__media_assets__diary_id',
  );

  $$MediaAssetsTableProcessedTableManager get mediaAssetsRefs {
    final manager = $$MediaAssetsTableTableManager(
      $_db,
      $_db.mediaAssets,
    ).filter((f) => f.diaryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaAssetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiariesTableFilterComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableFilterComposer({
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

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncRev => $composableBuilder(
    column: $table.syncRev,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaAssetsRefs(
    Expression<bool> Function($$MediaAssetsTableFilterComposer f) f,
  ) {
    final $$MediaAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaAssets,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAssetsTableFilterComposer(
            $db: $db,
            $table: $db.mediaAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncRev => $composableBuilder(
    column: $table.syncRev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<String> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get device =>
      $composableBuilder(column: $table.device, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get syncRev =>
      $composableBuilder(column: $table.syncRev, builder: (column) => column);

  Expression<T> mediaAssetsRefs<T extends Object>(
    Expression<T> Function($$MediaAssetsTableAnnotationComposer a) f,
  ) {
    final $$MediaAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaAssets,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiariesTable,
          Diary,
          $$DiariesTableFilterComposer,
          $$DiariesTableOrderingComposer,
          $$DiariesTableAnnotationComposer,
          $$DiariesTableCreateCompanionBuilder,
          $$DiariesTableUpdateCompanionBuilder,
          (Diary, $$DiariesTableReferences),
          Diary,
          PrefetchHooks Function({bool mediaAssetsRefs})
        > {
  $$DiariesTableTableManager(_$AppDatabase db, $DiariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<String?> temperature = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> device = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> syncRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiariesCompanion(
                id: id,
                entryDate: entryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                title: title,
                body: body,
                mood: mood,
                weather: weather,
                temperature: temperature,
                locationName: locationName,
                lat: lat,
                lng: lng,
                device: device,
                wordCount: wordCount,
                isFavorite: isFavorite,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncRev: syncRev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime entryDate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<String?> temperature = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> device = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> syncRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiariesCompanion.insert(
                id: id,
                entryDate: entryDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                title: title,
                body: body,
                mood: mood,
                weather: weather,
                temperature: temperature,
                locationName: locationName,
                lat: lat,
                lng: lng,
                device: device,
                wordCount: wordCount,
                isFavorite: isFavorite,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncRev: syncRev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaAssetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaAssetsRefs) db.mediaAssets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaAssetsRefs)
                    await $_getPrefetchedData<Diary, $DiariesTable, MediaAsset>(
                      currentTable: table,
                      referencedTable: $$DiariesTableReferences
                          ._mediaAssetsRefsTable(db),
                      managerFromTypedResult: (p0) => $$DiariesTableReferences(
                        db,
                        table,
                        p0,
                      ).mediaAssetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.diaryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DiariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiariesTable,
      Diary,
      $$DiariesTableFilterComposer,
      $$DiariesTableOrderingComposer,
      $$DiariesTableAnnotationComposer,
      $$DiariesTableCreateCompanionBuilder,
      $$DiariesTableUpdateCompanionBuilder,
      (Diary, $$DiariesTableReferences),
      Diary,
      PrefetchHooks Function({bool mediaAssetsRefs})
    >;
typedef $$MediaAssetsTableCreateCompanionBuilder =
    MediaAssetsCompanion Function({
      required String id,
      required String diaryId,
      required String type,
      required String localPath,
      Value<String?> thumbPath,
      Value<int?> durationMs,
      Value<int?> width,
      Value<int?> height,
      Value<int?> sizeBytes,
      Value<String?> caption,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$MediaAssetsTableUpdateCompanionBuilder =
    MediaAssetsCompanion Function({
      Value<String> id,
      Value<String> diaryId,
      Value<String> type,
      Value<String> localPath,
      Value<String?> thumbPath,
      Value<int?> durationMs,
      Value<int?> width,
      Value<int?> height,
      Value<int?> sizeBytes,
      Value<String?> caption,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$MediaAssetsTableReferences
    extends BaseReferences<_$AppDatabase, $MediaAssetsTable, MediaAsset> {
  $$MediaAssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiariesTable _diaryIdTable(_$AppDatabase db) =>
      db.diaries.createAlias('media_assets__diary_id__diaries__id');

  $$DiariesTableProcessedTableManager get diaryId {
    final $_column = $_itemColumn<String>('diary_id')!;

    final manager = $$DiariesTableTableManager(
      $_db,
      $_db.diaries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$DiariesTableFilterComposer get diaryId {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableFilterComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiariesTableOrderingComposer get diaryId {
    final $$DiariesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableOrderingComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableAnnotationComposer({
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

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get thumbPath =>
      $composableBuilder(column: $table.thumbPath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$DiariesTableAnnotationComposer get diaryId {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaAssetsTable,
          MediaAsset,
          $$MediaAssetsTableFilterComposer,
          $$MediaAssetsTableOrderingComposer,
          $$MediaAssetsTableAnnotationComposer,
          $$MediaAssetsTableCreateCompanionBuilder,
          $$MediaAssetsTableUpdateCompanionBuilder,
          (MediaAsset, $$MediaAssetsTableReferences),
          MediaAsset,
          PrefetchHooks Function({bool diaryId})
        > {
  $$MediaAssetsTableTableManager(_$AppDatabase db, $MediaAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> diaryId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> thumbPath = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion(
                id: id,
                diaryId: diaryId,
                type: type,
                localPath: localPath,
                thumbPath: thumbPath,
                durationMs: durationMs,
                width: width,
                height: height,
                sizeBytes: sizeBytes,
                caption: caption,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String diaryId,
                required String type,
                required String localPath,
                Value<String?> thumbPath = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion.insert(
                id: id,
                diaryId: diaryId,
                type: type,
                localPath: localPath,
                thumbPath: thumbPath,
                durationMs: durationMs,
                width: width,
                height: height,
                sizeBytes: sizeBytes,
                caption: caption,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryId = false}) {
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
                    if (diaryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.diaryId,
                        referencedTable: $$MediaAssetsTableReferences
                            ._diaryIdTable(db),
                        referencedColumn: $$MediaAssetsTableReferences
                            ._diaryIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MediaAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaAssetsTable,
      MediaAsset,
      $$MediaAssetsTableFilterComposer,
      $$MediaAssetsTableOrderingComposer,
      $$MediaAssetsTableAnnotationComposer,
      $$MediaAssetsTableCreateCompanionBuilder,
      $$MediaAssetsTableUpdateCompanionBuilder,
      (MediaAsset, $$MediaAssetsTableReferences),
      MediaAsset,
      PrefetchHooks Function({bool diaryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db, _db.diaries);
  $$MediaAssetsTableTableManager get mediaAssets =>
      $$MediaAssetsTableTableManager(_db, _db.mediaAssets);
}
