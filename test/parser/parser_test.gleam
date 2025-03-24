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
