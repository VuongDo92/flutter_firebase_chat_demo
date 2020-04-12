library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

// Custom Serializer for double, which converts String to double
// based on https://github.com/google/built_value.dart/blob/master/built_value/lib/src/double_serializer.dart
class CustomDoubleSerializer implements PrimitiveSerializer<double> {
  // Constant names match those in [double].
  // ignore_for_file: non_constant_identifier_names
  static final String nan = 'NaN';
  static final String infinity = 'INF';
  static final String negativeInfinity = '-INF';

  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([double]);
  @override
  final String wireName = 'double';

  @override
  Object serialize(Serializers serializers, double aDouble,
      {FullType specifiedType = FullType.unspecified}) {
    if (aDouble.isNaN) {
      return nan;
    } else if (aDouble.isInfinite) {
      return aDouble.isNegative ? negativeInfinity : infinity;
    } else {
      return aDouble;
    }
  }

  @override
  double deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized == nan) {
      return double.nan;
    } else if (serialized == negativeInfinity) {
      return double.negativeInfinity;
    } else if (serialized == infinity) {
      return double.infinity;
    } else {
      if (serialized is String) {
        return double.parse(serialized);
      }
      return (serialized as num).toDouble();
    }
  }
}
