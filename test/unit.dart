import 'package:dict/dict.dart';
import 'package:test/test.dart';
import 'package:option/option.dart';

void main() {
  Dictionary dict;
  Dictionary other;

  setUp(() {
    dict = new Dictionary.fromMap({
      'A': 'a',
      'B': 'b',
      'C': 'c'
    });

    other = new Dictionary.fromMap({
      'C': 'c',
      'D': 'd',
      'E': 'e'
    });
  });

  test('Create Dictionary from a Map', () {
    Dictionary<String, int> newDict = new Dictionary.fromMap({'1': 1, '2': 2});
    expect(newDict is Dictionary, isTrue);
    expect(newDict, isNot(same(
        new Dictionary.fromMap({'1': 1, '2': 2})
    )));
  });

  test('Dictionary implements Map', () {
    expect(dict is Map, isTrue);
  });

  test('Operator [] shoudl return an Option instance', () {
    expect(dict['A'] is Option, isTrue);
  });

  test('insert a new pair', () {
    dict['Z'] = 'z';
    expect(dict.containsKey('Z'), isTrue);
  });

  test('get() should return None instance', () {
    expect(dict.get('Not') is None, isTrue);
  });

  test('get() shoudl return the value', () {
    expect(dict.get('B') is Some, isTrue);
    expect(dict.get('B').get(), equals('b'));
  });

  test('getOrElse() shoudl execute an function', () {
    expect(dict.getOrElse('foo', () => 'bar'), equals('bar'));
  });

  test('getOrDefault() returns the values for the key, if the key exists', () {
    expect(dict.getOrDefault('A', 'N/A'), equals('a'));
  });

  test('findkey() should return the key', () {
    expect(dict.findKey((v, k) => v == 'a').getOrDefault('N/A'), equals('A'));
  });

  test('findValue() should return the value', () {
    expect(dict.findValue((v, k) => k == 'A').getOrDefault('N/A'), equals('a'));
  });

  test('partition() should split the Dictionary in a tuple', () {
    expect(dict.partition((v, k) => v == 'b'),
        equals([
          new Dictionary.fromMap({'B': 'b'}),
          new Dictionary.fromMap({'A': 'a', 'C': 'c'})
        ]));
  });

  test('map() iterate all the Dictionary Elements', () {
    Dictionary testDict = new Dictionary.fromMap({1: '1', 2: '2'});
    expect(testDict.map((v, k) => '-' + v),
        equals(new Dictionary.fromMap({1: '-1', 2: '-2'})));
  });

  test(
      'differenceKey() should return the diferrence between the tow Dictionaries by key', () {
    expect(dict.difference(other),
        equals(new Dictionary.fromMap({'A': 'a', 'B': 'b'})));
  });

  test(
      'difference() should return the diferrence between the tow Dictionaries by value', () {
    expect(dict.difference(other), equals(new Dictionary.fromMap({
      'A': 'a',
      'B': 'b'
    })));
  });

  test(
      'intersectionKey() should return the same keys in the two Dictionaries', () {
    expect(dict.intersectionKey(other),
        equals(new Dictionary.fromMap({'C': 'c'})));
  });

  test(
      'intersection() should return the same values in the two Dictionaries', () {
    expect(dict.intersection(other), new Dictionary.fromMap({'C': 'c'}));
  });

  test('merge() should merge the two Dictionaries', () {
    expect(dict.merge(other), equals(new Dictionary.fromMap({
      'A': 'a',
      'B': 'b',
      'C': 'c',
      'D': 'd',
      'E': 'e'
    })));
  });

  test('reduce() should reduce the Dictionary to a single element', () {
    expect(dict.reduce((memo, v, k) => memo + v), equals('abc'));
  });

  test('reduce() should not be called in a empty Dictionary', () {
    expect(() => new Dictionary().reduce((memo, v, k) => memo + v),
        throwsException);
  });
}
