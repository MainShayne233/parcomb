import maybe.{Just, Nothing}
import parsable.{Parsable}

pub type ParseResult =
  Result(tuple(Parsable, Parsable), Parsable)

pub type Parser =
  fn(Parsable) -> ParseResult

pub type Element {
  Element(
    name: String,
    attributes: List(tuple(String, String)),
    children: List(Element),
  )
}

pub fn the_letter_a(input: Parsable) -> ParseResult {
  case parsable.chop_head(input) {
    Just(tuple(head, rest)) if head == Parsable("a") -> Ok(tuple(rest, head))
    _ -> Error(input)
  }
}

pub fn match_literal(expected: Parsable) -> Parser {
  let expected_length = parsable.length(expected)
  fn(input: Parsable) {
    case parsable.split_at(input, expected_length) {
      tuple(actual, rest) if actual == expected -> Ok(tuple(rest, actual))
      _ -> Error(input)
    }
  }
}
