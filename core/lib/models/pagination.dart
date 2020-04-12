import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import './serializers.dart';

part 'pagination.g.dart';

abstract class Pagination implements Built<Pagination, PaginationBuilder> {
  static Serializer<Pagination> get serializer => _$paginationSerializer;
  @nullable
  int get total;

  @nullable
  int get offset;

  @nullable
  int get limit;

  Pagination._();

  factory Pagination([updates(PaginationBuilder b)]) = _$Pagination;

  static Pagination fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
