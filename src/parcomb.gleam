import gleam/list
import gleam/result
import maybe.{Just, Nothing}
import parsable.{Parsable}
import util.{is_alphabetic, is_alphanumeric, is_whitespace}

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

fn tuple_lhs(value: tuple(a, b)) -> a {
  let tuple(lhs_val, _) = value
  lhs_val
}

fn tuple_rhs(value: tuple(a, b)) -> b {
  let tuple(_, rhs_val) = value
  rhs_val
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

pub fn letter(input: Parsable) -> ParseResult(Parsable) {
  case parsable.chop_head(input) {
    Just(tuple(head, rest)) -> case is_alphabetic(parsable.to_string(head)) {
      True -> Ok(tuple(rest, head))
      False -> Error(input)
    }
    Nothing -> Error(input)
  }
}

pub fn identifier(input: Parsable) -> ParseResult(Parsable) {
  let is_ident_char = fn(char: String) -> Bool {
    is_alphanumeric(char) || char == "-"
  }

  try tuple(rest, head) = letter(input)
  let tuple(tail, rest) = parsable.split_while(rest, is_ident_char)
  Ok(tuple(rest, parsable.concat(head, tail)))
}

pub fn pair(lhs: Parser(a), rhs: Parser(b)) -> Parser(tuple(a, b)) {
  fn(input: Parsable) {
    try tuple(lhs_rest, lhs_match) = lhs(input)
    try tuple(rhs_rest, rhs_match) = rhs(lhs_rest)
    Ok(tuple(rhs_rest, tuple(lhs_match, rhs_match)))
  }
}

pub fn map(parser: Parser(a), fun: fn(a) -> b) -> Parser(b) {
  fn(input: Parsable) {
    try tuple(rest, match) = parser(input)
    Ok(tuple(rest, fun(match)))
  }
}

pub fn left(lhs: Parser(a), rhs: Parser(b)) -> Parser(a) {
  pair(lhs, rhs)
  |> map(tuple_lhs)
}

pub fn right(lhs: Parser(a), rhs: Parser(b)) -> Parser(b) {
  pair(lhs, rhs)
  |> map(tuple_rhs)
}

fn do_zero_to_many(
  parser: Parser(a),
  input: Parsable,
  matches: List(a),
) -> tuple(Parsable, List(a)) {
  case parser(input) {
    Ok(tuple(rest, match)) -> do_zero_to_many(parser, rest, [match, ..matches])
    _ -> tuple(input, list.reverse(matches))
  }
}

pub fn one_or_more(parser: Parser(a)) -> Parser(List(a)) {
  fn(input: Parsable) {
    try tuple(rest, match) = parser(input)
    Ok(do_zero_to_many(parser, rest, [match]))
  }
}

pub fn zero_or_more(parser: Parser(a)) -> Parser(List(a)) {
  fn(input: Parsable) { Ok(do_zero_to_many(parser, input, [])) }
}

pub fn any_char(input: Parsable) -> ParseResult(Parsable) {
  case parsable.chop_head(input) {
    Just(tuple(head, rest)) if head != Parsable("") -> Ok(tuple(rest, head))
    _ -> Error(input)
  }
}

pub fn pred(parser: Parser(a), predicate: fn(a) -> Bool) -> Parser(a) {
  fn(input: Parsable) {
    try tuple(rest, match) = parser(input)
    case predicate(match) {
      True -> Ok(tuple(rest, match))
      False -> Error(input)
    }
  }
}

pub fn whitespace_char() -> Parser(Parsable) {
  pred(
    any_char,
    fn(char: Parsable) {
      char
      |> parsable.to_string()
      |> is_whitespace()
    },
  )
}

pub fn space1() -> Parser(List(Parsable)) {
  one_or_more(whitespace_char())
}

pub fn space0() -> Parser(List(Parsable)) {
  zero_or_more(whitespace_char())
}

pub fn quoted_string() -> Parser(Parsable) {
  map(
    right(
      match_literal(Parsable("\"")),
      left(
        zero_or_more(
          pred(any_char, fn(c: Parsable) { parsable.to_string(c) != "\"" }),
        ),
        match_literal(Parsable("\"")),
      ),
    ),
    parsable.flatten,
  )
}

pub fn attribute_pair() -> Parser(tuple(Parsable, Parsable)) {
  pair(identifier, right(match_literal(Parsable("=")), quoted_string()))
}

pub fn attributes() -> Parser(List(tuple(Parsable, Parsable))) {
  zero_or_more(right(space1(), attribute_pair()))
}
