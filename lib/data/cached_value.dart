class CachedValue<T> {
  T? _value;

  void cacheValue(T value) {
    _value = value;
  }

  T getValue() {
    if (_value != null) {
      return _value!;
    } else {
      throw "Called getValue before cacheValue";
    }
  }

  bool isReady() => _value != null;
}
