import gleeunit
import gleeunit/should
import parser/lex
import parser/types/json

pub fn main() {
  gleeunit.main()
}

pub fn lex_empty_object_test() {
  let json = "{}"
  let expected = [json.CurlyOpen, json.CurlyClose]

  assert_token_result(json, expected)
}

pub fn lex_string_value_test() {
  let json = "{\"name\": \"john\"}"
  let expected = [
    json.CurlyOpen,
    json.String("name"),
    json.Colon,
    json.String("john"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_multi_line_string_value_test() {
  let json =
    "
    {
      \"name\": \"john\"
    }
    "
  let expected = [
    json.CurlyOpen,
    json.String("name"),
    json.Colon,
    json.String("john"),
    json.CurlyClose,
  ]

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
    json.CurlyOpen,
    json.String("names"),
    json.Colon,
    json.ArrayOpen,
    json.String("John"),
    json.Comma,
    json.String("Jane"),
    json.Comma,
    json.String("Joan"),
    json.ArrayClose,
    json.CurlyClose,
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

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("18"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_negative_whole_number_value_test() {
  let json =
    "
  {
    \"temperature\": -18
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("-18"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_0_value_test() {
  let json =
    "
  {
    \"temperature\": 0
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("0"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_0_start_invalid_value_test() {
  let json =
    "
  {
    \"temperature\": 020
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("0"),
    json.Number("20"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_fraction_number_value_test() {
  let json =
    "
  {
    \"temperature\": 3.1415926535
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("3.1415926535"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_negative_fraction_number_value_test() {
  let json =
    "
  {
    \"temperature\": -3.1415926535
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("-3.1415926535"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_0_start_fraction_value_test() {
  let json =
    "
  {
    \"temperature\": 0.20
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("0.20"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_exponent_number_value_test() {
  let json =
    "
  {
    \"temperature\": 35e10
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("35e10"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_capital_exponent_number_value_test() {
  let json =
    "
  {
    \"temperature\": 35E10
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("35E10"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_leading_plus_exponent_number_value_test() {
  let json =
    "
  {
    \"temperature\": 35e+10
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("35e+10"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_leading_minus_exponent_number_value_test() {
  let json =
    "
  {
    \"temperature\": 35e-10
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("35e-10"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_fraction_exponent_number_value_test() {
  let json =
    "
  {
    \"temperature\": 0.83e-8320
  }
  "

  let expected = [
    json.CurlyOpen,
    json.String("temperature"),
    json.Colon,
    json.Number("0.83e-8320"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_boolean_true_value_test() {
  let json =
    "
    {
      \"happy\": true
    }
    "

  let expected = [
    json.CurlyOpen,
    json.String("happy"),
    json.Colon,
    json.Boolean("true"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

pub fn lex_boolean_value_false_test() {
  let json =
    "
    {
      \"happy\": false
    }
    "

  let expected = [
    json.CurlyOpen,
    json.String("happy"),
    json.Colon,
    json.Boolean("false"),
    json.CurlyClose,
  ]

  assert_token_result(json, expected)
}

fn assert_token_result(json, token_result) {
  token_result |> should.equal(lex.lex(json))
}
