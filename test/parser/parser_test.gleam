import gleeunit
import gleeunit/should
import parser/parser

pub fn main() {
  gleeunit.main()
}

pub fn parse_map_from_json_test() {
  "%{}"
  |> should.equal(parser.parse_map_from_json("{}"))
  // "%{name: \"john\"}"
  // |> should.equal(parser.parse_map_from_json("{\"name\": \"john\"}"))
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}
