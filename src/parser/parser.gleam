import gleam/string
import parser/lex
import parser/types/json

pub fn from_string(string) {
  let #(result, _) =
    string
    |> lex.lex()
    |> parse

  result
}

fn parse(tokens) {
  case tokens {
    [t, ..] if t == json.ArrayOpen || t == json.CurlyOpen -> parse_r(tokens)
    _ -> panic
  }
}

fn parse_r(tokens) {
  case tokens {
    [json.ArrayOpen, ..rest] -> parse_array(rest)
    [json.CurlyOpen, ..rest] -> parse_object(rest)
    [_, ..] -> parse_value(tokens)
    _ -> panic
  }
}

fn parse_array(tokens) {
  let json_array = "["

  case tokens {
    [json.ArrayClose, ..rest] -> #(json_array <> "]", rest)
    _ -> parse_array_r(json_array, tokens)
  }
}

fn parse_array_r(json_array, tokens) {
  let #(json, tokens) = parse_r(tokens)
  let json_array = json_array <> json

  case tokens {
    [json.ArrayClose, ..rest] -> #(json_array <> "]", rest)
    [json.Comma, ..rest] -> parse_array_r(json_array <> ", ", rest)
    _ -> panic
  }
}

fn parse_object(tokens) {
  let json_object = "%{"

  case tokens {
    [json.CurlyClose, ..rest] -> #(json_object <> "}", rest)
    _ -> parse_object_r(json_object, tokens)
  }
}

fn parse_object_r(json_object, tokens) {
  use key, value, tokens <- parse_key_value(tokens)
  let json_object = json_object <> key <> ": " <> value

  case tokens {
    [json.CurlyClose, ..rest] -> #(json_object <> "}", rest)
    [json.Comma, ..rest] -> parse_object_r(json_object <> ", ", rest)
    _ -> panic
  }
}

fn parse_key_value(tokens, continue) {
  case tokens {
    [json.String(key), json.Colon, ..rest] -> {
      let #(value, tokens) = parse_r(rest)
      continue(key, value, tokens)
    }
    _ -> panic
  }
}

fn parse_value(tokens) {
  case tokens {
    [json.String(string), ..rest] -> #(parse_string(string), rest)
    [json.Number(number), ..rest] -> #(parse_number(number), rest)
    [json.Boolean(boolean), ..rest] -> #(boolean, rest)
    [json.Null, ..rest] -> #("nil", rest)
    _ -> panic
  }
}

fn parse_string(string) {
  "\"" <> string <> "\""
}

fn parse_number(number) {
  number
  |> string.replace("+", "")
}
