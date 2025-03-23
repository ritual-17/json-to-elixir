import gleeunit
import gleeunit/should
import parser/lex

pub fn main() {
  gleeunit.main()
}

pub fn lex_empty_object_test() {
  let json = "{}"
  let expected = ["{", "}"]

  expected |> should.equal(lex.lex(json))
}

pub fn lex_string_value_test() {
  let json = "{\"name\": \"john\"}"
  let expected = ["{", "name", ":", "john", "}"]

  assert_token_result(json, expected)
}

pub fn lex_multi_line_string_value_test() {
  let json =
    "
    {
      \"name\": \"john\"
    }
    "
  let expected = ["{", "name", ":", "john", "}"]

  assert_token_result(json, expected)
}

pub fn lex_string_list_value_test() {
  let json =
    "
    {
      \"names\": [\"John\", \"Jane\", \"Joan\"]
    }
    "
  let expected = [
    "{", "names", ":", "[", "John", ",", "Jane", ",", "Joan", "]", "}",
  ]

  assert_token_result(json, expected)
}

pub fn lex_whole_number_value_test() {
  let json =
    "
  {
    \"temperature\": 18
  }
  "

  let expected = ["{", "temperature", ":", "18", "}"]

  assert_token_result(json, expected)
}

pub fn lex_negative_whole_number_value_test() {
  let json =
    "
  {
    \"temperature\": -18
  }
  "

  let expected = ["{", "temperature", ":", "-18", "}"]

  assert_token_result(json, expected)
}

pub fn lex_0_value_test() {
  let json =
    "
  {
    \"temperature\": 0
  }
  "

  let expected = ["{", "temperature", ":", "0", "}"]

  assert_token_result(json, expected)
}

pub fn lex_0_start_invalid_value_test() {
  let json =
    "
  {
    \"temperature\": 020
  }
  "

  let expected = ["{", "temperature", ":", "0", "20", "}"]

  assert_token_result(json, expected)
}

pub fn lex_fraction_number_value_test() {
  let json =
    "
  {
    \"temperature\": 3.1415926535
  }
  "

  let expected = ["{", "temperature", ":", "3.1415926535", "}"]

  assert_token_result(json, expected)
}

pub fn lex_negative_fraction_number_value_test() {
  let json =
    "
  {
    \"temperature\": -3.1415926535
  }
  "

  let expected = ["{", "temperature", ":", "-3.1415926535", "}"]

  assert_token_result(json, expected)
}

pub fn lex_0_start_fraction_value_test() {
  let json =
    "
  {
    \"temperature\": 0.20
  }
  "

  let expected = ["{", "temperature", ":", "0.20", "}"]

  assert_token_result(json, expected)
}

fn assert_token_result(json: String, token_result: List(String)) {
  token_result |> should.equal(lex.lex(json))
}
