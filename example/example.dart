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
