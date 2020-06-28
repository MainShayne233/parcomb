import gleam/result
import maybe.{Just, Nothing}
import parsable.{Parsable}
import util.{is_alphanumeric}

pub type ParseResult(t) =
  Result(tuple(Parsable, t), Parsable)

pub type Parser(t) =
  fn(Parsable) -> ParseResult(t)

pub type Element {
  Element(
    name: String,
    attributes: List(tuple(String, String)),
    children: List(Element),
  )
}

pub fn the_letter_a(input: Parsable) -> ParseResult(Parsable) {
  case parsable.chop_head(input) {
    Just(tuple(head, rest)) if head == Parsable("a") -> Ok(tuple(rest, head))
    _ -> Error(input)
  }
}

pub fn match_literal(expected: Parsable) -> Parser(Parsable) {
  let expected_length = parsable.length(expected)
  fn(input: Parsable) {
    case parsable.split_at(input, expected_length) {
      tuple(actual, rest) if actual == expected -> Ok(tuple(rest, actual))
      _ -> Error(input)
    }
  }
}

pub fn identifier(input: Parsable) -> ParseResult(Parsable) {
  let is_ident_char = fn(char: String) -> Bool {
    is_alphanumeric(char) || char == "-"
  }

  case parsable.split_while(input, is_ident_char) {
    tuple(match, rest) if match != Parsable("") -> Ok(tuple(rest, match))
    _ -> Error(input)
  }
}

pub fn pair(lhs: Parser(a), rhs: Parser(b)) -> Parser(tuple(a, b)) {
  fn(input: Parsable) {
    input
    |> lhs()
    |> result.then(
      fn(lhs_result) {
        let tuple(lhs_rest, lhs_match) = lhs_result

        lhs_rest
        |> rhs()
        |> result.map(
          fn(rhs_result) {
            let tuple(rhs_rest, rhs_match) = rhs_result

            tuple(rhs_rest, tuple(lhs_match, rhs_match))
          },
        )
      },
    )
  }
}

pub fn map(parser: Parser(a), fun: fn(a) -> b) -> Parser(b) {
  fn(input: Parsable) {
    case parser(input) {
      Ok(tuple(rest, match)) -> Ok(tuple(rest, fun(match)))
      Error(err) -> Error(err)
    }
  }
}
