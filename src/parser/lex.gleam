import gleam/list
import gleam/option.{None, Some}
import gleam/regexp.{from_string}
import gleam/string
import parser/types/json

pub fn lex(string) {
  string
  |> string.to_graphemes
  |> lex_r([])
}

fn lex_r(chars, tokens) {
  use <- check_for_chars_remaining(chars, tokens)
  use <- check_for_string(chars, tokens)
  use <- check_for_number(chars, tokens)
  use <- check_for_boolean(chars, tokens)
  use <- check_for_null(chars, tokens)
  check_for_whitespace_or_json_syntax_char(chars, tokens)
}

fn check_for_chars_remaining(chars, tokens, continue) {
  case chars {
    [] -> tokens
    _ -> continue()
  }
}

fn check_for_string(chars, tokens, continue) {
  let #(string, chars) = lex_string(chars)

  case string {
    None -> continue()
    Some(string) -> lex_r(chars, list.append(tokens, [string]))
  }
}

fn lex_string(chars) {
  case chars {
    ["\"", ..rest] -> lex_string_r(rest, "")
    _ -> #(None, chars)
  }
}

fn lex_string_r(chars, string) {
  case chars {
    ["\"", ..rest] -> #(Some(json.String(string)), rest)
    [char, ..rest] -> lex_string_r(rest, string <> char)
    _ -> panic
  }
}

fn check_for_number(chars, tokens, continue) {
  let #(number, chars) = lex_number(chars)

  case number {
    None -> continue()
    Some(number) -> lex_r(chars, list.append(tokens, [json.Number(number)]))
  }
}

fn lex_number(chars) {
  let original_chars = chars
  let #(chars, number_string) = strip_negative(chars)

  use chars, number_string <- check_if_start_of_number(
    chars,
    original_chars,
    number_string,
  )
  let #(chars, number_string) = get_whole_number(chars, number_string)
  let #(chars, number_string) = get_fraction_number(chars, number_string)
  let #(chars, number_string) = get_exponent_number(chars, number_string)
  #(Some(number_string), chars)
}

fn strip_negative(chars) {
  case chars {
    ["-" as base_number, ..rest] -> #(rest, base_number)
    _ -> #(chars, "")
  }
}

fn check_if_start_of_number(chars, original_chars, number_string, continue) {
  case chars {
    [char, ..rest] -> {
      case check_digit(char) {
        True -> continue(rest, number_string <> char)
        False -> #(None, original_chars)
      }
    }
    _ -> #(None, original_chars)
  }
}

fn get_whole_number(chars, number) {
  case number {
    "0" -> #(chars, number)
    _ -> get_whole_number_r(chars, number)
  }
}

fn get_whole_number_r(chars, number) {
  case chars {
    [char, ..rest] -> {
      case check_digit(char) {
        True -> get_whole_number_r(rest, number <> char)
        False -> #(chars, number)
      }
    }
    _ -> #(chars, number)
  }
}

fn get_fraction_number(chars, number) {
  case chars {
    [".", ..rest] -> get_whole_number_r(rest, number <> ".")
    _ -> #(chars, number)
  }
}

fn get_exponent_number(chars, number) {
  case chars {
    [e, ..rest] if e == "e" || e == "E" -> {
      let number = number <> e
      let #(chars, number) = strip_magnitude_sign(rest, number)

      get_whole_number_r(chars, number)
    }
    _ -> #(chars, number)
  }
}

fn strip_magnitude_sign(chars, number) {
  case chars {
    ["-" as sign, ..rest] -> #(rest, number <> sign)
    ["+" as sign, ..rest] -> #(rest, number <> sign)
    _ -> #(chars, number)
  }
}

fn check_digit(char) {
  check(char, "[0-9]")
}

fn check(char, regex) {
  let assert Ok(re) = from_string(regex)
  regexp.check(re, char)
}

fn check_for_boolean(chars, tokens, continue) {
  let #(boolean, chars) = lex_boolean(chars)

  case boolean {
    None -> continue()
    Some(boolean) -> lex_r(chars, list.append(tokens, [boolean]))
  }
}

fn lex_boolean(chars) {
  case chars {
    ["t", "r", "u", "e", ..rest] -> #(Some(json.Boolean("true")), rest)
    ["f", "a", "l", "s", "e", ..rest] -> #(Some(json.Boolean("false")), rest)
    _ -> #(None, chars)
  }
}

fn check_for_null(chars, tokens, continue) {
  let #(null, chars) = lex_null(chars)

  case null {
    None -> continue()
    Some(null) -> lex_r(chars, list.append(tokens, [null]))
  }
}

fn lex_null(chars) {
  case chars {
    ["n", "u", "l", "l", ..rest] -> #(Some(json.Null), rest)
    _ -> #(None, chars)
  }
}

fn check_for_whitespace_or_json_syntax_char(chars, tokens) {
  case chars {
    [" ", ..rest] -> lex_r(rest, tokens)
    ["\t", ..rest] -> lex_r(rest, tokens)
    ["\n", ..rest] -> lex_r(rest, tokens)
    ["\r", ..rest] -> lex_r(rest, tokens)
    ["{", ..rest] -> lex_r(rest, list.append(tokens, [json.CurlyOpen]))
    ["}", ..rest] -> lex_r(rest, list.append(tokens, [json.CurlyClose]))
    ["[", ..rest] -> lex_r(rest, list.append(tokens, [json.ArrayOpen]))
    ["]", ..rest] -> lex_r(rest, list.append(tokens, [json.ArrayClose]))
    [":", ..rest] -> lex_r(rest, list.append(tokens, [json.Colon]))
    [",", ..rest] -> lex_r(rest, list.append(tokens, [json.Comma]))
    _ -> panic
  }
}
