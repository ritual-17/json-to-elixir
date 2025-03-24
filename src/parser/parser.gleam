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
  todo
}

fn parse_value(tokens) {
  case tokens {
    [json.String(string), ..rest] -> #(string, rest)
    [json.Number(number), ..rest] -> #(number, rest)
    [json.Boolean(boolean), ..rest] -> #(boolean, rest)
    [json.Null, ..rest] -> #("nil", rest)
    _ -> panic
  }
}
