import gleeunit
import gleeunit/should
import parser/lex
import parser/types/json

pub fn main() {
  gleeunit.main()
}

pub fn lex_json_test() {
  let json =
    "
    {
      \"foo\": [1, null, true, false, {\"bar\": 1.9e-78}]
    }
    "
  let expected = [
    json.CurlyOpen,
    json.String("foo"),
    json.Colon,
    json.ArrayOpen,
    json.Number("1"),
    json.Comma,
    json.Null,
    json.Comma,
    json.Boolean("true"),
    json.Comma,
    json.Boolean("false"),
    json.Comma,
    json.CurlyOpen,
    json.String("bar"),
    json.Colon,
    json.Number("1.9e-78"),
    json.CurlyClose,
    json.ArrayClose,
    json.CurlyClose,
  ]

  expected |> should.equal(lex.lex(json))
}

pub fn lex_json_list_test() {
  let json =
    "
    [
      { \"foo\": 1 },
      { \"bar\": 2 }
    ]
    "
  let expected = [
    json.ArrayOpen,
    json.CurlyOpen,
    json.String("foo"),
    json.Colon,
    json.Number("1"),
    json.CurlyClose,
    json.Comma,
    json.CurlyOpen,
    json.String("bar"),
    json.Colon,
    json.Number("2"),
    json.CurlyClose,
    json.ArrayClose,
  ]

  expected |> should.equal(lex.lex(json))
}

pub fn lex_empty_object_test() {
  let json = "{}"
  let expected = [json.CurlyOpen, json.CurlyClose]

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
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

  expected |> should.equal(lex.lex(json))
}

pub fn lex_null_value_test() {
  let json =
    "
    {
      \"happy\": null
    }
    "

  let expected = [
    json.CurlyOpen,
    json.String("happy"),
    json.Colon,
    json.Null,
    json.CurlyClose,
  ]

  expected |> should.equal(lex.lex(json))
}
