library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:core/models/pagination.dart';
import 'package:core/models/serializers/custom_double_serializer.dart';

import 'models.dart';

part 'serializers.g.dart';

@SerializersFor(const [Pagination])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(new StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..add(CustomDoubleSerializer()))
    .build();
