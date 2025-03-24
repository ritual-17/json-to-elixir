import gleeunit
import gleeunit/should
import parser/parser

pub fn main() {
  gleeunit.main()
}

pub fn from_string_empty_list_test() {
  let string = "[]"

  "[]" |> should.equal(parser.from_string(string))
}

pub fn from_string_nested_list_test() {
  let string = "[[]]"

  "[[]]" |> should.equal(parser.from_string(string))
}

pub fn from_string_list_of_lists_test() {
  let string = "[[[], []], [], []]"

  "[[[], []], [], []]" |> should.equal(parser.from_string(string))
}

pub fn from_string_empty_object_test() {
  let string = "{}"

  "%{}" |> should.equal(parser.from_string(string))
}

pub fn from_string_single_pair_object_test() {
  let string = "{\"foo\": \"bar\"}"

  "%{foo: \"bar\"}" |> should.equal(parser.from_string(string))
}

pub fn from_string_single_pair_whole_number_value_object_test() {
  let string = "{\"foo\": 123}"

  "%{foo: 123}" |> should.equal(parser.from_string(string))
}

pub fn from_string_single_pair_fraction_number_value_object_test() {
  let string = "{\"foo\": 3.141592}"

  "%{foo: 3.141592}" |> should.equal(parser.from_string(string))
}

pub fn from_string_single_pair_exponent_number_value_object_test() {
  let string = "{\"foo\": -1.47e+17}"

  "%{foo: -1.47e17}" |> should.equal(parser.from_string(string))
}

pub fn from_string_single_pair_boolean_value_object_test() {
  let string = "{\"foo\": true}"

  "%{foo: true}" |> should.equal(parser.from_string(string))

  let string = "{\"foo\": false}"

  "%{foo: false}" |> should.equal(parser.from_string(string))
}

pub fn from_string_single_pair_null_value_object_test() {
  let string = "{\"foo\": null}"

  "%{foo: nil}" |> should.equal(parser.from_string(string))

  let string = "{\"foo\": \"null\"}"

  "%{foo: \"null\"}" |> should.equal(parser.from_string(string))
}

pub fn from_string_multi_value_object_test() {
  let string = "{\"foo\": 10, \"bar\": true, \"baz\": null}"

  "%{foo: 10, bar: true, baz: nil}" |> should.equal(parser.from_string(string))
}

pub fn from_string_nested_object_test() {
  let string = "{\"foo\": {\"bar\": true, \"baz\": null}}"

  "%{foo: %{bar: true, baz: nil}}" |> should.equal(parser.from_string(string))
}

pub fn from_string_nested_object_with_list_test() {
  let string = "{\"foo\": {\"bar\": [{}, true, 1.23, []], \"baz\": null}}"

  "%{foo: %{bar: [%{}, true, 1.23, []], baz: nil}}"
  |> should.equal(parser.from_string(string))
}

pub fn from_string_empty_object_string_test() {
  let string = "{\"foo\": \"{}\"}"

  "%{foo: \"{}\"}" |> should.equal(parser.from_string(string))
}

pub fn from_string_empty_array_string_test() {
  let string = "{\"foo\": \"[]\"}"

  "%{foo: \"[]\"}" |> should.equal(parser.from_string(string))
}
