# Dict

A more advanced alternative to Dart's native `Map` implementation. All
operations that fetch an element from the `Dictionary` returns an `Option`
type. If the fetched value existed then the `Option` type returned will
be `Some` and will have the value wrapped inside. If the key was not found
in the `Dictionary` then the `Option` type returned will be `None`.

We returning `Option` types instead of raw values is you can focus more on
the composition and flow of your logic instead of worrying about defensive
`Map#containsKey` safety checks.

Tested with Dart 1.12.1

## Example

```dart
import 'package:dict/dict.dart';

main() {
  var dict = new Dictionary.fromMap({
    'A': 'a',
    'B': 'b',
    'C': 'c'
  });

  var other = new Dictionary.fromMap({
    'C': 'c',
    'D': 'd',
    'E': 'e'
  });

  var lowerA = dict.getOrDefault('A', 'N/A');
  var lowerB = dict['B'].getOrDefault('N/A');
  var lowerC = dict.get('C').getOrDefault('N/A');
  var findA = dict.findKey((v, k) => k == 'A').getOrDefault('N/A');
  var findB = dict.findValue((v, k) => v == 'b').getOrDefault('N/A');
  var findBs = dict.partition((v, k) => v == 'b');
  var mapped = dict.map((v, k) => v + " - mapped");
  var byValue = dict.groupBy((v, k) => v);
  var diffKey = dict.differenceKey(other);
  var diffVal = dict.difference(other);
  var interKey = dict.intersectionKey(other);
  var interVal = dict.intersection(other);
  var merged = dict.merge(other);
  var reduced = dict.reduce((memo, v, k) => memo + v);
  var folded = dict.fold(new Dictionary(), (memo, v, k) {
    memo[k] = v + " - folded";
    return memo;
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Designture/dict/issues
