import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp.{from_string}
import gleam/string

pub fn lex(string: String) {
  string
  |> string.to_graphemes
  |> lex_r([])
}

fn lex_r(chars: List(String), tokens: List(String)) -> List(String) {
  case chars {
    [] -> tokens
    chars -> {
      let #(string, chars) = lex_string(chars)
      case string {
        None -> {
          let #(number, chars) = lex_number(chars)
          tokens
        }
        Some(string) -> lex_r(chars, list.append(tokens, [string]))
      }
    }
  }
}

fn lex_string(chars: List(String)) -> #(Option(String), List(String)) {
  case chars {
    ["\"", ..rest] -> lex_string_r(rest, "")
    _ -> #(None, chars)
  }
}

fn lex_string_r(
  chars: List(String),
  string: String,
) -> #(Option(String), List(String)) {
  case chars {
    ["\"", ..rest] -> #(Some(string), rest)
    [char, ..rest] -> lex_string_r(rest, string <> char)
    _ -> panic
  }
}

fn lex_number(chars: List(String)) -> #(Option(String), List(String)) {
  case chars {
    [char, ..rest] -> {
      case check_start_of_number(char) {
        True -> lex_number_r(rest, char)
        False -> #(None, chars)
      }
    }
    _ -> #(None, chars)
  }
}

fn lex_number_r(
  chars: List(String),
  number: String,
) -> #(Option(String), List(String)) {
  todo
}

fn check_start_of_number(char: String) -> Bool {
  check(char, "[-0-9]")
}

fn check_digit(char: String) -> Bool {
  check(char, "[0-9]")
}

fn check(char: String, regex: String) {
  let assert Ok(re) = from_string(regex)
  regexp.check(re, char)
}
