import gleam/regexp.{Options, check, compile}
import gleam/string

pub fn parse_map_from_json(input: String) -> String {
  input
  |> string.to_graphemes()
  |> parse_json("")
}

fn parse_json(char_list: List(String), acc: String) -> String {
  case char_list {
    ["{", ..rest] -> parse_json(rest, string.concat([acc, "%{"]))
    ["}", ..rest] -> parse_json(rest, string.concat([acc, "}"]))
    // [number(first(char_list)), ..rest] -> parse_json(rest(char_list))
    _ -> acc
  }
}

fn number(char: String) {
  let options = Options(case_insensitive: True, multi_line: False)
  let assert Ok(number_pattern) = compile("^[0-9]+$", with: options)

  check(with: number_pattern, content: char)
}

fn word(char: String) {
  let options = Options(case_insensitive: True, multi_line: False)
  let word_pattern = compile("^[a-zA-Z]+$", with: options)
}

fn testy(char_list: List(String)) {
  todo
}
