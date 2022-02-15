import 'dart:convert';

/// This class contains some helpers to work with JSON.
class JSONHelper {
  /// Parses the string and returns the resulting Json object.
  static dynamic decode(
    String rawJson, {
    List<String>? convertObjectToArrayKeys,
  }) =>
      jsonDecode(
        rawJson,
        reviver: (Object? key, Object? value) => _reviver(
          key,
          value,
          convertObjectToArrayKeys,
        ),
      );

  /// Converts [object] to a JSON string.
  static String encode(Object? object) => jsonEncode(object);

  /// Traverse the json keys and values and transform them if needed.
  static Object? _reviver(
    Object? key,
    Object? value,
    List<String>? convertObjectToArrayKeys,
  ) {
    if (convertObjectToArrayKeys != null && value is Map) {
      for (final String transformKey in convertObjectToArrayKeys) {
        if (value.containsKey(transformKey) && value[transformKey] is Map) {
          value[transformKey] = _convertObjectToArray(value[transformKey]);
        }
      }
    }

    return value;
  }

  /// Converts the given object values from key value pairs to an array.
  static List<dynamic> _convertObjectToArray(Map<dynamic, dynamic> object) {
    final List<dynamic> array = <dynamic>[];

    for (final String key in object.keys) {
      final Map<dynamic, dynamic> value = object[key];
      value['_key'] = key;
      array.add(value);
    }

    return array;
  }
}
