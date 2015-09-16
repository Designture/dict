part of dict;

/**
 *
 */
class Dictionary<K, V> implements Map<K, V> {

  /**
   * Map containing all the data.
   */
  Map<K, V> _delegate = new LinkedHashMap();

  /**
   * Vanilla constructor.
   */
  Dictionary();

  /**
   * Factory construct for initializing Dictionaries from Maps.
   */
  factory Dictionary.fromMap(Map<K, V> other) {
    return new Dictionary<K, V>()
      ..addAll(other);
  }

  /**
   * Returns an optional value based on the key.
   *
   * @return Option<V> - A `Some` if the key exists, `None` otherwise.
   */
  Option<V> operator [](K key) {
    return this.get(key);
  }

  /**
   * Associates the [key] with the given [value].
   *
   * If the key was already in the Dictionary, its associated value is changed.
   * Otherwise the key-value pair is added to the Dictionary.
   */
  void operator []=(K key, V value) {
    this._delegate[key] = value;
  }

  /**
   * Returns an optional value based on the key.
   *
   * @return Option<V> - A `Some` if the key exists, `None` otherwise.
   */
  Option<V> get(K key) {
    if (this.containsKey(key)) {
      return new Some(_delegate[key]);
    } else {
      return new None<V>();
    }
  }

  /**
   * Given a `key` if that key exists then it's value be returned,
   * otherwise the `alternative` function will be executed and return an value.
   *
   * @param K key                   The key to lookup.
   * @param dynamic alternative()   The alternative function.
   * @return V                      Either the value or the alternative function result.
   */
  V getOrElse(K key, dynamic alternative()) {
    return this.get(key).getOrElse(alternative);
  }

  /**
   * Given a `key` if that key exists then it's value be returned,
   * otherwise the `alternative` value will be returned.
   *
   * @param K key                 The key to lookup.
   * @param dynamic alternative   The alternative value.
   * @return V                    Either the value or the alternative.
   */
  V getOrDefault(K key, dynamic alternative) {
    return this.get(key).getOrDefault(alternative);
  }

  /**
   * Given a predicate returns the first key that passes it as a `Some`.
   * If no key is found a `None` is returned.
   *
   * @param bool(V, K) predicate      The predicate to test against.
   * @return Option<K>                The optional key.
   */
  Option<K> findKey(bool predicate(V value, K key)) {
    for (K key in this.keys) {
      if (predicate(this._delegate[key], key)) {
        return new Some(key);
      }
    }

    return new None<K>();
  }

  /**
   * Given a predicate returns the fist value that passes it as a `Some`.
   * If no value is found a `None` is returned.
   *
   * @param bool(V, K) predicate      The predicate to test against.
   * @return Option<K>                The optional value.
   */
  Option<V> findValue(bool predicate(V value, K key)) {
    for (K key in this.keys) {
      if (predicate(this._delegate[key], key)) {
        return new Some(this._delegate[key]);
      }
    }

    return new None<V>();
  }

  /**
   * Given a mapper, apply it to all values in the dictionary and return the
   * new dictionary.
   *
   * @param dynamic(V, K) mapper        The mapper to apply to the values.
   * @return Dictionary<K, dynamic>     The result of the mapping.
   */
  Dictionary<K, dynamic> map(dynamic mapper(V v, K k)) {
    return this.keys.fold(new Dictionary(), (memo, k) {
      memo[k] = mapper(this._delegate[k], k);
      return memo;
    });
  }

  /**
   * Given a folder, apply it to all keys and values in the dictionary.
   *
   * @param dynamic initial           The initial value of the fold
   * @param dynamic(V, K) reducer     The folder to apply
   * @return dynamic                  The result of the fold
   */
  dynamic fold(dynamic initial, dynamic fold(dynamic i, V v, K k)) {
    return this.keys.fold(initial, (memo, k) {
      return fold(memo, this._delegate[k], k);
    });
  }

  /**
   * Given a reduce, reduce the values down to a single value.
   *
   * @param V (V, V, K) reducer     The reducer to apply.
   * @return V                      The value of the reduction.
   */
  V reduce(V reduce(V i, V v, K k)) {
    var keys = this.keys;

    if (keys.isEmpty) {
      throw new Exception("Can't call reduce on an empty dictionary");
    }

    if (keys.length == 1) {
      return this._delegate[keys.elementAt(0)];
    }

    var initial = this._delegate[keys.elementAt(0)];
    var rest = keys.skip(1);
    return rest.fold(initial, (memo, k) {
      return reduce(memo, this._delegate[k], k);
    });
  }

  /**
   * Given a predicate this method partitions the dictionary by the elements
   * that pass the predicate from the ones that don't.
   *
   * @param bool(V, K) predicate        The predicate to test against.
   * @return List<Dictionary<K, V>>     The tuple list of the partitioning.
   */
  List<Dictionary<K, V>> partition(bool predicate(V value, K key)) {
    var tuple = new List(2);
    tuple[0] = new Dictionary<K, V>();
    tuple[1] = new Dictionary<K, V>();

    for (K key in this.keys) {
      if (predicate(this._delegate[key], key)) {
        tuple[0][key] = this._delegate[key];
      } else {
        tuple[1][key] = this._delegate[key];
      }
    }

    return tuple;
  }

  /**
   * Given an identifier function this will group all key/value pairs
   * by the identifier they generate.
   *
   * @param dynamic(V, K) identifier                  Generates identifiers for each kv pair.
   * @return Dictionary<dynamic, Dictionary<K, V>>    The grouping.
   */
  Dictionary<dynamic, Dictionary<K, V>> groupBy(dynamic identifier(V v, K k)) {
    var init = new Dictionary<dynamic, Dictionary<K, V>>();
    return this.keys.fold(init, (memo, key) {
      var value = this._delegate[key];
      var id = identifier(value, key);
      var bucket = memo.getOrElse(key, () => new Dictionary<K, V>());
      bucket[key] = value;
      memo[id] = bucket;
      return memo;
    });
  }

  /**
   * Creates a new `Dictionary` that doesn't contain any of the keys in `other`
   *
   * @param Dictionary<K, V> other - The other dictionary
   * @return Dictionary<K, V>      - The difference by key
   */
  Dictionary<K, V> differenceKey(Dictionary<K, V> other) {
    var difference = new Dictionary<K, V>();
    for (K key in this.keys) {
      if (!other.containsKey(key)) {
        difference[key] = this._delegate[key];
      }
    }
    return difference;
  }

  /**
   * Creates a new `Dictionary` that doesn't contain values in `other`.
   *
   * @param Dictionary<K, V> other    The other dictionary.
   * @return Dictionary<K, V>         The difference by value.
   */
  Dictionary<K, V> difference(Dictionary<K, V> other) {
    var difference = new Dictionary<K, V>();
    for (K key in this.keys) {
      var value = this._delegate[key];
      if (!other.containsValue(value)) {
        difference[key] = value;
      }
    }
    return difference;
  }

  /**
   * Creates a new `Dictionary` where keys are present in both arrays.
   *
   * @param Dictionary<K, V> other    The other dictionary.
   * @return Dictionary<K, V>         The intersection by key.
   */
  Dictionary<K, V> intersectionKey(Dictionary<K, V> other) {
    var intersection = new Dictionary<K, V>();
    for (K key in this.keys) {
      if (other.containsKey(key)) {
        intersection[key] = this._delegate[key];
      }
    }
    return intersection;
  }

  /**
   * Creates a new `Dictionary` where values are present in both.
   *
   * @param Dictionary<K, V> other    The other dictionary.
   * @return Dictionary<K, V>         The intersection by value.
   */
  Dictionary<K, V> intersection(Dictionary<K, V> other) {
    var intersection = new Dictionary<K, V>();
    for (K key in this.keys) {
      if (other.containsValue(this._delegate[key])) {
        intersection[key] = this._delegate[key];
      }
    }
    return intersection;
  }

  /**
   * Creates a new `Dictionary` where the `other` array is merged into
   * this array. Overlapping keys in `other` overwrite the keys in the
   * merged result.
   *
   * @param Dictionary<K, V> other    The other dictionary.
   * @return Dictionary<K, V>         The merged result.
   */
  Dictionary<K, V> merge(Dictionary<K, V> other) {
    var merged = new Dictionary()
      ..addAll(this._delegate);
    for (K key in other.keys) {
      merged[key] = other[key].get();
    }

    return merged;
  }

  bool get isEmpty => _delegate.isEmpty;

  bool get isNotEmpty => _delegate.isNotEmpty;

  Iterable<K> get keys => _delegate.keys;

  int get length => _delegate.length;

  Iterable<V> get values => _delegate.values;

  void addAll(Map<K, V> other) => _delegate.addAll(other);

  void clear() => _delegate.clear();

  bool containsKey(K key) => _delegate.containsKey(key);

  bool containsValue(V value) => _delegate.containsValue(value);

  void forEach(void action(K key, V value)) => _delegate.forEach(action);

  V putIfAbsent(K key, V ifAbsent()) => _delegate.putIfAbsent(key, ifAbsent);

  V remove(K key) => _delegate.remove(key);

  String toString() => _delegate.toString();

}
